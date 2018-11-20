-- PART B
-- 1
CREATE VIEW suppliers_product_vw
AS
/*select the columns*/
SELECT	Products.ProductID,
		Products.QuantityPerUnit,
		Products.UnitsInStock,
		Products.UnitsOnOrder,
		Suppliers.Name
/*create the inner join*/
FROM Products INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
/*restrict result set*/
WHERE Products.UnitsOnOrder > 0


--2
SELECT	Customers.CustomerID,
		Customers.ContactName,
		Customers.Phone,
		Orders.OrderID,
		FORMAT(Orders.OrderDate,'yyyy-MM-dd') AS OrderDate
FROM Customers INNER JOIN Orders on Customers.CustomerID = Orders.CustomerID
WHERE Orders.ShippedDate IS NULL AND EXISTS
	  (SELECT *
	   FROM Employees
	   WHERE Employees.EmployeeID = Orders.EmployeeID
			 AND Employees.City = 'New Westminster')
ORDER BY Customers.CompanyName, Orders.OrderDate

--3
INSERT INTO Employees(EmployeeID, LastName, FirstName, BirthDate)
VALUES('10','Stevenson','Joseph','1995-05-12');

INSERT INTO Employees(EmployeeID, LastName, FirstName, BirthDate)
VALUES('11','Thompson','Mary-Beth','1999-09-10');

--4
CREATE VIEW employee_inform_vw
AS
SELECT	Employees.EmployeeID,
		CONCAT(Employees.FirstName,' ',Employees.LastName) AS Name,
		CASE
		WHEN Employees.Phone IS NULL THEN ''
		ELSE CONCAT('(',SUBSTRING(Employees.Phone,1,3),')',SUBSTRING(Employees.Phone,4,3),'-',SUBSTRING(Employees.Phone,7,3)) 
		END AS PhoneNumber,
		FORMAT(Employees.BirthDate, 'MMM dd yyyy') AS BirthDate
FROM Employees

--5
UPDATE Customers
SET FAX = 'Unknown'
WHERE FAX IS NULL;

--6
CREATE VIEW sales_by_customers_vw
AS
SELECT	Customers.CompanyName,
		CONCAT(Employees.LastName,', ',Employees.FirstName) AS EmployeeName,
		SUM(OrderDetails.Quantity) AS SumQuantity
FROM    Customers INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID 
				  INNER JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
				  INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID

GROUP BY Customers.CompanyName,
		 Employees.LastName,
		 Employees.FirstName
HAVING SUM(OrderDetails.Quantity) >= 500

--7
DELETE FROM Employees 
WHERE Employees.Phone IS NULL;

--8

SELECT	Orders.OrderID,
		Customers.CompanyName,
		Customers.ContactName,
		Customers.Phone,
		FORMAT(Orders.OrderDate, 'yyyy.MM.dd') AS OrderDate,
		OrderDetails.Quantity
FROM    Orders INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
			   INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE Orders.OrderDate >= '1994-03-01' AND ORDERS.ShippedDate IS NULL AND
	  OrderDetails.ProductID IN
			(SELECT Products.ProductID 
			 FROM   Products
			 WHERE  Products.Discontinued = 1); 	 
