DROP TABLE IF EXISTS namese;
CREATE TABLE namese (
    name VARCHAR(255)
);

INSERT INTO namese
    (name)

SELECT DISTINCT name
FROM people
WHERE id IN
    (SELECT person_id
    FROM stars
    WHERE movie_id IN
        (SELECT id
        FROM movies
        WHERE year = 2004))
ORDER BY birth;

SELECT name FROM namese;