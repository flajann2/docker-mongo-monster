#!/bin/bash
# Run and link the shard cluster
# parameters:
# 

# Parameters
CLUSTER=$1
SVS=$2
SH_PER_SV=$3
FLUME_SV=$4 #opt

if [[ -z $CLUSTER ]]; then
  echo "./run-shard-cluster.sh CLUSTER-NAME NUM-SHARD-SERVERS NUM-SHARD-PER-SERVER FLUME-SERVERSopt"  
  exit
fi


# Docker Repo login
REPO="docker-repo:2061"
RUSER='prioridata'
RPASS='WeL0veData'
EMAIL='fred@prioridata.com'

CFG_PORT=27019
BEGIN_SHARD_PORT=28000
let "END_SHARD_PORT = $BEGIN_SHARD_PORT + $SH_PER_SV - 1"
ZONE="us-central1-a"
BOOTDISKTYPE="pd-ssd"
SDEV=(none /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg /dev/sdh)
LSSDSIZE=373

# Output of useful info
SHARDFILE="shards.list"
SHARDJS="add-shards.js"
CFGFILE="configs.list"
FLUMEFILE="flumes.list"
SERVERFILE="servers.list"

# start afresh
rm    $SHARDFILE $SHARDJS $CFGFILE $FLUMEFILE $SERVERFILE &> /dev/null
touch $SHARDFILE $SHARDJS $CFGFILE $FLUMEFILE $SERVERFILE

# Launch a Google Docker Server Instance
function launch_sv { # name machinetype localssds data%opt metadata%opt work%opt moreops_opt
    name=$1
    machinetype=$2
    localssds=$3

    # if any of the following are given, they all must be given, and tally to 100
    datacent=$4
    metacent=$5
    workcent=$6

    # Optional parameters to pass to gcloud compute instance create
    moreopts=$7

    if [[ -z $datacent  ]]; then
        datacent=95
        metacent=5
        workcent=0
    fi

    lsd=''
    for i in $(seq $localssds); do
        lsd="$lsd --local-ssd interface=SCSI "
    done
    
    echo "Creating $name as $machinetype with $localssds local SSDs"
    echo $name >> $SERVERFILE

    gcloud compute instances create $name \
        --image template-docker-centos7-image \
        --description="generated by run-shard-cluster.sh" \
        --zone=$ZONE \
        --boot-disk-type=$BOOTDISKTYPE \
        --machine-type=$machinetype \
        $moreopts $lsd

    sleep 30
    echo "Base configuration of $name"
    gcutil ssh $name <<EOF
sudo su -
echo never > /sys/kernel/mm/transparent_hugepage/enabled
lvmetad
EOF

    lvmcanidates=''
    for i in $(seq $localssds); do
        gcutil ssh $name <<EOF
sudo pvcreate ${SDEV[i]}
EOF
        lvmcanidates="$lvmcanidates ${SDEV[i]}"
    done

    if (($localssds > 0)); then
        let "ssize = $LSSDSIZE * $localssds"
        gcutil ssh $name <<EOF
sudo su -
vgcreate ssdvol $lvmcanidates

lvcreate --wipesignatures y -n data ssdvol -l ${datacent}%VG
lvcreate --wipesignatures y -n metadata ssdvol -l ${metacent}%VG
if (( $workcent > 0 )); then
    lvcreate --wipesignatures y -n work ssdvol -l ${workcent}%VG
    mkfs.xfs /dev/ssdvol/work
    mkdir /work
    mount /dev/ssdvol/work /work
    ln -s /work /data
    echo "/dev/ssdvol/work /work defaults,barrier=0 1 1" >> /etc/fstab
fi

service docker start && docker login --email=$EMAIL --password=$RPASS --username=$RUSER https://$REPO
EOF
    fi
}

function launch_cfg { # (name, image)
    name=$1
    image=$2
    other=$3
    echo "launch_cfg($name, $image)"
    echo "$name:$CFG_PORT" >>$CFGFILE
    launch_sv $name n1-standard-1 1 '' '' '' "--no-address"
    gcutil ssh $name <<EOF
sudo su -
docker pull $REPO/$image
docker run --name=$name -d --net='host' --publish=$CFG_PORT:$CFG_PORT $REPO/$image
EOF
}

function launch_shs { # (name, image)
    name=$1
    image=$2
    other=$3
    echo "launch_shs($name, $image)"
    launch_sv $name n1-highmem-4 2  '' '' '' "--no-address"
    gcutil ssh $name <<EOF
sudo su -
docker pull $REPO/$image
EOF

for port in $(seq $BEGIN_SHARD_PORT $END_SHARD_PORT);  do
    echo "${name}:${port}" >>$SHARDFILE
    echo "sh.addShard(\"${name}:${port}\");" >>$SHARDJS
    gcutil ssh $name "sudo docker run --name=${name}-${port} -d --publish=$port:27017 $REPO/$image"
done
}

# this function assumes parallelism and must check for FLUMEFILE to not only exist, 
# but to have exactly 3 entries.
function launch_flume_sv { # (name, image)
    name=$1
    image=$2
    other=$3
    echo "launch_flume_sv($name, $image)"

    launch_sv $name n1-highmem-4 2 4 1 95
    gcutil ssh $name "sudo docker pull $REPO/$image"

    # Loop around until we get what we want.
    while [ $(wc -l <$CFGFILE) -lt 3 ]; do
        echo -n '.'
        sleep 2
    done    

    cfgs=''
    c=''
    for s in $(sort $CFGFILE); do
        cfgs="$cfgs$c$s"
        c=','
    done
    echo "CONFIG Servers: $cfgs"

    gcutil ssh $name <<EOF
sudo su -
docker run --name=mongos -d --net=host --publish=27017:27017 $REPO/$image --configdb $cfgs
EOF
    echo "$name" >> $FLUMEFILE
}

echo "Creating and running for cluster $CLUSTER: shards servers: $SVS, shards per server: $SH_PER_SV"

###############################################################
# NOTE WELL
# Firstly, TokuMX requires that transparent hugepages disabled.
# for dockers, this must be done on the HOST system.
sudo echo never > /sys/kernel/mm/transparent_hugepage/enabled

# Start the all-important DNS server for this host's cluster.
# TODO: Use the Ambassador pattern to tie together a cluster across
# multiple boxen.
#docker run --name=pdns.srv -d --hostname=pdns.srv pdns
#getip pdns.srv
#PDNS=$ip
#sleep 30

# Register the name server with itself (later we'll use this)
#register pdns.srv
#echo "PDNS Server is on $PDNS"

# Config servers
for i in $(seq 0 2); do
    launch_cfg ${CLUSTER}-cfg$i tokumx/toks-config &
done


# Actual shards (should be repl clusters, but for now...)
for i in $(seq 0 $(($SVS - 1)) ); do
    launch_shs ${CLUSTER}-shs$i tokumx/toks-rep &
done

# flume baby servers (should be repl clusters, but for now...)
if (( $FLUME_SV )); then
    for i in $(seq 0 $(($FLUME_SV - 1)) ); do
        launch_flume_sv ${CLUSTER}-flume-baby$i tokumx/toks-s &
    done
fi
