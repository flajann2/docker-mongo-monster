use flume_production

var ca = db.apps.aggregate({$project:{_id: 0, app_id: 1, codes:'$countries.code'}});

while(ca.hasNext()) {
    e = ca.next();
    print(e.app_id, ',', e.codes);
}
