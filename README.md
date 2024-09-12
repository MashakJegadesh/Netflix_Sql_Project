# Netflix Movies and TV Shows Data Analysis Using Sql Server 
Netflix Titles Analysis Project
Overview
This project involves analyzing the Netflix catalog to gain insights into content distribution, genres, ratings, and other key metrics. The database [dbo].[netflix_titles] contains detailed information about various Netflix titles, including their type (movie or TV show), ratings, release year, country, genre, and more.

Queries and Business Problems
1. Count The Number of Movies and TV Shows


SELECT type, COUNT(*) AS No_of_movies_and_tv_shows
FROM [dbo].[netflix_titles]
GROUP BY type;
This query counts the number of movies and TV shows in the dataset, grouped by their type.

2. Find the Most Common Rating for Movies and TV Shows


SELECT type, rating
FROM (
    SELECT type, rating, COUNT(*) AS rating_count,
           RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rnk
    FROM [dbo].[netflix_titles]
    GROUP BY type, rating
) AS subquery
WHERE rnk = 1;
This query identifies the most common rating for both movies and TV shows by ranking ratings within each type.

3. List All Movies Released in a Specific Year


SELECT * FROM [dbo].[netflix_titles]
WHERE type = 'movie' AND release_year = 2020;
This query retrieves all movies released in the year 2020.

4. Find the Top 5 Countries with Most Content on Netflix


SELECT TOP 5 
    TRIM(value) AS country, 
    COUNT(show_id) AS total_content
FROM [dbo].[netflix_titles]
CROSS APPLY STRING_SPLIT(country, ',')
GROUP BY TRIM(value)
ORDER BY total_content DESC;
This query lists the top 5 countries with the most content on Netflix.

5. Longest Runtime Movies


SELECT * FROM [dbo].[netflix_titles]
WHERE type = 'movie' AND duration = (SELECT MAX(duration) FROM [dbo].[netflix_titles]);
This query finds the movie with the longest runtime.

6. Find the Content Added in the Last 5 Years


SELECT * 
FROM [dbo].[netflix_titles]
WHERE date_added >= DATEADD(year, -5, GETDATE());
This query lists all content added to Netflix in the last 5 years.

7. Find All Movies/TV Shows Directed by Rajiv Chilaka


SELECT type, title
FROM [dbo].[netflix_titles]
WHERE director = 'Rajiv Chilaka';
This query retrieves movies and TV shows directed by Rajiv Chilaka.

8. List All TV Shows with More Than 5 Seasons


SELECT *
FROM [dbo].[netflix_titles]
WHERE type = 'TV Show'
AND CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) > 5;
This query lists all TV shows with more than 5 seasons.

9. Count the Number of Content in Each Genre


SELECT COUNT(show_id) AS content,
       TRIM(value) AS listed_in
FROM [dbo].[netflix_titles]
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY TRIM(value)
ORDER BY content DESC;
This query counts the number of titles in each genre.

10. Average Movies per Year by India


SELECT 
    YEAR(date_added) AS year_added, 
    COUNT(*) AS total_titles,
    (CAST(COUNT(*) AS FLOAT) / 
     (SELECT COUNT(*) FROM [dbo].[netflix_titles] WHERE country = 'India')) AS avg_ratio
FROM [dbo].[netflix_titles]
GROUP BY YEAR(date_added);
This query calculates the average number of movies added per year in India.

11. Movies Belonging to Documentaries


SELECT * FROM [dbo].[netflix_titles]
WHERE listed_in LIKE '%documentaries%';
This query retrieves movies listed under the documentary genre.

12. Find All Movies Without Directors


SELECT * FROM [dbo].[netflix_titles]
WHERE director IS NULL;
This query lists movies that do not have a director specified.

13. Movies by Salman Khan Appeared in the Last 10 Years


SELECT * 
FROM [dbo].[netflix_titles]
WHERE casts LIKE '%Salman Khan%'
AND release_year > YEAR(GETDATE()) - 10;
This query finds movies featuring Salman Khan that have appeared in the last 10 years.

14. Top 10 Actors from India


SELECT TOP 10 
    show_id,
    COUNT(*) AS count,
    STRING_AGG(value, ',') AS casts
FROM [dbo].[netflix_titles]
CROSS APPLY STRING_SPLIT(casts, ',') AS split_casts
WHERE country = 'India'
GROUP BY show_id
ORDER BY count DESC;
This query identifies the top 10 actors from India based on the number of titles they appear in.

15. Find Descriptions Containing Specific Keywords


SELECT * FROM [dbo].[netflix_titles]
WHERE description LIKE '%Kill%' OR 
      description LIKE '%violence%' OR
      description LIKE '%bad%' OR
      description LIKE '%good%';
This query retrieves titles with descriptions containing keywords like "Kill", "violence", "bad", or "good".


