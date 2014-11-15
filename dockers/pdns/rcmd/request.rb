#!/usr/bin/env ruby
# Simple add / delete name to name server.

=begin rdoc
=NOTE WELL
This script is not fool-proof as it does
no sanity checking, so it is quite possible to pollute the DNS
namespace with garbage if you are so inclined.
=end

# To get around Sinatra's annoying Rack protections, I had
# to put these lines here like this. In this way the database
# is opened BEFORE the Sinatra cops get here!!!!!
require 'sqlite3'
include SQLite3
@@dbcon = Database.open "/db/pdns.db"

# Nothing to see here. Move it along. 

require 'sinatra'

def dbase
  begin
    return yield @@dbcon
  ensure
    #dbcon.close
  end
end

configure do
  set bind: '0.0.0.0'
  set port: 2001
  set threaded: true
  disable :protection
end

get '/status' do
  dbase do |db|
    db.prepare(%{
                   SELECT r.name, r.content
                   FROM records AS r JOIN domains AS d ON (r.domain_id = d.id)  
                   WHERE d.name = "srv" AND r.type = 'A'
                }).execute.map{ |row| row.join('-->')}.join('<br>')
  end
end

post '/name/:name/ip/:ip' do
  name = params[:name]
  ip = params[:ip]
  dbase do |db|
    db.execute(%{
                  REPLACE INTO records 
                         (domain_id, name,     type, ttl, content)
                  SELECT  d.id,     '#{name}', 'A',   60, '#{ip}'
                    FROM domains AS d 
                       LEFT JOIN records AS r 
                         ON (d.id = r.domain_id AND r.name = '#{name}' AND r.type = 'A')
                    WHERE d.name = 'srv'
                })
  end
  "Added / modifeid name is #{name} and the ip is #{ip}"
end

delete '/name/:name' do
  name = params[:name]
  dbase do |db|
    db.execute(%{
                  DELETE FROM records
                    WHERE name = '#{name}'
                          AND type = 'A'
                })
  end
  "Deleting name is #{params[:name]} and the ip is #{params[:ip]}"
end
