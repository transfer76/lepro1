require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3' 

def init_db
	@db = SQLite3::Database.new 'lepro1.db'
	@db.results_as_hash = true
end

before do
	init_db
end

# configure вызывается каждый раз при конфигурации приложения
# когда изменился код программы и перезагрузилась страница
configure do
	# инициализация БД
	init_db

	# создаёт таблицу если таблица не существует
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts
	(
		id INTEGER PRIMARY KEY AUTOINCREMENT, 
		created_date DATE, content TEXT
	)'
end	

get '/' do
	#выбираем список постов из базы данных
    @results = @db.execute 'select * from Posts order by 
                            id desc'

	erb :index
end

#обработчик get-запроса /new
# (браузер получает страницу с сервера)
get '/new' do
 	erb :new
end

post '/new' do
  	content=params[:content]

  	if content.length <=0
  		@error = 'Type post text'
  		return erb :new
  	end

  	#сохранение данных в БД
  	@db.execute "insert into Posts (content, created_date) 
  	             values (?, datetime())", [content]

  	# перенаправление на главную страницу
  	redirect to '/'            
  	erb "You typed #{content}"
end

#вывод информации о посте

get '/details/:post_id' do
	post_id = params[:post_id]

	erb "Displaying informaition for post id #{post_id}"
end
