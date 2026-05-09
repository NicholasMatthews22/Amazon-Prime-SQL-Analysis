-- Q1: Top 10 Movies by IMDB Score
SELECT title, type, imdb_score
FROM titles
WHERE type = 'MOVIE'
AND imdb_score IS NOT NULL
ORDER BY imdb_score DESC
LIMIT 10;

-- Q2: Bottom 10 Movies by IMDB Score
SELECT title, type, imdb_score
FROM titles
WHERE type = 'MOVIE'
AND imdb_score IS NOT NULL
ORDER BY imdb_score ASC
LIMIT 10;

-- Q3: Top 10 Shows by IMDB Score
SELECT title, type, imdb_score
FROM titles
WHERE type = 'SHOW'
AND imdb_score IS NOT NULL
ORDER BY imdb_score DESC
LIMIT 10;

-- Q4: Bottom 10 Shows by IMDB Score
SELECT title, type, imdb_score
FROM titles
WHERE type = 'SHOW'
AND imdb_score IS NOT NULL
ORDER BY imdb_score ASC
LIMIT 10;

-- Q5: Average IMDB Score by Type (Movies vs Shows)
SELECT type, ROUND(AVG(imdb_score), 2)
FROM titles
GROUP BY type;

-- Q6: Top 10 Genre Combinations by Average IMDB Score
SELECT genres, ROUND(AVG(imdb_score), 2)
FROM titles
WHERE genres IS NOT NULL
AND imdb_score IS NOT NULL
GROUP BY genres
ORDER BY imdb_score DESC
LIMIT 10;

-- Q7: Top 10 Production Countries by Content Volume
SELECT production_countries, COUNT(*)
FROM titles
GROUP BY production_countries
ORDER BY COUNT(*) DESC
LIMIT 10;

-- Q8: Most Frequently Appearing Actors
SELECT name, COUNT(*) as appearances
FROM credits
WHERE role = 'ACTOR'
GROUP BY name
ORDER BY appearances DESC
LIMIT 10;

-- Q9: Directors with Highest Average IMDB Score (min. 2 titles)
SELECT name, ROUND(AVG(t.imdb_score), 2) as avg_score, COUNT(*) as titles
FROM credits c
JOIN titles t ON c.id = t.id
WHERE c.role = 'DIRECTOR'
AND t.imdb_score IS NOT NULL
GROUP BY name
HAVING COUNT(*) >= 2
ORDER BY avg_score DESC
LIMIT 10;

-- Q10: Content Count by Decade
SELECT CONCAT(FLOOR(release_year / 10) * 10, 's') AS decade,
COUNT(*) AS count
FROM titles
GROUP BY decade
ORDER BY decade;

-- Q11: Average IMDB Score by Age Certification
SELECT age_certification, ROUND(AVG(imdb_score), 2) as avg_score, COUNT(*) as titles
FROM titles
WHERE age_certification IS NOT NULL
AND imdb_score IS NOT NULL
GROUP BY age_certification
ORDER BY avg_score DESC;