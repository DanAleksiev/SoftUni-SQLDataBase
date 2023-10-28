--1
USE SoftUni

SELECT FirstName, LastName
FROM Employees
WHERE FirstName LIKE 'sa%'

--2

SELECT FirstName, LastName
FROM Employees
WHERE LastName LIKE '%ei%'

--3

SELECT FirstName
FROM Employees
WHERE DepartmentID = 3 OR DepartmentID = 10 
AND HireDate BETWEEN '1995-01-01' AND '2005-12-31' 

--4

SELECT FirstName ,LastName
FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

--5

SELECT [Name]
FROM Towns
WHERE LEN ([Name]) BETWEEN 5 AND 6
ORDER BY [Name]

--6

SELECT TownID, [Name]
FROM Towns
WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]

--7

SELECT TownID, [Name]
FROM Towns
WHERE [Name] NOT LIKE '[RBD]%'
ORDER BY [Name]

--8
CREATE VIEW V_EmployeesHiredAfter2000
AS
SELECT FirstName,LastName
FROM Employees
WHERE HireDate > '2000-12-31'

--9

SELECT FirstName,LastName
FROM Employees
WHERE LEN(LastName) = 5

--10

SELECT EmployeeID,FirstName,LastName,Salary,DENSE_RANK() OVER(
		PARTITION BY Salary 
		ORDER BY EmployeeID		
		) AS [Rank]
FROM Employees AS e
WHERE Salary BETWEEN 10000 AND 50000 
ORDER BY Salary DESC

--11
SELECT *
FROM
	(SELECT EmployeeID,FirstName,LastName,Salary,DENSE_RANK() OVER(
		PARTITION BY Salary 
		ORDER BY EmployeeID		
		) AS [Rank]
	FROM Employees AS e
	WHERE Salary BETWEEN 10000 AND 50000 )  AS s
WHERE S.[Rank] = 2
ORDER BY Salary DESC
-- CREATE SUB QUERY THAT WAY YOU CAN ADD EXTRA WHERE CLOUSE AND PICK THE RANK

--12
USE Geography

SELECT CountryName,IsoCode
FROM Countries
WHERE CountryName LIKE '%A%A%A%'
ORDER BY IsoCode

--13

SELECT PeakName,RiverName,LOWER (LEFT(P.PeakName,LEN (p.PeakName)-1) + r.RiverName) AS Mix
FROM Peaks AS p,Rivers AS r
WHERE RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
ORDER BY Mix

--14
USE Diablo

SELECT TOP(50) [Name], FORMAT([Start],'yyyy-MM-dd') [Start]
FROM GAMES
WHERE YEAR([Start]) BETWEEN '2011' AND '2012'
ORDER BY [Start],[Name]

--15

SELECT Username, SUBSTRING(
	Email, CHARINDEX('@', Email)+1, LEN(Email)
	) [Email Provider]
FROM Users
ORDER BY [Email Provider], Username


--16

SELECT Username, IpAddress AS [IP Address]
FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

-- _ FOR 1 SYMBOL AND % FOR 0 OR MORE

--17

SELECT 
	[Name] as Game,
	CASE
	  WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
	  WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
	  WHEN DATEPART(HOUR, [Start]) BETWEEN 18 AND 23 THEN 'Evening'
	END AS [Part of the Day],
	[Duration] =
	CASE
	  WHEN Duration <= 3 THEN 'Extra Short'
	  WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
	  WHEN Duration > 6 THEN 'Long'
	  ELSE 'Extra Long'
	END
FROM Games
ORDER BY [Name], Duration,[Part of the Day]

--18
CREATE DATABASE Orders 

USE Orders

CREATE TABLE Orders (
ID INT PRIMARY KEY IDENTITY,
ProductName VARCHAR(30),
OrderDate DATETIME2
)

INSERT Orders (ProductName, OrderDate)
VALUES
('Butter','2016-09-19 00:00:00.000'),
('Milk','2016-09-30 00:00:00.000'),
('Cheese','2016-09-04 00:00:00.000'),
('Bread','2015-12-20 00:00:00.000'),
('Tomatoes','2015-12-30 00:00:00.000')

SELECT 
	ProductName
	,OrderDate
	,DATEADD(DAY,3,OrderDate) [Pay Due]
	,DATEADD(MONTH,1,OrderDate) [Deliver Due]
FROM Orders