-- Write your queries bellow
-- Challenge 1

--- Step 1: Calculate the royalty of each sale for each author and the advance for each author and publication

SELECT
		titles.title_id,
		authors.au_id,
		titles.advance * titleauthor.royaltyper / 100 AS [Advance],
		titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS [Sales_royality]
FROM authors
		INNER JOIN titleauthor ON titleauthor.au_id = authors.au_id
		INNER JOIN titles ON titles.title_id = titleauthor.title_id
		INNER JOIN sales ON sales.title_id = titleauthor.title_id
        
        
--- Step 2: Aggregate the total royalties for each title and author

SELECT
    	title_id,
    	au_id,
    	SUM(Advance) AS [Total_Advance],
    	SUM(Sales_royality) AS [Total_Sales_Royalties]
FROM (
    SELECT
        titles.title_id,
        authors.au_id,
        titles.advance * titleauthor.royaltyper / 100 AS [Advance],
        titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS [Sales_royality]
    FROM authors
        INNER JOIN titleauthor ON titleauthor.au_id = authors.au_id
        INNER JOIN titles ON titles.title_id = titleauthor.title_id
        INNER JOIN sales ON sales.title_id = titleauthor.title_id
) AS Subquery
GROUP BY title_id, au_id


--- Step 3: Calculate the total profits of each author

SELECT
		q2.au_id,
		SUM(q2.Total_Advance + q2.Total_Sales_Royalties) AS Profits
FROM (
	SELECT
    	q1.title_id,
    	q1.au_id,
    	SUM(q1.Advance) AS [Total_Advance],
    	SUM(q1.Sales_royality) AS [Total_Sales_Royalties]
	FROM (
    	SELECT
        	titles.title_id,
        	authors.au_id,
        	titles.advance * titleauthor.royaltyper / 100 AS [Advance],
        	titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS [Sales_royality]
    	FROM authors
        	INNER JOIN titleauthor ON titleauthor.au_id = authors.au_id
        	INNER JOIN titles ON titles.title_id = titleauthor.title_id
        	INNER JOIN sales ON sales.title_id = titleauthor.title_id
	) as q1
	GROUP BY q1.title_id, q1.au_id) AS q2
GROUP BY q2.au_id
ORDER BY Profits DESC
LIMIT 3



-- Challenge 2: same exercise with different method - temporary tables

CREATE TEMPORARY TABLE royalty_and_advance AS
SELECT
		titles.title_id,
		authors.au_id,
		titles.advance * titleauthor.royaltyper / 100 AS [Advance],
		titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS [Sales_royality]
FROM authors
		INNER JOIN titleauthor ON titleauthor.au_id = authors.au_id
		INNER JOIN titles ON titles.title_id = titleauthor.title_id
		INNER JOIN sales ON sales.title_id = titleauthor.title_id;

		
CREATE TEMPORARY TABLE total_royalty_and_advance AS
SELECT
    	title_id,
    	au_id,
    	SUM(Advance) AS [Total_Advance],
    	SUM(Sales_royality) AS [Total_Sales_Royalties]
FROM royalty_and_advance
GROUP BY title_id, au_id;


SELECT
		au_id,
		SUM(Total_Advance + Total_Sales_Royalties) AS Profits
FROM total_royalty_and_advance
GROUP BY au_id
ORDER BY Profits DESC
LIMIT 3;



-- Challenge 3

CREATE TABLE most_profiting_authors (
			au_id INT,
    		profits DECIMAL(10, 2));
    		
-- Step 1: Create a temporary table to calculate royalties and advances
CREATE TEMPORARY TABLE royalty_and_advance AS
SELECT
        titles.title_id,
        authors.au_id,
        titles.advance * titleauthor.royaltyper / 100 AS [Advance],
        titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100 AS [Sales_royality]
FROM authors
        INNER JOIN titleauthor ON titleauthor.au_id = authors.au_id
        INNER JOIN titles ON titles.title_id = titleauthor.title_id
        INNER JOIN sales ON sales.title_id = titleauthor.title_id;

-- Step 2: Create a temporary table to calculate the total advance and royalties
CREATE TEMPORARY TABLE total_royalty_and_advance AS
SELECT
        title_id,
        au_id,
        SUM(Advance) AS [Total_Advance],
        SUM(Sales_royality) AS [Total_Sales_Royalties]
FROM royalty_and_advance
GROUP BY title_id, au_id;

-- Step 3: Insert the top 3 profiting authors into the permanent table
INSERT INTO most_profiting_authors (au_id, profits)
SELECT
        au_id,
        SUM(Total_Advance + Total_Sales_Royalties) AS Profits
FROM total_royalty_and_advance
GROUP BY au_id
ORDER BY Profits DESC
LIMIT 3;