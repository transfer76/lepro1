require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3' 

def init_db
	@db = SQlite3::Database.new 'lepro1.db'
	@db.results_as_hash = true
end

before do
	init_db
end	

get '/' do
	erb "Hello World"
end

get '/new' do
 	erb :new
end

post '/new' do
  	content=params[:content]
  	erb "You typed #{content}"
end