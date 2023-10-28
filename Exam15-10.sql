CREATE DATABASE TouristAgency
GO
USE TouristAgency
GO

--1
CREATE TABLE Countries(
	Id INT PRIMARY KEY NOT NULL IDENTITY,
	[Name] NVARCHAR (50) NOT NULL
)

CREATE TABLE Destinations(
	Id INT PRIMARY KEY NOT NULL IDENTITY
	,[Name] VARCHAR (50) NOT NULL
	,CountryId INT NOT NULL FOREIGN KEY REFERENCES Countries
)

CREATE TABLE Hotels(
	Id INT PRIMARY KEY NOT NULL IDENTITY
	,[Name] VARCHAR (50) NOT NULL
	,DestinationId INT NOT NULL FOREIGN KEY REFERENCES Destinations
)

CREATE TABLE Rooms(
	Id INT PRIMARY KEY NOT NULL IDENTITY
	,[Type] VARCHAR(40) NOT NULL
	,Price DECIMAL (18,2) NOT NULL
	,BedCount INT CHECK (BedCount BETWEEN 1 AND 10) NOT NULL
)

CREATE TABLE HotelsRooms(
	HotelId INT  NOT NULL,
	RoomId INT  NOT NULL,
	PRIMARY KEY ( HotelId, RoomId),
	FOREIGN KEY (HotelId) REFERENCES Hotels,
	FOREIGN KEY (RoomId) REFERENCES Rooms
)

CREATE TABLE Tourists(
	Id INT PRIMARY KEY NOT NULL IDENTITY
	,[Name] NVARCHAR (80) NOT NULL
	,PhoneNumber VARCHAR (20) NOT NULL
	,Email VARCHAR (80)
	,CountryId INT NOT NULL FOREIGN KEY REFERENCES Countries
)

CREATE TABLE Bookings(
	Id INT PRIMARY KEY NOT NULL IDENTITY
	,ArrivalDate DATETIME2 NOT NULL
	,DepartureDate DATETIME2 NOT NULL
	,AdultsCount INT CHECK (AdultsCount BETWEEN 1 AND 10) NOT NULL 
	,ChildrenCount INT CHECK (ChildrenCount BETWEEN 0 AND 9) NOT NULL
	,TouristId INT NOT NULL FOREIGN KEY REFERENCES Tourists
	,HotelId INT NOT NULL FOREIGN KEY REFERENCES Hotels
	,RoomId INT NOT NULL FOREIGN KEY REFERENCES Rooms
)

--2
INSERT Tourists([Name], PhoneNumber, Email, CountryId)
VALUES
	('John Rivers', '653-551-1555', 'john.rivers@example.com', 6)
	,('Adeline Aglaé', '122-654-8726', 'adeline.aglae@example.com', 2)
	,('Sergio Ramirez', '233-465-2876', 's.ramirez@example.com', 3)
	,('Johan Müller', '322-876-9826', 'j.muller@example.com', 7)
	,('Eden Smith', '551-874-2234', 'eden.smith@example.com', 6)


INSERT Bookings (ArrivalDate, DepartureDate, AdultsCount, ChildrenCount,TouristId,HotelId,RoomId)
VALUES
	('2024-03-01','2024-03-11',1,0,21,3,5)
	,('2023-12-28','2024-01-06',2,1,22,13,3)
	,('2023-11-15','2023-11-20',1,2,23,19,7)
	,('2023-12-05','2023-12-09',4,0,24,6,4)
	,('2024-05-01','2024-05-07',6,0,25,14,6)

--3

UPDATE Bookings
SET DepartureDate = DATEADD(DAY, 1, DepartureDate) 
WHERE ArrivalDate BETWEEN '2023-12-01' AND '2023-12-31'

UPDATE Tourists
SET Email = NULL
WHERE Email LIKE '%MA%'

--3

DELETE FROM Bookings WHERE TouristId IN(6,16,25)
DELETE FROM Tourists WHERE [Name] LIKE '%SMITH'

