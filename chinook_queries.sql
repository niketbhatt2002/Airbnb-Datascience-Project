-- ✅ Query 1: Top 5 customers by total purchase amount
SELECT 
    c.CustomerId, 
    c.FirstName || ' ' || c.LastName AS CustomerName, 
    SUM(i.Total) AS TotalSpent
FROM Invoice i
JOIN Customer c ON i.CustomerId = c.CustomerId
GROUP BY c.CustomerId
ORDER BY TotalSpent DESC
LIMIT 5;

-- ✅ Query 2: Most popular genre by total tracks sold
SELECT 
    g.Name AS Genre, 
    COUNT(il.TrackId) AS TotalSold
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY TotalSold DESC
LIMIT 1;

-- ✅ Query 3: Managers and their subordinates
SELECT 
    m.EmployeeId AS ManagerID, 
    m.FirstName || ' ' || m.LastName AS ManagerName,
    e.EmployeeId AS SubordinateID,
    e.FirstName || ' ' || e.LastName AS SubordinateName
FROM Employee e
JOIN Employee m ON e.ReportsTo = m.EmployeeId;

-- ✅ Query 4: Most sold album for each artist
SELECT 
    ar.Name AS ArtistName,
    al.Title AS AlbumTitle,
    COUNT(il.InvoiceLineId) AS TotalSales
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name, al.Title
HAVING TotalSales = (
    SELECT MAX(SalesCount) 
    FROM (
        SELECT 
            COUNT(il2.InvoiceLineId) AS SalesCount
        FROM InvoiceLine il2
        JOIN Track t2 ON il2.TrackId = t2.TrackId
        JOIN Album al2 ON t2.AlbumId = al2.AlbumId
        WHERE al2.ArtistId = ar.ArtistId
        GROUP BY al2.Title
    )
);

-- ✅ Query 5: Monthly sales trends in the year 2013
SELECT 
    strftime('%Y-%m', InvoiceDate) AS Month,
    SUM(Total) AS TotalSales
FROM Invoice
WHERE strftime('%Y', InvoiceDate) = '2013'
GROUP BY Month
ORDER BY Month;
