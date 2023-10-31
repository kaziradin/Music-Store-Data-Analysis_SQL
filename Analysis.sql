-- 1. Who is the senior most employee based on the job title? 
SELECT * FROM employee_details 
ORDER BY levels DESC
Limit 1
 
-- Madan Mohan is the most senior employee with job title Senior General Manager 
-- 2. Which country have most invoices? 
 
SELECT 
billing_country,
Count(Distinct invoice_id) AS total_invoice
FROM invoice 
GROUP BY billing_country 
ORDER BY 2 DESC 

 -- USA having the most invoices generate after that canada and Brazil is the second and third 
 
 -- 3.What are top five values of total invoices with country name 
 SELECT * FROM invoice 
 SELECT 
 billing_country, 
 total 
 FROM invoice 
 ORDER BY total DESC
 LIMIT 5
 -- 23.6 is the highest invoice value which is from France  
 
 -- 4. Which city has the best coustomer? we would like to throw a promotionak music festival in the city we made the most money. write a query that returns onw city that has the highest 
 -- sum of invoice totas . Return both the city name and sum of all invoice totals 

 SELECT 
 billing_city, 
 SUM(total) AS total_invoice_value
 FROM invoice 
 GROUP BY billing_city 
 ORDER BY 2 DESC
 LIMIT 5
 
 -- we made the most moey from Prague city  
  
 -- 5. Who is the best customer? The customer who has spent the most money will be declared the best customer.  
 SELECT * FROM customer 
 SELECT * FROM invoice 
 
 SELECT 
 customer.customer_id, 
 customer.first_name, 
 customer.last_name, 
 SUM(invoice.total) AS total_val 
 FROM customer 
 LEFT JOIN invoice 
 ON customer.customer_id=invoice.customer_id 
 GROUP BY 1,2,3
 ORDER BY 4 DESC 
 LIMIT 5 
 
 -- Fratisek wichterlova has spent the most money and it the best customer for this company  
 
 --6. What is email,first name , last name and genre of all rock music listeners.Return the list alphabetically by email starting with A 
 
 CREATE TEMPORARY TABLE join_genre_track AS
 SELECT 
 genre.genre_id, 
 genre.name, 
 track.track_id 
 FROM genre 
 LEFT JOIN track
 ON genre.genre_id=track.genre_id 
 WHERE genre.name='Rock'   
 
 CREATE TEMPORARY TABLE join_inovice_line AS
 SELECT 
 join_genre_track.genre_id, 
 join_genre_track.name, 
 invoice_line.invoice_id 
 FROM join_genre_track 
 JOIN invoice_line
 ON join_genre_track.track_id=invoice_line.track_id 
 
 CREATE TEMPORARY TABLE invoice_genre AS
 SELECT 
 join_inovice_line.genre_id, 
 join_inovice_line.name, 
 invoice.customer_id 
 FROM join_inovice_line 
 JOIN invoice 
 ON  join_inovice_line.invoice_id=invoice.invoice_id 
 
 CREATE TEMPORARY TABLE genre_customer AS
 SELECT 
 invoice_genre.genre_id, 
 invoice_genre.name AS genre_name, 
 customer.customer_id, 
 customer.first_name, 
 customer.last_name, 
 customer.email 
 FROM invoice_genre 
 JOIN customer
 ON invoice_genre.customer_id =customer.customer_id 
 ORDER BY customer.email 
 
 SELECT DISTINCT email, first_name,last_name 
 FROM genre_customer 
 ORDER BY email
 
 -- total 59 Cutomer we have found who are all all rock music listeners 
 
 -- 7. Lets invite the artist who have written the most rock music in our dataset. need to find out the artist name and total tack count of the top 10 rock brands 
 
 CREATE TEMPORARY TABLE  genre_track AS
 SELECT 
 DISTINCT genre.genre_id, 
 genre.name, 
 track.album_id 
 FROM genre 
 LEFT JOIN track 
 ON genre.genre_id=track.genre_id 
 WHERE genre.name='Rock' 
 ORDER BY track.album_id
  
 CREATE TEMPORARY TABLE  genre_album AS
 SELECT 
 genre_track.genre_id, 
 genre_track.name, 
 album.artist_id, 
 album.album_id
 FROM genre_track 
 LEFT JOIN album  
 ON genre_track.album_id= album.album_id 
 ORDER BY album.album_id 
 
 CREATE TEMPORARY TABLE artist_join AS 
 SELECT 
 genre_album.genre_id, 
 genre_album.name AS genre_name, 
 genre_album.album_id,
 genre_album.artist_id, 
 artist.name 
 FROM genre_album 
 LEFT JOIN artist 
 ON genre_album.artist_id=artist.artist_id 
 ORDER BY genre_album.album_id 
  
 SELECT 
 artist_join.artist_id, 
 artist_join.name AS artist_name, 
 COUNT(artist_join.artist_id) AS number_of_songs 
 FROM artist_join 
 GROUP BY 1,2 
 ORDER BY number_of_songs DESC 
 LIMIT 10
  
  -- Led Zeppelin being the top artist who have written the most -14 rock music in our dataset 
  
  -- 8.Return all the track names that have a song length longer then the average song length. Return the name and Milliseconds for each track 
  -- Order by song length with the longest songs listed first
 
 SELECT 
 COUNT(track_id) as number_of_songs, 
 AVG((milliseconds)) AS avg_millisec
 FROM track  
  
  -- Total 3503 songs and avg_millisec 393599.212103910933
  
 SELECT 
 track.name, 
 track.milliseconds
 FROM track 
 WHERE track.milliseconds>393599.212103910933 
 ORDER BY track.milliseconds DESC 
  
 -- Total 494 songs returned where song length longer then the average song length (393599.212103910933) 
  
 -- 9. Find out how much amount spend by each customer on artist? This should return customer name, artist name, and total spent 
 CREATE TEMPORARY TABLE top_artist_customer AS
 SELECT 
 customer.customer_id,
 customer.first_name, 
 customer.last_name, 
 artist.name AS artist_name,
 SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales 
 FROM customer 
 JOIN invoice 
 ON customer.customer_id=invoice.customer_id 
 JOIN invoice_line 
 ON invoice.invoice_id=invoice_line.invoice_id 
 JOIN track 
 ON invoice_line.track_id=track.track_id 
 JOIN album 
 ON track.album_id=album.album_id 
 JOIN artist 
 ON album.artist_id=artist.artist_id 
 GROUP BY 1,2,3,4 
 ORDER BY total_sales DESC 
  
 -- Top selling artist is Queen and top customer is Hugh o'relly 
 
 -- 10. NOW showing the breakdown of the customer spent on the top artist 
 SELECT 
 top_artist_customer.customer_id, 
 top_artist_customer.first_name, 
 top_artist_customer.last_name, 
 top_artist_customer.artist_name, 
 top_artist_customer.total_sales 
 FROM top_artist_customer 
 WHERE top_artist_customer.artist_name= 'Queen' 
 ORDER BY 5 DESC 
  
  -- total 43 customer spent on the artist Queen's song and the highest spender is Huge o'relly 
   
  -- 11. Need to find out the most popular music genre for each country. we determine the popular genre as the genre with the highest amount of purchases.  
  -- Need to write a query that returns each country along with the top genre. For countries where the maximum number of purchases is shared return all genres.  
   
   CREATE TEMPORARY TABLE country_genre_join AS 
   SELECT 
   invoice.billing_country, 
   genre.name, 
   COUNT(invoice_line.quantity) as total_purchase
   FROM genre 
   JOIN track 
   ON genre.genre_id=track.genre_id 
   JOIN invoice_line 
   ON track.track_id=invoice_line.track_id 
   JOIN invoice 
   ON invoice_line.invoice_id=invoice.invoice_id 
   GROUP BY 1,2 
   ORDER BY  
   invoice.billing_country ASC,
   total_purchase DESC 
   
   --total 274 countries return with their total purchase each genre wise
    
   CREATE TEMPORARY TABLE rank_country_join AS
   SELECT 
   country_genre_join.billing_country, 
   country_genre_join.name AS genre_name, 
   country_genre_join.total_purchase,
   RANK () OVER (PARTITION BY country_genre_join.billing_country ORDER BY total_purchase DESC) AS country_rank
   FROM country_genre_join 
   ORDER BY country_genre_join.billing_country ASC 
   
   -- We have rank here the country wise purchase based on the genre 
    
	SELECT 
	rank_country_join.billing_country,
	rank_country_join.genre_name, 
	rank_country_join.total_purchase
	FROM rank_country_join 
	WHERE country_rank=1 
	ORDER BY 1 ASC 
	
	--For each countries(24) where the maximum number of purchases is shared based on genres 
	 
	 --12.Need to write a query that will determines the customer that has spent the most on music for each country.  
	 -- Write a query that returns the country along with the top customer and how much they spent. 
	 -- For countries where the top amount spent is shared, provide all coustomer who spent this amount  
	 
	 CREATE TEMPORARY TABLE customer_spent AS 
	 SELECT 
	 customer.customer_id, 
	 customer.first_name, 
	 customer.last_name, 
	 invoice.billing_country, 
	 SUM(invoice.total) AS total_spent
	 FROM customer 
	 JOIN invoice 
	 ON customer.customer_id=invoice.customer_id 
	 GROUP BY 1,2,3,4 
	 ORDER BY total_spent DESC 
	 
	 --Now we will rank customer based on custry wise spending
	 
	 CREATE TEMPORARY TABLE customer_spent_rank AS
	 SELECT
	 customer_spent.customer_id,
	 customer_spent.first_name,
	 customer_spent.last_name,
	 customer_spent.billing_country, 
	 customer_spent.total_spent, 
	 RANK() OVER(PARTITION BY customer_spent.billing_country ORDER BY customer_spent.total_spent DESC ) AS rank_customer 
	 FROM customer_spent 
	 ORDER BY customer_spent.total_spent DESC 
	 
	 SELECT 
	 customer_id, 
	 first_name, 
	 last_name, 
	 billing_country, 
	 total_spent 
	 FROM customer_spent_rank 
	 WHERE rank_customer=1 
	 ORDER BY billing_country ASC, total_spent DESC  
	  
	 -- In total 24 coutry we have found out who are the number one customer 
	 
	 
	 
	 
	 
	
	 
	 
	 
	
    