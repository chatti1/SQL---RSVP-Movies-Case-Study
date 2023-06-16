-- Using the imdb Database.
USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Counting the number of rows in each table of the schema:
SELECT table_name AS Table_Name,
       table_rows AS Total_Number_of_Rows
FROM   information_schema.tables
WHERE  table_schema = 'imdb';

 

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- Code to find Columns having Null values in movie table:
SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           end) AS id_nulls,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           end) AS title_nulls,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           end) AS year_nulls,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           end) AS date_published_nulls,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           end) AS duration_nulls,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           end) AS country_nulls,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           end) AS worlwide_gross_income_nulls,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           end) AS languages_nulls,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           end) AS production_company_nulls
FROM   movie;

 -- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 


-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- First part of the Question:
SELECT year      AS Year,
       Count(id) AS number_of_movies
FROM   movie
GROUP  BY year;

-- Second part of the Question:
SELECT Month(date_published) AS month_num,
       Count(id)             AS number_of_movies
FROM   movie
GROUP  BY Month(date_published)
ORDER  BY Month(date_published);

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- Query to Count number of movies produced in the USA or INDIA in the year 2019:
SELECT Count(id) AS number_of_movies,
       year
FROM   movie
WHERE  country = 'USA'
        OR country = 'India'
GROUP  BY country
HAVING year = 2019;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre AS Genre
FROM   genre;

-- There are 13 unique movie genres present in the dataset.


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre       AS Genre,
       Count(M.id) AS number_of_movies
FROM   genre AS G
       INNER JOIN movie AS M
               ON G.movie_id = M.id
GROUP  BY genre
ORDER  BY Count(M.id) DESC
LIMIT  1;

-- "Drama" genre has the Highest number of movies produced overall equal to 4285.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH one_genre_movies
     AS (SELECT movie_id,
                Count(genre) AS Genre_Count
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(genre) = 1)
SELECT Count(movie_id) AS One_Genre_Movie_Count
FROM   one_genre_movies;

-- There 3289 movies belonging to only one Genre.


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       Round(Avg(duration), 2) AS avg_duration
FROM   genre AS G
       INNER JOIN movie AS M
               ON G.movie_id = M.id
GROUP  BY genre
ORDER  BY Avg(duration) desc;

-- "Action" Genre has the highest avg_duration of movies among all the Genres. 


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_ranking
     AS (SELECT genre,
                Count(M.id)                    AS movie_count,
                Rank()
                  OVER(
                    ORDER BY Count(M.id) DESC) AS genre_rank
         FROM   genre AS G
                INNER JOIN movie AS M
                        ON G.movie_id = M.id
         GROUP  BY genre)
SELECT *
FROM   genre_ranking
WHERE  genre = "thriller";

