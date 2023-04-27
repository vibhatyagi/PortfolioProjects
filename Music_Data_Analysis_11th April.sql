-- Senior most employee based on Job title

SELECT Top 1 *
FROM dbo.employee$
ORDER BY levels desc

--  Which countries have the most Invoices

SELECT billing_country, COUNT(total) as Total_Invoices
FROM dbo.invoice$
GROUP BY billing_country
ORDER BY Total_Invoices desc

-- Top 3 values of total invoices

SELECT TOP 3 *
FROM dbo.invoice$
ORDER BY total DESC

-- Which city has the best customers? 

SELECT SUM(total) as Invoice_total, billing_city
FROM invoice$
GROUP BY billing_city
ORDER BY Invoice_total desc

-- Who is the best customer; the customer who has spent the more money will be declared as best customer.

SELECT TOP 1 dbo.customer$.customer_id, dbo.customer$.first_name, dbo.customer$.last_name, SUM(dbo.invoice$.total) as Total
FROM dbo.customer$
JOIN dbo.invoice$ ON dbo.customer$.customer_id = dbo.invoice$.customer_id
GROUP BY dbo.customer$.customer_id, dbo.customer$.first_name, dbo.customer$.last_name
ORDER BY Total DESC

-- All Rock Music listeners

SELECT *
FROM dbo.genre$

SELECT *
FROM customer$

SELECT DISTINCT email, first_name, last_name
FROM dbo.customer$
JOIN dbo.invoice$ ON dbo.invoice$.customer_id = dbo.customer$.customer_id
JOIN dbo.invoice_line$ ON dbo.invoice_line$.invoice_id = dbo.invoice$.invoice_id
WHERE track_id IN(
	SELECT track_id FROM dbo.track$
	JOIN dbo.genre$ ON dbo.track$.genre_id = dbo.genre$.genre_id
	WHERE dbo.genre$.name LIKE 'Rock'
)
ORDER BY email

--Artist who have written the most rock music in dataset, should return the artist name and total track count of the top 10 rock bands.

SELECT *
FROM dbo.track$

SELECT * FROM artist$

SELECT TOP 10 dbo.artist$.name, COUNT(artist$.artist_id) AS number_of_songs
FROM dbo.track$
JOIN dbo.album$ ON dbo.album$.album_id = dbo.track$.album_id
JOIN dbo.artist$ ON dbo.artist$.artist_id = dbo.album$.artist_id
JOIN dbo.genre$ ON dbo.genre$.genre_id = dbo.track$.genre_id
WHERE dbo.genre$.name LIKE 'Rock'
GROUP BY dbo.artist$.name
ORDER BY number_of_songs DESC


--Track name that have a song length longer than the average song length, Return the miliseconds for each track.

SELECT dbo.track$.name, dbo.track$.milliseconds
FROM dbo.track$
WHERE milliseconds > (
	SELECT AVG(dbo.track$.milliseconds) as avg_track_length
	FROM dbo.track$)
ORDER BY milliseconds DESC

-- How much amount spent by each customer on artist? return customer name, artist anme and total spent.

SELECT * 
FROM dbo.customer$

SELECT * 
FROM dbo.artist$

SELECT*
FROM dbo.invoice_line$

With best_selling_artist AS (
	SELECT TOP 1 dbo.artist$.artist_id AS artist_id, dbo.artist$.name AS artist_name, SUM(dbo.invoice_line$.unit_price * dbo.invoice_line$.quantity) as total_sales
FROM invoice_line$
	JOIN track$ ON track$.track_id = invoice_line$.track_id
	JOIN album$ ON album$.album_id = track$.album_id
	JOIN artist$ ON artist$.artist_id = album$.artist_id
	GROUP BY dbo.artist$.artist_id, dbo.artist$.name
	ORDER BY 3 DESC
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price * il.quantity) AS amount_spend
FROM dbo.invoice$ i
JOIN dbo.customer$ c ON c.customer_id = i.customer_id
JOIN dbo.invoice_line$ il ON il.invoice_id = i.invoice_id
JOIN dbo.track$ t ON t.track_id = il.track_id
JOIN dbo.album$ alb ON alb. album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC

WITH best_selling_artist AS (
    SELECT  TOP 1
        dbo.artist$.artist_id AS artist_id, 
        dbo.artist$.name AS artist_name, 
        SUM(dbo.invoice_line$.unit_price * dbo.invoice_line$.quantity) AS total_sales
    FROM invoice_line$
    JOIN track$ ON track$.track_id = invoice_line$.track_id
    JOIN album$ ON album$.album_id = track$.album_id
    JOIN artist$ ON artist$.artist_id = album$.artist_id
    GROUP BY dbo.artist$.artist_id, dbo.artist$.name
    ORDER BY 3 DESC
)
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    bsa.artist_name, 
    SUM(il.unit_price * il.quantity) AS amount_spend
FROM dbo.invoice$ i
JOIN dbo.customer$ c ON c.customer_id = i.customer_id
JOIN dbo.invoice_line$ il ON il.invoice_id = i.invoice_id
JOIN dbo.track$ t ON t.track_id = il.track_id
JOIN dbo.album$ alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    bsa.artist_name
ORDER BY 5 DESC

-- Most Popular music genre for each coutry, Most popular genre- highest amount of purchases, 


With most_popular_genre AS
(
	SELECT COUNT(invoice_line$.quantity) AS purchases, customer$.country, genre$.name, genre$.genre_id,
	ROW_NUMBER() OVER(PARTITION BY customer$.country ORDER BY COUNT (invoice_line.quantity) DESC) AS RowNo
	FROM invoice_line$
	JOIN invoice$ ON invoice$.invoice_id = invoice_line$.invoice_id
	JOIN customer$ ON customer$.customer_id =invoice$.customer_id
	JOIN track$ ON track$.track_id = invoice_line$.track_id
	JOIN genre$ ON genre$.genre_id = track$.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM most_popular_genre WHERE RowNo<= 1

