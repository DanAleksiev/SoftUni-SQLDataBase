CREATE DATABASE Boardgames
GO
USE Boardgames

--1
CREATE TABLE Categories(
	Id INT PRIMARY KEY IDENTITY
	,[Name] VARCHAR (50) NOT NULL
)

CREATE TABLE Addresses(
	Id INT PRIMARY KEY IDENTITY
	,StreetName NVARCHAR (100) NOT NULL
	,StreetNumber INT NOT NULL
	,Town VARCHAR (30) NOT NULL
	,Country VARCHAR (50) NOT NULL
	,ZIP INT NOT NULL
)

CREATE TABLE Publishers(
	Id INT PRIMARY KEY IDENTITY
	,[Name] VARCHAR (30) UNIQUE NOT NULL
	,AddressId INT NOT NULL FOREIGN KEY REFERENCES Addresses 
	,Website NVARCHAR (40)
	,Phone NVARCHAR (20)
)

CREATE TABLE PlayersRanges(
	Id INT PRIMARY KEY IDENTITY
	,PlayersMin	INT NOT NULL
	,PlayersMax INT NOT NULL
)

CREATE TABLE Boardgames(
	Id INT PRIMARY KEY IDENTITY
	,[Name] NVARCHAR (30) NOT NULL
	,YearPublished INT NOT NULL
	,Rating DECIMAL(18,2) NOT NULL
	,CategoryId INT FOREIGN KEY REFERENCES Categories(ID)
	,PublisherId INT FOREIGN KEY REFERENCES Publishers(ID)
	,PlayersRangeId INT FOREIGN KEY REFERENCES PlayersRanges(ID)
)

CREATE TABLE Creators(
	Id INT PRIMARY KEY IDENTITY
	,FirstName NVARCHAR (30) NOT NULL
	,LastName NVARCHAR (30) NOT NULL
	,Email NVARCHAR (30) NOT NULL
)

CREATE TABLE CreatorsBoardgames(
	CreatorId INT FOREIGN KEY REFERENCES Creators(Id),
	BoardgameId INT FOREIGN KEY REFERENCES Boardgames(Id),
	PRIMARY KEY(CreatorId, BoardgameId)
)

--2
go
INSERT INTO Boardgames 
	([Name], YearPublished, Rating, CategoryId, PublisherId, PlayersRangeId) 
VALUES
	('Deep Blue', 2019, 5.67, 1, 15, 7),
	('Paris', 2016, 9.78, 7, 1, 5),
	('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
	('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
	('One Small Step', 2019, 5.75, 5, 9, 2)
	

INSERT INTO Publishers 
	([Name], AddressId, Website, Phone) 
VALUES
	('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
	('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
	('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')

--3

UPDATE PlayersRanges
SET PlayersMax += 1
WHERE PlayersMin = 2 AND PlayersMax =2

UPDATE Boardgames
SET [Name] += 'V2'
WHERE YearPublished >= 2020


--4
DELETE FROM CreatorsBoardgames WHERE BoardgameId  IN (1,16,31,47)
DELETE FROM Boardgames WHERE PublisherId  IN (1,16)
DELETE FROM Publishers WHERE AddressId = 5
DELETE FROM Addresses WHERE Town LIKE 'L%'

--5

SELECT [Name], Rating
FROM Boardgames
ORDER BY YearPublished, [Name] DESC

--6

SELECT b.Id, b.[Name], b.YearPublished, c.[Name]
FROM Boardgames b
JOIN Categories c ON c.Id = b.CategoryId
WHERE c.[Name] = 'Strategy Games' OR c.[Name] = 'Wargames'
ORDER BY YearPublished DESC

--7

SELECT c.Id, c.FirstName +' '+ c.LastName AS CreatorName, C.Email
FROM Creators c
LEFT JOIN CreatorsBoardgames cb ON cb.CreatorId = c.Id
LEFT JOIN Boardgames b ON cb.BoardgameId = b.Id
WHERE b.[Name] IS NULL


--8

SELECT TOP(5) b.[Name], b.Rating, c.[Name] AS CategoryName
FROM Boardgames b
JOIN Categories c ON c.Id = b.CategoryId
JOIN PlayersRanges pr ON pr.Id = b.PlayersRangeId
WHERE b.Rating > 7 AND b.[Name] LIKE '%A%'OR b.Rating >7.50 AND pr.PlayersMin = 2 AND pr.PlayersMax = 5
ORDER BY b.[Name], b.Rating DESC

--9

SELECT CONCAT(c.FirstName, ' ', c.LastName) AS FullName
	,c.Email
	,MAX(b.Rating) AS Rating
FROM Creators c
	JOIN CreatorsBoardgames cb ON cb.CreatorId = c.Id
	JOIN Boardgames b ON cB.BoardgameId = b.Id
WHERE c.Email LIKE '%.COM'
GROUP BY c.FirstName,c.LastName, c.Email
ORDER BY FullName

--10

SELECT c.LastName
	,CEILING(AVG(b.Rating)) AS AvarageRating
	,p.[Name] AS PublisherName
FROM Creators c
	LEFT JOIN CreatorsBoardgames cb ON cb.CreatorId = c.Id
	LEFT JOIN Boardgames b ON b.Id = cb.BoardgameId
	JOIN Publishers p ON p.Id = b.PublisherId
WHERE p.[Name] = 'Stonemaier Games'
GROUP BY c.LastName, p.[Name]
ORDER BY AvarageRating DESC

--11

CREATE FUNCTION udf_CreatorWithBoardgames(@name NVARCHAR(50))
RETURNS INT
BEGIN
	DECLARE @Count INT
	
	SELECT @Count = COUNT(*)
	FROM Creators c
		JOIN CreatorsBoardgames cb ON cb.CreatorId = c.Id
	WHERE c.FirstName = @name

	RETURN @Count
END

SELECT dbo.udf_CreatorWithBoardgames('Bruno')

--12

CREATE PROC usp_SearchByCategory(@category NVARCHAR(50))
AS
SELECT b.[Name], b.YearPublished, b.Rating, c.[Name] AS CategoryName, p.[Name] AS PublisherName, CONCAT(pr.PlayersMin, ' people') AS MinPlayers, CONCAT(pr.PlayersMax, ' people') AS MaxPlayers
FROM Categories c
	JOIN Boardgames b ON b.CategoryId = c.Id
	JOIN PlayersRanges pr ON pr.Id = b.PlayersRangeId
	JOIN Publishers p ON p.Id = B.PublisherId
WHERE c.[Name] = @category
ORDER BY PublisherName, b.YearPublished DESC




EXEC usp_SearchByCategory 'Wargames'