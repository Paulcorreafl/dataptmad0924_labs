
-- Lab 03 - Challenge 1

SELECT c.FirstName + ' ' + c.LastName AS [Customer Fullname], p.Name AS [Product Name]
FROM SalesLT.Customer AS c
    INNER JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
    INNER JOIN SalesLT.SalesOrderDetail AS shd ON soh.SalesOrderID = shd.SalesOrderID
    INNER JOIN SalesLT.Product AS p ON shd.ProductID = p.ProductID
ORDER BY [Customer Fullname], [Product Name]


-- Lab 03 - Challenge 2

SELECT  pm.Name AS 'Product Model', pd.[Description]
FROM SalesLT.ProductModel AS pm    
    INNER JOIN SalesLT.ProductModelProductDescription AS pmpd ON pm.ProductModelID = pmpd.ProductModelID
    INNER JOIN SalesLT.ProductDescription AS pd on PD.ProductDescriptionID = pmpd.ProductDescriptionID
    INNER JOIN SalesLT.Product AS p ON p.ProductModelID = pm.ProductModelID
WHERE pmpd.Culture = 'ar' AND p.ProductID = 710;