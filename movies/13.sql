DROP TABLE IF EXISTS namenew;
CREATE TABLE namenew (
    name VARCHAR(255)
);

INSERT INTO namenew
    (name)

SELECT DISTINCT name FROM people WHERE id IN(

SELECT DISTINCT person_id FROM stars WHERE movie_id IN(

SELECT movies.id FROM movies
JOIN stars ON movies.id = stars.movie_id
JOIN people ON people.id = stars.person_id
WHERE people.name = "Kevin Bacon" AND people.birth = 1958))
ORDER BY name;

DELETE FROM namenew
WHERE name = "Kevin Bacon";

SELECT * FROM namenew;