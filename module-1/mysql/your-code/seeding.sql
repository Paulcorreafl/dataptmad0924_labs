-- Lab 4 - Challenge 1: Qué producto ha sido el más vendido?

SELECT p.Name As [Product], COUNT(*) AS [Total] – aunque más correcto sería hacer COUNT(DISTINCT soh.SalesOrderID)
FROM SalesLT.SalesOrderHeader AS soh 
    INNER JOIN SalesLT.SalesOrderDetail AS shd ON soh.SalesOrderID = shd.SalesOrderID
    INNER JOIN SalesLT.Product AS p ON shd.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY 2 DESC


-- Lab 4 - Challenge 2: Cuántas unidades han sido vendidas por categoría y producto?

SELECT  pc.Name AS [Category], p.name AS Product, SUM(sod.OrderQty) AS [Total Qty]
FROM SalesLT.Product AS p
    INNER JOIN SalesLT.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
    INNER JOIN SalesLT.ProductCategory AS pc ON p.ProductCategoryID = pc.ProductCategoryID
    
GROUP BY  pc.Name, p.Name
ORDER BY 1, 2 



-- Lab 4 - Challenge 3: Cuántas unidades han sido vendidas por categoría, y por categoría producto?

SELECT pc.Name AS [Category],  p.Name As [Product], SUM(shd.OrderQty) AS [Total Qty]
FROM SalesLT.SalesOrderHeader AS soh 
    INNER JOIN SalesLT.SalesOrderDetail AS shd ON soh.SalesOrderID = shd.SalesOrderID
    INNER JOIN SalesLT.Product AS p ON shd.ProductID = p.ProductID
    INNER JOIN SalesLT.ProductCategory AS pc ON p.ProductCategoryID = pc.ProductCategoryID
GROUP BY GROUPING SETS ((pc.Name), (pc.Name, p.Name))
ORDER BY 1, 2 


-- Lab 4 - Challenge 4 (BONUS): De la consulta anterior, descarta los grupos que tengan menos de 8 tickets de venta

SELECT pc.Name AS [Category],  p.Name As [Product], SUM(shd.OrderQty) AS [Total Qty]
FROM SalesLT.SalesOrderHeader AS soh 
    INNER JOIN SalesLT.SalesOrderDetail AS shd ON soh.SalesOrderID = shd.SalesOrderID
    INNER JOIN SalesLT.Product AS p ON shd.ProductID = p.ProductID
    INNER JOIN SalesLT.ProductCategory AS pc ON p.ProductCategoryID = pc.ProductCategoryID
GROUP BY GROUPING SETS ((pc.Name), (pc.Name, p.Name))
HAVING COUNT(DISTINCT soh.SalesOrderID) >= 8


-- Lab 5 - Challenge 1: Revisa la salida de la siguiente instrucción

SELECT p.ProductID, pc.Name AS 'Category', p.Name AS 'Product', p.[Size]

	-- ranking
    , ROW_NUMBER() OVER (PARTITION BY p.ProductCategoryID ORDER BY p.Size) AS 'Row Number Per Category & Size'
    , RANK() OVER (PARTITION BY p.ProductCategoryID ORDER BY p.Size) AS 'Rank Per Category & Size'
    , DENSE_RANK() OVER (PARTITION BY p.ProductCategoryID ORDER BY p.Size) AS 'Dense Rank Per Category & Size'
    , NTILE(2) OVER (PARTITION BY p.ProductCategoryID ORDER BY p.Name) AS 'NTile Per Category & Name'

	-- aggregate
    , SUM(p.StandardCost) OVER() AS 'Standard Cost Grand Total'
    , SUM(p.StandardCost) OVER(PARTITION BY p.ProductCategoryID) AS 'Standard Cost Per Category'
    
	-- analytical
    , LAG(p.Name, 1, '-- NOT FOUND --') OVER(PARTITION BY p.ProductCategoryID ORDER BY p.Name) AS 'Previous Product Per Category'
    , LEAD(p.Name, 1, '-- NOT FOUND --') OVER(PARTITION BY p.ProductCategoryID ORDER BY p.Name) AS 'Next Product Per Category'
    , FIRST_VALUE(p.Name) OVER(PARTITION BY p.ProductCategoryID ORDER BY p.Name) AS 'First Product Per Category'
    , LAST_VALUE(p.Name) OVER(PARTITION BY p.ProductCategoryID ORDER BY p.Name) AS 'Last Product Per Category'
FROM SalesLT.Product AS p
    INNER JOIN SalesLT.ProductCategory AS pc ON p.ProductCategoryID = pc.ProductCategoryID
ORDER BY pc.Name, p.Name 