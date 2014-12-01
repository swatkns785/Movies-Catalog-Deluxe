require 'pg'
require 'sinatra'
require 'sinatra/reloader'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname:'movies')

    yield(connection)

  ensure
    connection.close
  end
end

get '/' do #homepage

  erb :home
end

get '/actors/index' do #actors main page

  db_connection do |connection|
    @actors = connection.exec('SELECT name, id FROM actors ORDER BY name LIMIT 20 OFFSET 20')
  end
  #binding.pry

  erb :'actors/index'
end

get '/actors/:id' do #actors individual pages

  db_connection do |connection|
    @actor_data = connection.exec("select actors.name, actors.id, movies.title as movie, movies.id as movie_id, cast_members.character as character
    from actors
    join cast_members on actors.id = cast_members.actor_id
    join movies on cast_members.movie_id = movies.id
    where actors.id = #{params[:id]}")
  end
  #binding.pry
  erb :'actors/show'
end

get '/movies/index' do #movies main page

  db_connection do |connection|
    @movies = connection.exec('SELECT title, year, rating, movies.id AS id, genres.name AS genre, studios.name AS studio FROM movies
    JOIN genres ON movies.genre_id = genres.id
    JOIN studios ON movies.studio_id = studios.id ORDER BY title LIMIT 20')
    #binding.pry
  end

  erb :'movies/index'
end

get '/movies/:id' do #movies individual pages
  db_connection do |connection|
    @movie_data = connection.exec("select movies.title, movies.year, movies.rating, studios.name AS studio, genres.name AS genre, actors.name AS actor_name, actors.id AS actor_id, cast_members.character AS character_name
    from movies
    join studios on movies.studio_id = studios.id
    join genres on movies.genre_id = genres.id
    join cast_members on movies.id = cast_members.movie_id
    join actors on cast_members.actor_id = actors.id
    where movies.id = #{params[:id]}")
    #binding.pry
  end

  erb :'movies/show'
end
