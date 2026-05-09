<h1 align="center">Amazon Prime Video Shows and Movies Project</h1>
<p align="center">
  <img src="https://i.pcmag.com/imagery/reviews/02dIsBiVpmVTMeXkrKxWy0W-13..v1582749138.png" width="600">
</p>

**Tools Used:** SQLite, Excel, Power BI

[Dataset Used](https://www.kaggle.com/datasets/victorsoeiro/amazon-prime-tv-shows-and-movies)

[SQL Analysis (Code)](amazon_prime_analysis.sql)

- **Business Problem:** Amazon Prime Video wants to gather useful insights on their shows and movies for their subscribers. The problem is they are working with a large amount of data across two tables, nearly 10,000 titles and 124,000 cast and crew records, and need a way to effectively analyze and extract meaningful insights from it. They need a data analytics solution to uncover valuable patterns and trends around content quality, audience ratings, country of origin, and talent.

- **How I Plan On Solving the Problem:** Using SQL in DB Browser for SQLite, I will query both the titles and credits datasets to answer key business questions. By leveraging SQL functions like AVG, COUNT, GROUP BY, JOIN, and HAVING, I can uncover metrics such as IMDB ratings, content volume by country and decade, top performing actors and directors, and age certification trends. Once the data has been extracted, I will use Power BI to present the findings through an interactive dashboard.

---

## Questions I Wanted To Answer From the Dataset:

## 1. Which movies and shows on Amazon Prime ranked in the top 10 and bottom 10 based on their IMDB scores?

* Top 10 Movies

```sql
SELECT title, type, imdb_score
FROM titles
WHERE type = 'MOVIE'
AND imdb_score IS NOT NULL
ORDER BY imdb_score DESC
LIMIT 10;
```

Result:

![Q1](https://i.ibb.co/5gqmLM2h/Q1.png)

* Bottom 10 Movies

```sql
SELECT title, type, imdb_score
FROM titles
WHERE type = 'MOVIE'
AND imdb_score IS NOT NULL
ORDER BY imdb_score ASC
LIMIT 10;
```

Result:

![Q2](https://i.ibb.co/My40tWhp/Q2.png)

* Top 10 Shows

```sql
SELECT title, type, imdb_score
FROM titles
WHERE type = 'SHOW'
AND imdb_score IS NOT NULL
ORDER BY imdb_score DESC
LIMIT 10;
```

Result:

![Q3](https://i.ibb.co/tMqz6Bbh/Q3.png)

* Bottom 10 Shows

```sql
SELECT title, type, imdb_score
FROM titles
WHERE type = 'SHOW'
AND imdb_score IS NOT NULL
ORDER BY imdb_score ASC
LIMIT 10;
```

Result:

![Q4](https://i.ibb.co/WWSgw6vJ/Q4.png)

The top 10 movies and shows had some impressive IMDB scores, with Pawankhind leading movies at 9.9 and Water Helps the Blood Run leading shows at 9.7. One thing that stood out is how much Indian cinema dominates the top movie rankings, which shows Amazon Prime has made a strong push into international content. On the flip side, the bottom 10 titles scored as low as 1.1 for movies and 1.3 for shows, highlighting just how wide the quality range is across the platform.

## 2. How does the average IMDB score differ between Movies and Shows?

```sql
SELECT type, ROUND(AVG(imdb_score), 2)
FROM titles
GROUP BY type;
```

Result:

![Q5](https://i.ibb.co/7dhqFYfB/Q5.png)

Shows came in with a noticeably higher average IMDB score at 7.12 compared to movies at 5.8. That is a pretty significant gap and suggests that Amazon Prime's TV catalog tends to be better received by audiences. It could mean that their original and licensed shows are higher quality productions, or simply that the movie library has a lot more low-budget titles pulling the average down.

## 3. Which genre combinations have the highest average IMDB scores?

```sql
SELECT genres, ROUND(AVG(imdb_score), 2)
FROM titles
WHERE genres IS NOT NULL
AND imdb_score IS NOT NULL
GROUP BY genres
ORDER BY imdb_score DESC
LIMIT 10;
```

Result:

![Q6](https://i.ibb.co/sLjK3Hm/Q6.png)

Sport-related and drama-heavy genre combinations tend to score the highest on the platform. Worth noting that genres in this dataset are stored as combined lists rather than individual tags, so the results here reflect full genre combinations rather than single genres. This is a known data limitation that I acknowledged throughout the analysis.

## 4. Which production countries output the most content on Amazon Prime?

```sql
SELECT production_countries, COUNT(*)
FROM titles
GROUP BY production_countries
ORDER BY COUNT(*) DESC
LIMIT 10;
```

Result:

![Q7](https://i.ibb.co/fdgsgDHM/Q7.png)

The United States leads by a wide margin with 4,810 titles, followed by India with 1,048 and the UK with 667. This makes sense given Amazon's roots, but the strong showing from India is notable and lines up with what we saw in the top IMDB scores. Like genres, production countries are also stored as lists in this dataset, which is another noted data limitation.

## 5. Who are the most frequently appearing actors on Amazon Prime?

```sql
SELECT name, COUNT(*) as appearances
FROM credits
WHERE role = 'ACTOR'
GROUP BY name
ORDER BY appearances DESC
LIMIT 10;
```

Result:

![Q8](https://i.ibb.co/ZRDCgBbV/Q8.png)

George 'Gabby' Hayes leads with 49 appearances, followed by Roy Rogers at 45 and Bess Flowers at 44. The fact that the top actors are all classic Hollywood era names tells you something interesting about Amazon Prime's catalog. They clearly have a deep library of older films, particularly westerns from the 1930s and 1940s.

## 6. Which directors have the highest average IMDB score with a minimum of 2 titles?

```sql
SELECT name, ROUND(AVG(t.imdb_score), 2) as avg_score, COUNT(*) as titles
FROM credits c
JOIN titles t ON c.id = t.id
WHERE c.role = 'DIRECTOR'
AND t.imdb_score IS NOT NULL
GROUP BY name
HAVING COUNT(*) >= 2
ORDER BY avg_score DESC
LIMIT 10;
```

Result:

![Q9](https://i.ibb.co/fWXcJ66/Q9.png)

Jeethu Joseph tops the list with an average IMDB score of 8.5 across 2 titles. Seeing James Cameron in the top 10 helps validate that the metric is working correctly. The minimum of 2 titles requirement was important here to make sure the results reflect consistent quality rather than just one great film inflating a director's average.

## 7. How many titles fall into each decade in Amazon Prime's library?

```sql
SELECT CONCAT(FLOOR(release_year / 10) * 10, 's') AS decade,
COUNT(*) AS count
FROM titles
GROUP BY decade
ORDER BY decade;
```

Result:

![Q10](https://i.ibb.co/ksQ4XcMn/Q10.png)

Amazon Prime's catalog goes all the way back to the 1910s which was surprising. Content volume stays relatively modest through most of the 20th century before taking off in the 2000s. The 2010s saw a massive spike with 4,315 titles, which lines up with the global streaming boom and Amazon aggressively building out their library during that period.

## 8. How does average IMDB score vary by age certification?

```sql
SELECT age_certification, ROUND(AVG(imdb_score), 2) as avg_score, COUNT(*) as titles
FROM titles
WHERE age_certification IS NOT NULL
AND imdb_score IS NOT NULL
GROUP BY age_certification
ORDER BY avg_score DESC;
```

Result:

![Q11](https://i.ibb.co/CsYwqG3H/Q11.png)

TV-PG content scores the highest on average at 7.43, with TV-MA close behind at 7.37. R-rated movies actually score the lowest among all certified content at 5.67. This pattern suggests that TV content across the board tends to be better received than movies, which ties back to what we found in question 2.

## Conclusion

This analysis of Amazon Prime Video's content library turned up some genuinely interesting findings. The platform has an extremely wide quality range, from near-perfect 9.9 rated films to titles scoring below 2.0. Shows consistently outperform movies in average IMDB score, pointing to stronger quality in Amazon's TV catalog. The US dominates content volume but India is a strong second, and that shows up in the top IMDB scores as well. The most frequently appearing actors being classic Hollywood names reveals just how deep Amazon's older film catalog runs. Content production exploded in the 2010s, and TV-PG and TV-MA certifications tend to produce the best rated content on the platform overall.
