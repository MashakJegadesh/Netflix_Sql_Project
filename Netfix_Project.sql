----Netflix Project 
Select  top 10 * from [dbo].[netflix_titles]


select count(*)  as total_content from [dbo].[netflix_titles]

select distinct type from [dbo].[netflix_titles]

---15 Business Problems--
--1.Count The number of movies and the tv shows--

select type,count(*) as No_of_movies_and_tv_shows
from [dbo].[netflix_titles]
group by type

--2.Find the most common rating for the movies and tvshows--

SELECT type, rating
FROM (
    SELECT type, rating, COUNT(*) AS rating_count,
           RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rnk
    FROM [dbo].[netflix_titles]
    GROUP BY type, rating
) AS subquery
WHERE rnk = 1;

--3.List all the movies released in specfic year

select * from [dbo].[netflix_titles] 
where type = 'movie' and release_year=2020

--4.Find the top 5 countries most content on netflix--
SELECT TOP 5 
    TRIM(value) AS country, 
    COUNT(show_id) AS total_content
FROM [dbo].[netflix_titles]
CROSS APPLY STRING_SPLIT(country, ',')
GROUP BY TRIM(value)
ORDER BY total_content DESC;

--5.longest runtime movies--

select * from [dbo].[netflix_titles] 
where type='movie' and duration=(select max(duration) from [dbo].[netflix_titles])

 ---6.Find the content added in the last 5 years---

SELECT * 
FROM [dbo].[netflix_titles]
WHERE date_added>=
YEAR(DATEADD(year, -5, GETDATE()));

----7. find all the movies/tv shows directed by director rajiv chilaka--

select type , title
from [dbo].[netflix_titles]
where director = 'Rajiv Chilaka'

---8.List all the tv shows with more than 5 season--

SELECT *
FROM [dbo].[netflix_titles]
WHERE type = 'TV Show'
AND 
CAST(SUBSTRING(duration, 1, CHARINDEX(' ', duration) - 1) AS INT) > 5;

 ---9count the number of content in each genre---

select count(show_id) as content ,
trim(value) as listed_in from [dbo].[netflix_titles]
cross apply string_split(listed_in,',') 
group by trim(value)
order by 1 desc

--10.avg movies per year by india--

SELECT 
    YEAR(date_added) AS year_added, 
    COUNT(*) AS total_titles,
    (CAST(COUNT(*) AS FLOAT) / 
     (SELECT COUNT(*) FROM [dbo].[netflix_titles] WHERE country = 'India')) AS avg_ratio
FROM [dbo].[netflix_titles]
GROUP BY YEAR(date_added);

---11.Movies belongs to documentary--

select * from [dbo].[netflix_titles] 
where listed_in like '%documentaries%'

----- Find all movies without directors--

select * from [dbo].[netflix_titles]
where director is null

---13. how many movies by salman khan appered in last 10 years--

SELECT * 
FROM [dbo].[netflix_titles]
WHERE casts LIKE '%Salman Khan%'
AND release_year > YEAR(GETDATE()) - 10;


---14 top 10 actors from India--
SELECT top 10 
    show_id,
    COUNT(*) AS count,
    STRING_AGG(value, ',') AS casts -- Aggregate the split values back into a comma-separated list
FROM [dbo].[netflix_titles]
CROSS APPLY STRING_SPLIT(casts, ',') AS split_casts
where country='India'
GROUP BY show_id
order by 2 desc
---15.Find description 'Kill' or'vilolence'or 'bad' or 'god'

select * from [dbo].[netflix_titles]
where description like '%Kill%' or 
description like '%violence%' or
description like '%bad%' or
description like '%good%'
