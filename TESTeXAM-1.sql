CREATE DATABASE Accounting
GO
USE Accounting
GO

--1
CREATE TABLE Countries(
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] VARCHAR (10) NOT NULL
)

CREATE TABLE Addresses(
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	StreetName NVARCHAR (20) NOT NULL,
	StreetNumber INT,
	PostCode INT NOT NULL,
	City  VARCHAR (25) NOT NULL,
	CountryId INT FOREIGN KEY REFERENCES Countries NOT NULL
)

CREATE TABLE Vendors (
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] NVARCHAR (25) NOT NULL,
	NumberVAT NVARCHAR(15) NOT NULL,
	AddressId INT NOT NULL FOREIGN KEY REFERENCES Addresses
)

CREATE TABLE Categories(
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] VARCHAR (10) NOT NULL
)

CREATE TABLE Products (
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] NVARCHAR (35) NOT NULL,
	Price DECIMAL(18,2) NOT NULL,
	CategoryId INT FOREIGN KEY REFERENCES Categories NOT NULL,
	VendorId INT FOREIGN KEY REFERENCES Vendors NOT NULL
)

CREATE TABLE Clients (
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] NVARCHAR (25) NOT NULL,
	NumberVAT NVARCHAR(15) NOT NULL,
	AddressId INT NOT NULL FOREIGN KEY REFERENCES Addresses
)

CREATE  TABLE Invoices(
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	Number INT UNIQUE NOT NULL,
	IssueDate DATETIME2 NOT NULL,
	DueDate DATETIME2 NOT NULL,
	Amount DECIMAL (18,2) NOT NULL,
	Currency VARCHAR (5) NOT NULL,
	ClientId INT FOREIGN KEY REFERENCES Clients NOT NULL
)

CREATE TABLE ProductsClients(
	ProductId INT  NOT NULL,
	ClientId INT  NOT NULL,
	PRIMARY KEY (ProductId,ClientId),
	FOREIGN KEY (ProductId) REFERENCES Products,
	FOREIGN KEY (ClientId) REFERENCES Clients
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

UPDATE Invoices
SET DueDate = '2023-04-01'
WHERE IssueDate BETWEEN '2022-11-01' AND '2022-11-30';

UPDATE Clients
SET AddressId = 3
WHERE [Name] LIKE '%CO%';
---
SELECT *
FROM Clients
WHERE [Name] LIKE '%CO%'

--4
DELETE FROM Invoices WHERE ClientId = 11
DELETE FROM ProductsClients WHERE ClientId = 11
DELETE FROM Clients WHERE NumberVAT LIKE 'IT%'

--5

SELECT Number, Currency
FROM Invoices
ORDER BY Amount DESC, DueDate

--6

SELECT p.Id, p.[Name], p.Price, c.[Name] CategoryName
FROM Products p
JOIN Categories c ON c.Id = p.CategoryId
WHERE c.[Name] = 'ADR' OR c.[Name] = 'Others'
ORDER BY p.Price DESC

--7

SELECT c.Id
	, c.[Name] AS Client
	,CONCAT (a.StreetName, ' ', a.StreetNumber, ', ', a.City + ', ', a.PostCode, ', ', co.[Name]) AS [Address]
FROM Clients c
LEFT JOIN ProductsClients pc ON pc.ClientId = c.Id
JOIN Addresses a ON a.Id = c.AddressId
JOIN Countries co ON co.Id = a.CountryId
WHERE pc.ProductId IS NULL


--8

SELECT TOP(7) i.Number, i.Amount, c.[Name] AS Client 
FROM Invoices i
JOIN Clients c ON c.Id = i.ClientId
WHERE i.IssueDate < '2023-01-01' 
	AND i.Currency  = 'EUR' 
	OR i.Amount > 500.00 
	AND C.NumberVAT LIKE 'DE%'
ORDER BY i.Number, i.Amount DESC


--9

SELECT c.[Name] AS Client
	,MAX(p.Price) AS Price
	,c.NumberVAT AS [VAT Number]
FROM Clients c
	JOIN ProductsClients pc ON pc.ClientId = c.Id
	JOIN Products p ON pc.ProductId = p.Id
WHERE c.[Name] NOT LIKE '%KG'
GROUP BY c.[Name],c.NumberVAT
ORDER BY Price DESC

--10

SELECT c.[Name] AS Client
	,CAST(ROUND(AVG(p.Price),0 ,1)AS decimal(18,0)) AS [Avarage Price]
FROM Clients c
	JOIN ProductsClients pc ON pc.ClientId = c.Id
	JOIN Products p ON pc.ProductId = p.Id
	JOIN Vendors v ON v.Id = p.VendorId
WHERE v.NumberVAT LIKE 'FR%'
GROUP BY c.[Name]
ORDER BY  [Avarage Price], c.[Name] DESC

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