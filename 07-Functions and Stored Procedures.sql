--1 
USE SoftUni

-- it should be usp!!!
CREATE PROC sp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName, LastName
FROM Employees
WHERE Salary  > 35000

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName, LastName 
FROM Employees
WHERE Salary > 35000

EXEC sp_GetEmployeesSalaryAbove35000

--2

CREATE PROC usp_GetEmployeesSalaryAboveNumber @Number DECIMAL (18,4)
AS
SELECT FirstName, LastName
FROM Employees
WHERE Salary  >= @Number

EXEC usp_GetEmployeesSalaryAboveNumber @Number = 48100

--3

CREATE PROC usp_GetTownsStartingWith @Name NVARCHAR (50)
AS
SELECT Name
FROM Towns
WHERE Name LIKE  @Name+'%'

drop proc usp_GetTownsStartingWith

SELECT Name
FROM Towns

EXEC usp_GetTownsStartingWith @Name = 'Sofia'

--4

CREATE PROC usp_GetEmployeesFromTown @Name NVARCHAR (50)
AS
SELECT FirstName, LastName
FROM Employees AS e
JOIN Addresses AS a ON a.AddressID = e.AddressID
JOIN Towns AS t ON t.TownID = a.TownID
WHERE Name =  @Name

drop proc usp_GetTownsStartingWith

SELECT *
FROM Addresses

EXEC usp_GetTownsStartingWith @Name = 'Sofia'

--5

CREATE FUNCTION dbo.ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(20)
AS
BEGIN
	IF @salary < 30000 RETURN 'Low'
	ELSE IF @salary BETWEEN 30000 AND 50000 RETURN 'Average'
	RETURN 'High'
END

DROP FUNCTION ufn_GetSalaryLevel

SELECT dbo.ufn_GetSalaryLevel(20000)

--6

CREATE PROC usp_EmployeesBySalaryLevel @SalaryLevel NVARCHAR (50)
AS
BEGIN
	SELECT FirstName, LastName
	FROM Employees AS e
	WHERE dbo.ufn_GetSalaryLevel(Salary) =  @SalaryLevel
END

drop proc usp_GetTownsStartingWith

SELECT *
FROM Addresses

EXEC usp_GetTownsStartingWith @Name = 'Sofia'

--7

CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(50), @word NVARCHAR(100))
RETURNS BIT
AS
BEGIN
	DECLARE @i INT  = 1
	WHILE @i <= LEN(@word)
	BEGIN
		DECLARE @ch NVARCHAR (1) = SUBSTRING(@word,@i,1)
		IF CHARINDEX(@ch, @setOfLetters) = 0
			RETURN 0
		ELSE
			SET @i += 1
	END
	RETURN 1
END

SELECT dbo.ufn_IsWordComprised('pppp', 'Guy')

--8*


--9
USE Bank

CREATE PROC usp_GetHoldersFullName
AS
SELECT FirstName + ' ' + LastName AS [Full Name]
FROM AccountHolders

--10

CREATE OR ALTER PROC usp_GetHoldersWithBalanceHigherThan (@Money DECIMAL(18,4))
AS
SELECT FirstName, LastName
FROM AccountHolders AS ah
JOIN Accounts AS a ON a.AccountHolderId = ah.Id
GROUP BY ah.FirstName,LastName
HAVING SUM(a.Balance)> @Money
ORDER BY FirstName,LastName

SELECT * 
FROM AccountS
 

 --11

 CREATE OR ALTER FUNCTION ufn_CalculateFutureValue
 (@InitialSum DECIMAL(18,4),@YearlyInterestRate FLOAT,@NumberOfYears INT)
 RETURNS DECIMAL (18,4)
 AS
 BEGIN
	DECLARE @Fv DECIMAL(18,4) = @InitialSum * POWER(1 + @YearlyInterestRate, @NumberOfYears)
	RETURN @Fv
 END

 SELECT dbo.ufn_CalculateFutureValue(1000, 0.10, 5)

 --12

CREATE OR ALTER PROC usp_CalculateFutureValueForAccount 
(@AccountId INT, @Interest FLOAT)
AS

DECLARE @Years INT = 5

SELECT a.Id AS [Account Id]
	,ah.FirstName AS [First Name]
	,ah.LastName AS [Last Name]
	,a.Balance AS [Current Balance]
	,dbo.ufn_CalculateFutureValue(a.Balance, @Interest, @Years) AS [Balance in 5 years]
	FROM AccountHolders AS ah
	JOIN Accounts AS a ON a.AccountHolderId = ah.Id
	WHERE a.Id = @AccountId
	ORDER BY FirstName,LastName

EXEC usp_CalculateFutureValueForAccount 1,0.10

SELECT * 
FROM AccountS