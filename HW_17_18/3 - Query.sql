USE Northwind;
GO

-- Problem 02
-- Ќапишите скрипт дл€ базы Northwind, определющий покупател€, сделавшего наиболее дорогосто€щий заказ.
-- ¬ыведите полную информацию о покупателе и перечислите его заказы по возрастанию даты 
-- с указанием общей суммы каждого. ¬ыведите общую сумму заказов.
SELECT Customers.CustomerID,
	   Customers.CompanyName,
	   Customers.ContactTitle,
	   Customers.Phone,
	   Customers.Address,
	   Orders.OrderID,
	   Orders.OrderDate,
	   SUM(OrderDetails.UnitPrice * OrderDetails.Quantity *(1.0 - OrderDetails.Discount)) AS TotalAmount
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
WHERE Customers.CustomerID = (
        SELECT TOP 1 C.CustomerID
        FROM Customers	  AS C
		JOIN Orders		  AS O ON C.CustomerID = O.CustomerID
		JOIN OrderDetails AS OD ON O.OrderID = OD.OrderID
        GROUP BY C.CustomerID
        ORDER BY SUM(OD.UnitPrice * OD.Quantity *(1.0 - OD.Discount)) DESC
    )
GROUP BY Customers.CustomerID,
		 Customers.CompanyName,
		 Customers.ContactTitle,
		 Customers.Phone,
		 Customers.Address,
		 Orders.OrderID,
		 Orders.OrderDate
ORDER BY Orders.OrderDate ASC;
GO

/*
SELECT Customers.CustomerID,
	   Customers.CompanyName,
	   Orders.OrderID,
	   Orders.OrderDate,
	   SUM(OrderDetails.UnitPrice*OrderDetails.Quantity*(1.0 - OrderDetails.Discount)) AS TotalPrice
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Customers.CustomerID,
		 Customers.CompanyName,
		 Orders.OrderID,
		 Orders.OrderDate
HAVING SUM(OrderDetails.UnitPrice * OrderDetails.Quantity *(1.0 - OrderDetails.Discount)) = (
	SELECT MAX(OrderTotal)
	FROM (
		SELECT SUM(od.UnitPrice * od.Quantity *(1.0 - od.Discount)) AS OrderTotal
		FROM Customers c
		JOIN Orders o ON c.CustomerID = o.CustomerID
		JOIN OrderDetails od ON o.OrderID = od.OrderID
		GROUP BY c.CustomerID, o.OrderID 
	) AS MaxOrder
);
GO
*/
go

---------------------------------------------------------------------------------------------------------------


-- Problem 03
-- Ќапишите скрипт дл€ базы Northwind, определ€ющий:
-- a) 3 наиболее часто заказываемых продукта;
-- b) ѕокупател€ (покупателей), сделавших наибольшее число заказов;
-- c) “рех сотрудников, оформивших наибольшее число заказов.

-- a) 3 наиболее часто заказываемых продукта;
SELECT TOP 3 Products.ProductName, 
			 COUNT(OrderDetails.ProductID) AS OrderCount
FROM Products
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Products.ProductName
ORDER BY OrderCount DESC;
GO

-- b) ѕокупател€ (покупателей), сделавших наибольшее число заказов;
SELECT Customers.CustomerID, 
	   COUNT(Orders.OrderID) AS OrderCount
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CustomerID, Customers.CompanyName
HAVING COUNT(Orders.OrderID) = (
    SELECT MAX(Cnt)
	FROM (
		SELECT COUNT(OrderID) AS Cnt
		FROM Orders
		GROUP BY CustomerID
	) AS OrderCountTable
);
GO

-- c) “рех сотрудников, оформивших наибольшее число заказов.
SELECT TOP 3 Employees.EmployeeID, 
			 Employees.FirstName + ' ' + Employees.LastName AS [FIO], 
			 COUNT(Orders.OrderID) AS OrderCount
FROM Employees
JOIN Orders ON Employees.EmployeeID = Orders.EmployeeID
GROUP BY Employees.EmployeeID, Employees.FirstName, Employees.LastName
ORDER BY OrderCount DESC;
GO