SELECT * FROM Bookings WHERE TouristId IN(6,16,25)

--5
SELECT FORMAT(ArrivalDate, 'yyyy-MM-dd') AS ArrivalDate
	,b.AdultsCount
	,b.ChildrenCount
FROM Bookings b
JOIN Rooms r ON r.Id = b.RoomId
ORDER BY r.Price DESC, b.ArrivalDate

--6

SELECT h.Id,h.[Name]
FROM Hotels h
	JOIN HotelsRooms hr ON hr.HotelId = h.Id
	JOIN Rooms r ON r.Id = hr.RoomId
	JOIN Bookings b ON b.HotelId = h.Id
WHERE r.[Type] = 'VIP Apartment'
GROUP BY h.Id, h.[Name]
ORDER BY count(b.HotelId)DESC

--7

SELECT t.Id, t.[Name], t.PhoneNumber
FROM Tourists t
	LEFT JOIN Bookings b ON b.TouristId = t.Id
WHERE b.AdultsCount IS NULL
ORDER BY t.[Name]

--8

SELECT TOP (10) h.[Name] AS HotelName
	,d.[Name] AS DestinationName
	,c.[Name] AS CountryName
FROM Bookings b
	JOIN Hotels h ON h.Id = b.HotelId
	JOIN Destinations d ON d.Id = h.DestinationId
	JOIN Countries c ON c.Id = d.CountryId
WHERE b.HotelId % 2 = 1 AND ArrivalDate < '2023-12-31'
ORDER BY CountryName, b.ArrivalDate


--9

SELECT h.[Name] , r.Price
FROM Tourists t
	LEFT JOIN Bookings b ON b.TouristId = t.Id
	LEFT JOIN Hotels h ON h.Id = b.HotelId
	JOIN Rooms r ON r.Id = b.RoomId
WHERE t.[Name] NOT LIKE '%EZ' AND h.[Name] IS NOT NULL
ORDER BY r.PRICE DESC

--10

SELECT h.[Name] AS HotelName
	, SUM(r.Price * DATEDIFF(DAY, b.ArrivalDate, b.DepartureDate))  AS HotelRevenue
FROM Hotels h
	 JOIN Bookings b ON b.HotelId = h.Id
	 JOIN Rooms r ON r.Id = b.RoomId
GROUP BY h.[Name]
ORDER BY HotelRevenue DESC

--11

CREATE OR ALTER FUNCTION udf_RoomsWithTourists(@name VARCHAR(250))
RETURNS INT
BEGIN
	DECLARE @count INT
	
	SELECT @count = SUM(AdultsCount + ChildrenCount) 
	FROM Bookings b
		JOIN Hotels h ON h.Id = b.HotelId
		JOIN Rooms r ON r.Id = b.RoomId
	WHERE r.[Type] = @name

	RETURN @count
END

SELECT dbo.udf_RoomsWithTourists('Double Room')

select SUM(AdultsCount + ChildrenCount) 
FROM Bookings b
	JOIN Hotels h ON h.Id = b.HotelId
	JOIN Rooms r ON r.Id = b.RoomId
WHERE r.[Type] = 'Double Room'

--12

CREATE or alter PROC usp_SearchByCountry(@country NVARCHAR(250))
AS
SELECT t.[Name]
	,t.PhoneNumber
	,t.Email
	,COUNT(t.[Name]) AS CountOfBookings
FROM Tourists t 
	JOIN Bookings b ON t.Id = b.TouristId
	JOIN Hotels h ON h.Id = b.HotelId
	JOIN Destinations d ON d.Id = h.DestinationId
	JOIN Countries c ON c.Id = t.CountryId
WHERE c.[Name] = @country and b.TouristId = T.Id
GROUP BY t.[Name], t.PhoneNumber, t.Email
ORDER BY t.[Name],CountOfBookings DESC


EXEC usp_SearchByCountry 'Greece'