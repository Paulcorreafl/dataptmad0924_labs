-- Write your queries bellow

SELECT 
    a.au_id AS 'AUTHOR ID', 
    a.au_lname AS 'LAST NAME', 
    a.au_fname AS 'FIRST NAME', 
    b.title AS 'TITLE', 
    p.pub_name AS 'PUBLISHER' 
FROM 
    authors a
JOIN 
    titleauthor ta ON a.au_id = ta.au_id  -- Join with titleauthor to link authors and titles
JOIN 
    titles  b ON ta.title_id  = b.title_id      -- Join with books using book_id from titleauthor
JOIN 
    publishers p ON b.pub_id = p.pub_id;  -- Join with publishers using pub_id from books
    
    
 SELECT 
    a.au_id AS 'AUTHOR ID', 
    a.au_lname AS 'LAST NAME', 
    a.au_fname AS 'FIRST NAME', 
    p.pub_name AS 'PUBLISHER', 
    COUNT(b.title) AS 'TITLE COUNT'  -- Count the number of titles for each author at each publisher
FROM 
    authors a
JOIN 
    titleauthor ta ON a.au_id = ta.au_id  -- Join with titleauthor to link authors and titles
JOIN 
    titles b ON ta.title_id = b.title_id   -- Join with titles using title_id from titleauthor
JOIN 
    publishers p ON b.pub_id = p.pub_id    -- Join with publishers using pub_id from titles
GROUP BY 
    a.au_id, a.au_lname, a.au_fname, p.pub_name  -- Group by author ID, last name, first name, and publisher name
ORDER BY 
    a.au_lname, a.au_fname, p.pub_name;  -- Optional: Order the results for better readability
    
      
    
       SELECT COUNT(*) AS 'TOTAL RECORDS IN titleauthor'
   FROM titleauthor;