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

get '/' do #redirects to actor's index
  redirect '/actors/index'
end

get '/actors/index' do #actors main page

  db_connection do |connection|
    @actors = connection.exec('SELECT name FROM actors ORDER BY name')
  end
  #binding.pry

  erb :'actors/index'
end

# get '/actors/:id' do #actors individual pages
#
#   erb :'actors/[:id]'
# end

get '/movies/index' do #movies main page

  db_connection do |connection|
    @movies = connection.exec('SELECT title, year, rating, movies.id AS id, genres.name AS genre, studios.name AS studio FROM movies
    JOIN genres ON movies.genre_id = genres.id JOIN studios ON movies.studio_id = studios.id ORDER BY title')
    #binding.pry
  end

  erb :'movies/index'
end

get '/movies/:id' do #movies individual pages
  db_connection do |connection|
    @movies = connection.exec('SELECT title, year, rating, movies.id AS id, genres.name AS genre, studios.name AS studio FROM movies
    JOIN genres ON movies.genre_id = genres.id JOIN studios ON movies.studio_id = studios.id ORDER BY title')
    binding.pry
  end

  erb :'movies/show'
end
