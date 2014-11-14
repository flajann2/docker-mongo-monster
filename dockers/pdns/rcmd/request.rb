#!/usr/bin/env ruby
# Simple add / delete name to name server.

# To get around Sinatra's annoying Rack protections, I had
# to put these lines here like this. In this way the database
# is opened BEFORE the Sinatra cops get here!!!!!
require 'sqlite3'
include SQLite3
@@dbcon = Database.open "/db/pdns.db"

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
    db.prepare(%{SELECT r.name, r.content
                 FROM records AS r JOIN domains AS d ON (r.domain_id = d.id)  
                 WHERE d.name = "srv" AND r.type = 'A'
                }).execute.map{ |row| row.join('-->')}.join('<br>')
  end
end

post '/name/:name/ip/:ip' do
  "Adding / modifying name is #{params[:name]} and the ip is #{params[:ip]}"
end

delete '/name/:name/ip/:ip' do
  "Deleting name is #{params[:name]} and the ip is #{params[:ip]}"
end