-- "Thriller" genre of movies rank 3rd among all the genres in terms of number of movies produced.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH movie_ranks
AS
  (
             SELECT     title,
                        avg_rating,
                        rank() over(ORDER BY avg_rating DESC) AS movie_rank
             FROM       ratings                               AS R
             INNER JOIN movie                                 AS M
             ON         R.movie_id = M.id)
  SELECT *
  FROM   movie_ranks
  WHERE movie_rank<=10;



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
       Count(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY Count(movie_id) DESC;

-- Movies having a median rating of 7 are the highest is number, followed by the movies having median rating of 6. 

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_ranking
     AS (SELECT production_company,
                Count(movie_id)                       AS movie_count,
                Rank()
                  OVER(ORDER BY Count(movie_id) DESC) AS prod_company_rank
         FROM   ratings AS R
                INNER JOIN movie AS M
                        ON R.movie_id = M.id
         WHERE  avg_rating > 8
                AND production_company IS NOT NULL
         GROUP  BY production_company)
SELECT *
FROM   production_company_ranking
WHERE  prod_company_rank = 1;

-- Dream Warrior Pictures and National Theatre Live are the number 1 ranked production house's having produced the most movies having average rating of greater than 8.


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
       Count(M.id) AS movie_count
FROM   genre AS G
       INNER JOIN movie AS M
               ON G.movie_id = M.id
       INNER JOIN ratings AS R
               ON M.id = R.movie_id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country = 'USA'
       AND total_votes > 1000
GROUP  BY genre;

-- "Drama" genre has the highest number of movies released during March 2017 in the USA having more than 1,000 votes.

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title,
       avg_rating,
       genre
FROM   movie AS M
       INNER JOIN ratings AS R
               ON M.id = R.movie_id
       INNER JOIN genre AS G
               ON M.id = G.movie_id
WHERE  title REGEXP "^the"
       AND avg_rating > 8
GROUP  BY title
ORDER  BY avg_rating DESC;

-- There are 8 movies starting with the word ‘The’ and having an average rating greater than 8.


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating,
       Count(*) AS movie_count
FROM   movie AS M
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP  BY median_rating;

-- We have used the BETWEEN operator to find the movies released between 1 April 2018 and 1 April 2019.
-- The number of movies released between 1 April 2018 and 1 April 2019 comes out to be 361.


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Approach 1: country approach
SELECT country,
       Sum(total_votes) AS total_votes
FROM   movie AS M
       INNER JOIN ratings AS R
               ON M.id = R.movie_id
WHERE  country = 'Germany'
        OR country = 'Italy'
GROUP  BY country;


 -- By observation German Movies have more votes than Italian Movies

-- Approach 2: language approach
SELECT languages,
       Sum(total_votes) AS total_votes
FROM   movie AS M
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  languages LIKE '%ITALIAN%'
UNION
SELECT languages,
       Sum(total_votes) AS total_votes
FROM   movie AS M
       INNER JOIN ratings AS R
               ON R.movie_id = M.id
WHERE  languages LIKE '%GERMAN%';

-- By both the Approaches we can see that German movies have received more votes than Italian movies. 

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/



-- Segment 3:


-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- NULL counts for columns of names table using CASE statements
SELECT Sum(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           end) AS name_nulls,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           end) AS height_nulls,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           end) AS date_of_birth_nulls,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           end) AS known_for_movies_nulls
FROM   names;



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genres
AS
  (
             SELECT     genre,
                        count(M.id)                            AS movie_count ,
                        rank() over(ORDER BY count(M.id) DESC) AS genre_rank
             FROM       movie                                  AS M
             INNER JOIN genre                                  AS G
             ON         G.movie_id = M.id
             INNER JOIN ratings AS R
             ON         R.movie_id = M.id
             WHERE      avg_rating > 8
             GROUP BY   genre
             LIMIT      3 )
  SELECT     N.name            AS director_name ,
             count(D.movie_id) AS movie_count
  FROM       director_mapping  AS D
  INNER JOIN genre G
  USING      (movie_id)
  INNER JOIN names AS N
  ON         N.id = D.name_id
  INNER JOIN top_genres
  USING      (genre)
  INNER JOIN ratings AS R
  USING      (movie_id)
  WHERE      avg_rating > 8
  GROUP BY   name
  ORDER BY   movie_count DESC
  LIMIT      3 ;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT N.name          AS actor_name,
       Count(movie_id) AS movie_count
FROM   role_mapping AS RM
       INNER JOIN movie AS M
               ON M.id = RM.movie_id
       INNER JOIN ratings AS R USING(movie_id)
       INNER JOIN names AS N
               ON N.id = RM.name_id
WHERE  R.median_rating >= 8
       AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
LIMIT  2;

-- Mammootty and Mohanlal are the top two actors whose movies have a median rating of greater than or equal to 8.


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT     production_company,
           Sum(total_votes)                            AS vote_count,
           Rank() over(ORDER BY sum(total_votes) DESC) AS prod_comp_rank
FROM       movie                                       AS M
INNER JOIN ratings                                     AS R
ON         R.movie_id = M.id
GROUP BY   production_company
LIMIT      3;

