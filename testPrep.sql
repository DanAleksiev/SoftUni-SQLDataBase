CREATE DATABASE 
GO
USE 
GO

--1
CREATE TABLE (
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] VARCHAR () NOT NULL
)

CREATE TABLE (
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] VARCHAR () NOT NULL
)

CREATE TABLE (
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] VARCHAR () NOT NULL
)

CREATE TABLE (
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] VARCHAR () NOT NULL
)

CREATE TABLE (
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] VARCHAR () NOT NULL
)

CREATE TABLE (
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] VARCHAR () NOT NULL
)

CCREATE TABLE (
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] VARCHAR () NOT NULL
)

CREATE TABLE (
	 INT  NOT NULL,
	 INT  NOT NULL,
	PRIMARY KEY ( , ),
	FOREIGN KEY () REFERENCES ,
	FOREIGN KEY () REFERENCES 
)

--2

INSERT Products ([Name], Price, CategoryId, VendorId)
VALUES
	('SCANIA Oil Filter XD01', 78.69, 1, 1),
	('MAN Air Filter XD01', 97.38, 1, 5),
	('DAF Light Bulb 05FG87', 55.00, 2, 13),
	('ADR Shoes 47-47.5', 49.85, 3, 5),
	('Anti-slip pads S', 5.87, 5, 7)


INSERT Invoices (Number,IssueDate,DueDate,Amount,Currency,ClientId)
VALUES
	(1219992181, '2023-03-01', '2023-04-30', 180.96	,'BGN', 3),
	(1729252340, '2022-11-06', '2023-01-04', 158.18	,'EUR', 13),
	(1950101013, '2023-02-17', '2023-04-18', 615.15	,'USD', 19)

--3

UPDATE 
SET 
WHERE 

UPDATE
SET 
WHERE 
---
SELECT *
FROM 
WHERE 

--4
DELETE  WHERE 
DELETE  WHERE 
DELETE  WHERE 

--11

CREATE FUNCTION udf_ProductWithClients (@name NVARCHAR (50))
RETURNS INT
BEGIN
	DECLARE @Count INT

	SELECT @Count = COUNT(*)
	FROM Clients AS c
	JOIN ProductsClients AS pc ON pc.ClientId = c.Id
	JOIN Products AS p ON p.Id = pc.ProductId
	WHERE @name = p.Name

	RETURN @Count
END

SELECT dbo.udf_ProductWithClients('DAF FILTER HU12103X')
--12

CREATE PROC usp_SearchByCountry(@country NVARCHAR (100))
AS
SELECT v.[Name]
	,V.NumberVAT AS VAT
	,CONCAT(a.StreetName, ' ',a.StreetNumber)AS [Street Info] 
	,CONCAT(a.City, ' ',a.PostCode) AS [City Info]
FROM Vendors v
JOIN Addresses a ON a.Id = v.AddressId
JOIN Countries c ON c.Id = a.CountryId
WHERE c.[Name] = @country
ORDER BY v.[Name],c.[Name]

EXEC usp_SearchByCountry 'France'