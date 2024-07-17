--1. What are the total sales amount for each region and countries, including the region name and the total sales amount, sorted in descending order.

SELECT st.Name, SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Sales.Customer cust ON soh.CustomerID = cust.CustomerID
JOIN Sales.SalesTerritory st ON cust.TerritoryID = st.TerritoryID
GROUP BY st.Name
ORDER BY TotalSales DESC;

--2. What are top 3 products by total sales, including the product name, product number, and total sales amount, sorted in descending order.

SELECT TOP 3 pp.ProductID, pp.Name, SUM(LineTotal) AS Total_Sales
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID  = soh.SalesOrderID 
JOIN Production.Product pp ON sod.ProductID = pp.ProductID
GROUP BY pp.ProductID, pp.Name
ORDER BY Total_Sales DESC;

--3. List the orders placed by customers who have also placed orders for products in the 'Accessories' category.

SELECT DISTINCT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product pp ON sod.ProductID = pp.ProductID
WHERE soh.CustomerID IN (SELECT DISTINCT soh2.CustomerID
FROM Sales.SalesOrderHeader soh2
JOIN Sales.SalesOrderDetail sod2 ON soh2.SalesOrderID = sod2.SalesOrderID
JOIN Production.Product pp2 ON sod2.ProductID = pp2.ProductID
JOIN Production.ProductSubcategory ps2 ON pp2.ProductSubcategoryID = ps2.ProductSubcategoryID
JOIN Production.ProductCategory pc2 ON ps2.ProductCategoryID = pc2.ProductCategoryID
WHERE pc2.Name = 'Accessories');

--4. Get the list of employees who have sold products with a total value exceeding $50,000 in the 'Clothing' category.

SELECT pp.BusinessEntityID, pp.FirstName, pp.LastName, SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Person pp ON soh.SalesPersonID = pp.BusinessEntityID
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = 'Clothing'
GROUP BY pp.BusinessEntityID, pp.FirstName, pp.LastName
HAVING SUM(sod.LineTotal) > 50000
ORDER BY TotalSales DESC;

--5. What is the average order value for each customer.

SELECT TOP 3 c.CustomerID, p.FirstName, p.LastName, SUM(sh.TotalDue) AS TotalOrderValue
FROM Sales.SalesOrderHeader sh
JOIN Sales.Customer c ON sh.CustomerID = c.CustomerID
JOIN Person.Person p ON p.BusinessEntityID = c.PersonID
GROUP BY  c.CustomerID, p.FirstName, p.LastName
ORDER BY TotalOrderValue DESC;

--6. Get the list of products that are not associated with any orders.

SELECT p.ProductID, p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sd ON p.ProductID = sd.ProductID
WHERE sd.ProductID IS NULL;

--7.List the orders with a total value greater than the average order value.

WITH OrderTotals AS (SELECT sh.SalesOrderID, SUM(sd.OrderQty * sd.UnitPrice) AS TotalOrderValue
FROM Sales.SalesOrderHeader sh
INNER JOIN Sales.SalesOrderDetail sd ON sh.SalesOrderID = sd.SalesOrderID
GROUP BY sh.SalesOrderID), AverageOrderValue AS (SELECT AVG(TotalOrderValue) AS AvgOrderValue
FROM OrderTotals)
SELECT ot.SalesOrderID, ot.TotalOrderValue
FROM OrderTotals ot, AverageOrderValue aov
WHERE ot.TotalOrderValue > aov.AvgOrderValue
ORDER BY ot.TotalOrderValue DESC;

--8. Find the top 5 employees with the highest sales amount
WITH SalesCTE AS (SELECT s.BusinessEntityID, p.FirstName, p.LastName, SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesPerson s
JOIN Sales.SalesOrderHeader soh ON s.BusinessEntityID = soh.SalesPersonID
JOIN Person.Person p ON s.BusinessEntityID = p.BusinessEntityID
GROUP BY s.BusinessEntityID, p.FirstName, p.LastName)
SELECT TOP 5 BusinessEntityID, FirstName, LastName, TotalSales
FROM SalesCTE
ORDER BY TotalSales DESC;

--9. Find the total number of products in each product category.
SELECT pc.Name AS CategoryName, COUNT(p.ProductID) AS TotalProducts
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name;

--10. Retrieve the average sales amount per customer
SELECT AVG(CustomerTotal) AS AverageSalesPerCustomer
FROM (SELECT c.CustomerID, SUM(soh.TotalDue) AS CustomerTotal
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID) AS CustomerSales;

--11. Find the total sales amount for each region.
SELECT DISTINCT cr.CountryRegionCode, cr.Name AS CountryName, SUM(st.SalesYTD) AS TotalSales
FROM Person.CountryRegion cr
JOIN Sales.SalesTerritory st ON cr.CountryRegionCode = st.CountryRegionCode
GROUP BY cr.CountryRegionCode,cr.Name;

--12. Retrieve the names and total due of customers who have placed orders with a total due greater than $5,000.
SELECT c.CustomerID, p.FirstName, p.LastName, SUM(soh.TotalDue) AS TotalDue
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY c.CustomerID, p.FirstName, p.LastName
HAVING SUM(soh.TotalDue) > 5000;

--13. List the products that have never been sold.
SELECT p.ProductID, p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL;

--14. Retrieve a list of all employees and their department names
SELECT e.BusinessEntityID, e.JobTitle, d.Name AS Department
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d ON edh.DepartmentID = d.DepartmentID;

--15. Find the average list price of products by category
SELECT pc.Name AS CategoryName, AVG(p.ListPrice) AS AverageListPrice
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name;