-- Top three production houses based on the number of votes received by their movies are Marvel Studios, Twentieth Century Fox and Warner Bros.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_rank_summary
     AS (SELECT N.NAME                                                     AS
                actor_name
                ,
                total_votes,
                Count(R.movie_id)                                          AS
                   movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
                   actor_avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON M.id = R.movie_id
                INNER JOIN role_mapping AS RM
                        ON M.id = RM.movie_id
                INNER JOIN names AS N
                        ON RM.name_id = N.id
         WHERE  category = 'ACTOR'
                AND country = "india"
         GROUP  BY NAME
         HAVING movie_count >= 5)
SELECT *,
       Rank()
         OVER(
           ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actor_rank_summary;

-- Actor with Rank 1 is Vijay Sethupathi.
-- Actors with Rank 2 and 3 are Fahadh Faasil and Yogi Babu respectively.

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_rank_summary
AS
  (
             SELECT     N.name AS actress_name,
                        total_votes,
                        count(R.movie_id)                                     AS movie_count,
                        round(sum(avg_rating*total_votes)/sum(total_votes),2) AS actress_avg_rating
             FROM       movie                                                 AS M
             INNER JOIN ratings                                               AS R
             ON         M.id = R.movie_id
             INNER JOIN role_mapping AS RM
             ON         M.id = RM.movie_id
             INNER JOIN names AS N
             ON         RM.name_id = N.id
             WHERE      category = 'ACTRESS'
             AND        country = "INDIA"
             AND        languages LIKE '%HINDI%'
             GROUP BY   name
             HAVING     movie_count>=3 )
  SELECT   *,
           rank() over(ORDER BY actress_avg_rating DESC) AS actress_rank
  FROM     actress_rank_summary
  LIMIT    5;
  
-- Actress with Rank 1 based on average rating is Taapsee Pannu.
-- Actress with Rank 2 and 3 based on average rating are Kriti Sanon and Divya Dutta respectively.


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Using CASE statements to classify thriller genre movies on basis of average ratings.

SELECT title,
       R.avg_rating,
       CASE
         WHEN R.avg_rating > 8 THEN"superhit movies"
         WHEN R.avg_rating BETWEEN 7 AND 8 THEN "hit movies"
         WHEN R.avg_rating BETWEEN 5 AND 7 THEN "one-time-watch movies"
         WHEN R.avg_rating < 5 THEN "flop movies"
       END AS avg_rating_category
FROM   movie AS M
       INNER JOIN genre AS G
               ON M.id = G.movie_id
       INNER JOIN ratings AS R
               ON M.id = R.movie_id
WHERE  genre = "thriller"
ORDER  BY R.avg_rating DESC; 
 
/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
       Round(Avg(duration), 2)                      AS avg_duration,
       SUM(Round(Avg(duration), 2))
         over(
           ORDER BY genre ROWS unbounded preceding) AS running_total_duration,
       Avg(Round(Avg(duration), 2))
         over(
           ORDER BY genre ROWS 10 preceding)        AS moving_avg_duration
FROM   movie AS M
       inner join genre AS G
               ON M.id = G.movie_id
GROUP  BY genre
ORDER  BY genre;

/*
Output table:
+-----------+--------------+------------------------+---------------------+
| genre     | avg_duration | running_total_duration | moving_avg_duration |
+-----------+--------------+------------------------+---------------------+
| Action    |       112.88 |                 112.88 |          112.880000 |
| Adventure |       101.87 |                 214.75 |          107.375000 |
| Comedy    |       102.62 |                 317.37 |          105.790000 |
| Crime     |       107.05 |                 424.42 |          106.105000 |
| Drama     |       106.77 |                 531.19 |          106.238000 |
| Family    |       100.97 |                 632.16 |          105.360000 |
| Fantasy   |       105.14 |                 737.30 |          105.328571 |
| Horror    |        92.72 |                 830.02 |          103.752500 |
| Mystery   |       101.80 |                 931.82 |          103.535556 |
| Others    |       100.16 |                1031.98 |          103.198000 |
| Romance   |       109.53 |                1141.51 |          103.773636 |
| Sci-Fi    |        97.94 |                1239.45 |          102.415455 |
| Thriller  |       101.58 |                1341.03 |          102.389091 |
+-----------+--------------+------------------------+---------------------+
*/


-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_3_genres
AS
  (
             SELECT     genre,
                        count(M.id)                            AS movie_count ,
                        rank() over(ORDER BY count(M.id) DESC) AS genre_rank
             FROM       movie                                  AS M
             INNER JOIN genre                                  AS G
             ON         G.movie_id = M.id
             INNER JOIN ratings AS R
             ON         R.movie_id = M.id
             WHERE      avg_rating > 8
             GROUP BY   genre
             ORDER BY   count(M.id) DESC
             LIMIT      3 ), movie_summary
AS
  (
             SELECT     genre,
                        year,
                        title                                                                                                                                      AS movie_name,
                        cast(REPLACE(REPLACE(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10))                                                     AS worlwide_gross_income ,
                        dense_rank() over(partition BY year ORDER BY cast(REPLACE(REPLACE(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS DECIMAL(10)) DESC ) AS movie_rank
             FROM       movie                                                                                                                                      AS M
             INNER JOIN genre                                                                                                                                      AS G
             ON         M.id = G.movie_id
             WHERE      genre IN
                        (
                               SELECT genre
                               FROM   top_3_genres)
             GROUP BY   movie_name )
  SELECT   *
  FROM     movie_summary
  WHERE    movie_rank<=5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_info
AS
  (
             SELECT     production_company,
                        count(*) AS movie_count
             FROM       movie    AS M
             INNER JOIN ratings  AS R
             ON         R.movie_id = M.id
             WHERE      median_rating >= 8
             AND        production_company IS NOT NULL
             AND        position(',' IN languages) > 0
             GROUP BY   production_company
             ORDER BY   movie_count DESC)
  SELECT   *,
           rank() over(ORDER BY movie_count DESC) AS prod_comp_rank
  FROM     production_company_info
  LIMIT    2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_info
AS
  (
             SELECT     N.name                                                AS actress_name,
                        sum(total_votes)                                      AS total_votes,
                        count(R.movie_id)                                     AS movie_count,
                        round(sum(avg_rating*total_votes)/sum(total_votes),2) AS actress_avg_rating
             FROM       movie                                                 AS M
             INNER JOIN ratings                                               AS R
             ON         M.id = R.movie_id
             INNER JOIN role_mapping AS RM
             ON         M.id = RM.movie_id
             INNER JOIN names AS N
             ON         RM.name_id = N.id
             INNER JOIN genre AS G
             ON         G.movie_id = M.id
             WHERE      category = 'ACTRESS'
             AND        avg_rating>8
             AND        genre = "Drama"
             GROUP BY   name )
  SELECT   *,
           rank() over(ORDER BY movie_count DESC) AS actress_rank
  FROM     actress_info
  LIMIT    3;
  


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_info
AS
  (
             SELECT     D.name_id,
                        name,
                        D.movie_id,
                        duration,
                        R.avg_rating,
                        total_votes,
                        M.date_published,
                        lead(date_published,1) over(partition BY D.name_id ORDER BY date_published,movie_id ) AS next_date_published
             FROM       director_mapping                                                                      AS D
             INNER JOIN names                                                                                 AS N
             ON         N.id = D.name_id
             INNER JOIN movie AS M
             ON         M.id = D.movie_id
             INNER JOIN ratings AS R
             ON         R.movie_id = M.id ), top_director_info
AS
  (
         SELECT *,
                datediff(next_date_published, date_published) AS date_difference
         FROM   next_date_published_info )
  SELECT   name_id                       AS director_id,
           name                          AS director_name,
           count(movie_id)               AS number_of_movies,
           round(avg(date_difference),2) AS avg_inter_movie_days,
           round(avg(avg_rating),2)      AS avg_rating,
           sum(total_votes)              AS total_votes,
           min(avg_rating)               AS min_rating,
           max(avg_rating)               AS max_rating,
           sum(duration)                 AS total_duration
  FROM     top_director_info
  GROUP BY director_id
  ORDER BY count(movie_id) DESC
  LIMIT    9;


/*					                                               COMPLETED																*/
/*                                           SUBMITTED BY: Iranna Chatti AND Shyam Dalsaniya.                                               */			