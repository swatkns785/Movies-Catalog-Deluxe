-- Get a specific movie by id with the studio and genre name
select movies.title, movies.year, movies.rating, studios.name AS studio, genres.name AS genre, actors.name AS actor_name, cast_members.character AS character_name
from movies
join studios on movies.studio_id = studios.id
join genres on movies.genre_id = genres.id
join cast_members on movies.id = cast_members.movie_id
join actors on cast_members.actor_id = actors.id
 LIMIT 20;

select movies.title, movies.year, movies.rating, studios.name AS studio, genres.name AS genre
from movies
join studios on movies.studio_id = studios.id
join genres on movies.genre_id = genres.id
join cast_members on movies
where movies.id = 11;

select actors.name, actors.id, movies.title as movie, cast_members.character as character
from actors
join cast_members on actors.id = cast_members.actor_id
join movies on cast_members.movie_id = movies.id
where actors.id = 15;
