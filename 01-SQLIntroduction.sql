CREATE TABLE [Towns](
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR (100) NOT NULL,
	)

CREATE TABLE [Minions](
	[Id] INT PRIMARY KEY,
	[Name] NVARCHAR (50) NOT NULL,
	[Age] TINYINT,
	[TownId] INT FOREIGN KEY REFERENCES [Towns]([Id])
	)

-- vnimavai s podredbata na valutata (id,name) taka shte budat insertnati
INSERT INTO [Towns]([Id],[Name])
	VALUES
	(1, 'Sofia'),
	(2, 'Plovdiv'),
	(3, 'Varna')

INSERT INTO [Minions]([Id],[Name],[Age],[TownId])
	VALUES
	(1, 'Kevin', 22, 1),
	(2, 'Bob', 15, 3),
	(3, 'Steward', NULL, 2)

-- promenqsh, dobavqsh, triesh poletata ! 
--ALTER TABLE [Minions]

--DELETES THE TABLE
--DROP TABLE [Minions]


-- EMPTY THE TABLE (CLEAR THE DATA)
--TRUNCATE TABLE [Minions]


CREATE TABLE [People](
	[Id] INT IDENTITY PRIMARY KEY,
	[Name] NVARCHAR (200) NOT NULL,
	[Picture] VARBINARY(MAX),
	CHECK (DATALENGTH ([Picture]) <= 2000000),
	[Height] DECIMAL(3,2),
	[Weight] DECIMAL(5,2),
	[Gender] CHAR (1) NOT NULL,
	CHECK ([Gender] = 'm' OR [Gender] = 'f'),
	[Birthdate] DATE NOT NULL,
	[Biography] NVARCHAR (MAX)
)

INSERT INTO [People]([Name],[Height],[Weight],[Gender],[Birthdate])
	VALUES
	('Daniel',1.77, 75.2, 'm','1996-02-13'),
	('Evgeni',1.95, 123.2, 'm','1998-11-05'),
	('Daniel2',1.77, 75.2, 'm','1992-05-25'),
	('Daniel3',1.77, 75.2, 'm','1993-05-25'),
	('Daniel4',1.77, 75.2, 'm','1994-05-25')

CREATE TABLE [Users](
	[Id] INT,
	[Username] VARCHAR(30) NOT NULL,
	CHECK (LEN ([Username]) >= 3),
	[Password] VARCHAR(26) NOT NULL,
	CHECK (LEN ([Password]) >= 5),
	[ProfilePicture] VARBINARY(MAX),
	CHECK (DATALENGTH ([ProfilePicture]) <= 921600),
	[LastLoginTime] DATETIME2 DEFAULT GETDATE(),
	[IsDeleted] VARCHAR,
	CHECK ([IsDeleted] = 'true' OR [IsDeleted] = 'false')
)


INSERT INTO [Users]([Username],[Password])
	VALUES
	('Daniel','1221134555aaa'),
	('Evgeni','2221134555aaa'),
	('Daniel2','3221134555aa'),
	('Daniel3','4221134555aa'),
	('Daniel4','5221134555aa')



SELECT 
	[Username] + '' + [Password]as [Id]
from Users


--doesnt work for what ever reason !!
INSERT INTO [Users]([Username],[Password],[IsDeleted])
	VALUES
	('Daniel','1221134555aaa','false'),
	('Evgeni','2221134555aaa','true'),
	('Daniel2','3221134555aa','false'),
	('Daniel3','4221134555aa','false'),
	('Daniel4','5221134555aa','false')

DROP TABLE [Users]


CREATE TABLE [Directors](
 [Id] INT IDENTITY PRIMARY KEY,
 [DirectorName] NVARCHAR (100) NOT NULL,
 [Notes] NVARCHAR (MAX)
)

CREATE TABLE [Genres] (
 [Id] INT IDENTITY PRIMARY KEY,
 [GenreName] NVARCHAR (100) NOT NULL,
 [Notes] NVARCHAR (MAX)
)

CREATE TABLE [Categories](
 [Id] INT IDENTITY PRIMARY KEY,
 [CategoryName] NVARCHAR (100) NOT NULL,
 [Notes] NVARCHAR (MAX)
)

INSERT INTO [Directors](DirectorName)
VALUES
('Fredie Merqy'),
('Francis Ford Copula'),
('Shamalon'),
('Eddie Murphy'),
('Chuck Noris')

INSERT INTO [Genres]([GenreName])
VALUES
('Horror'),
('Comedy'),
('Action'),
('Comedy'),
('Mistery')

INSERT INTO [Categories](CategoryName)
VALUES
('Crime'),
('Western'),
('Drama'),
('Romance'),
('Triller')

CREATE TABLE [Movies] (
	[Id] INT IDENTITY PRIMARY KEY,
	[Title] NVARCHAR (150)NOT NULL,
	[DirectorId] INT FOREIGN KEY REFERENCES [Directors],
	[CopyrightYear] DATE,
	[Length] DECIMAL (5,2) NOT NULL,
	[GenresId] INT FOREIGN KEY REFERENCES [Genres],
	[CategoriesId] INT FOREIGN KEY REFERENCES [Categories],
	[Rating] INT,
	[Notes] NVARCHAR (MAX)
)

INSERT INTO [Movies] ([Title],[DirectorId],[Length],[GenresId],[CategoriesId])
VALUES
('The Good, The Bad and The Ugly', 1, 113.20, 5, 1),
('The Good, The Bad and The Lazy', 2, 123.20, 4, 2),
('The Good, The Bad and The Crazy', 3, 133.20, 3, 3),
('The Good, The Bad and The Broke', 4, 143.20, 2, 4),
('The Good, The Bad and The Homeles', 5, 153.20, 1, 5)

--DROP TABLE [Movies]

CREATE DATABASE [Car Rental]

CREATE TABLE [Categories](
 [Id] INT IDENTITY PRIMARY KEY,
 [CategoryName] NVARCHAR (100) NOT NULL,
 [DailyRate] MONEY NOT NULL,
 [WeeklyRate] MONEY NOT NULL,
 [MonthlyRate] MONEY NOT NULL,
 [WeekendRate] MONEY NOT NULL
)

INSERT INTO [Categories]([CategoryName],[DailyRate],[WeeklyRate],[MonthlyRate],[WeekendRate])
VALUES
('WHO',25.23,70.30,420.69,33.33),
('CARES',25.23,70.30,420.69,33.23),
('WHO',25.23,70.30,420.69,33.13)

CREATE TABLE [Cars](
 [Id] INT IDENTITY PRIMARY KEY,
 [PlateNumber] NVARCHAR(10) NOT NULL,
 [Manufacturer]NVARCHAR(10) NOT NULL,
 [Model] NVARCHAR(10) NOT NULL,
 [CarYear] DATE NOT NULL,
 [CategoryId] INT FOREIGN KEY REFERENCES [Categories],
 [Doors]INT ,
 [Picture] IMAGE,
 [Condition] NVARCHAR(20),
 [Available] VARCHAR(250),
 CHECK ([Available] = 'true' OR [Available] = 'false')
)

INSERT INTO [Cars]([PlateNumber],[Manufacturer],[Model],[CarYear],[CategoryId],[Available])
VALUES
('WH1555CA','AUDI','A3','2013-05-25',1,'true'),
('WH2554CA','AUDI','A4','2014-05-25',2,'true'),
('WH3553CA','AUDI','A5','2015-05-25',3,'false')

CREATE TABLE [Employees](
 [Id] INT IDENTITY PRIMARY KEY,
 [FirstName] NVARCHAR(15) NOT NULL,
 [LastName] NVARCHAR(15) NOT NULL,
 [Title] NVARCHAR(10) NOT NULL,
 [Notes] NVARCHAR(10) ,
)

INSERT INTO [Employees]([FirstName],[LastName],[Title])
VALUES
('George','Kostov','mrs'),
('Ivanka','Petkova','mrs'),
('Pepi','Krika','mr')

CREATE TABLE [Customers](
 [Id] INT IDENTITY PRIMARY KEY,
 [DriverLicenceNumber] NVARCHAR(20) NOT NULL,
 [FullName] NVARCHAR(40) NOT NULL,
 [City] NVARCHAR(30) NOT NULL,
 [ZIPCode] NVARCHAR(10) NOT NULL,
 [Notes] NVARCHAR(10)
)

INSERT INTO [Customers]([DriverLicenceNumber],[FullName],[City],[ZIPCode])
VALUES
('13sad11','George Kostov','Pernik','1233'),
('12sad12','Ivanka Petkova','Sliven','4122'),
('11sad13','Pepi Krika','Sofia','1322')

CREATE TABLE [RentalOrders](
 [Id] INT IDENTITY PRIMARY KEY,
 [EmployeeId] INT FOREIGN KEY REFERENCES [Employees],
 [CustomerId] INT FOREIGN KEY REFERENCES [Customers],
 [CarId] INT FOREIGN KEY REFERENCES [Cars],
 [TankLevel] DECIMAL NOT NULL,
 [KilometrageStart] INT NOT NULL,
 [KilometrageEnd] INT NOT NULL,
 [TotalKilometrage] INT NOT NULL,
 [StartDate] DATE NOT NULL,
 [EndDate] DATE NOT NULL,
 [TotalDays] INT NOT NULL,
 [RateApplied] DECIMAL,
 [TaxRate] DECIMAL,
 [OrderStatus] NVARCHAR(50) NOT NULL,
 [Notes] NVARCHAR
)

INSERT INTO [RentalOrders]([EmployeeId],[CustomerId],[CarId],[TankLevel],[KilometrageStart],[KilometrageEnd],[TotalKilometrage],[StartDate],[EndDate],[TotalDays],[OrderStatus])
VALUES
(1,1,1,12.21,100,200,100,'2023-09-17','2023-09-24',7,'in progress'),
(2,2,2,12.22,100,200,100,'2023-09-17','2023-09-24',7,'in progress'),
(3,3,3,12.23,100,200,100,'2023-09-17','2023-09-24',7,'in progress')



CREATE DATABASE [Hotel]

CREATE TABLE [Employees](
 [Id] INT IDENTITY PRIMARY KEY,
 [FirstName] NVARCHAR(15) NOT NULL,
 [LastName] NVARCHAR(15) NOT NULL,
 [Title] NVARCHAR(10) NOT NULL,
 [Notes] NVARCHAR(100) ,
)

INSERT INTO [Employees]([FirstName],[LastName],[Title])
VALUES
('Frank','Sinatra','mr'),
('Joji','Poo','mrs'),
('Ema','Buckins','ms')

CREATE TABLE [Customers](
 [AccountNumber] INT IDENTITY PRIMARY KEY,
 [FirstName] NVARCHAR(40) NOT NULL,
 [LastName] NVARCHAR(40) NOT NULL,
 [PhoneNumber] INT NOT NULL,
 [EmergencyName] NVARCHAR(40),
 [EmergencyNumber] INT,
 [Notes] NVARCHAR(100)
)

INSERT INTO [Customers]([FirstName],[LastName],[PhoneNumber])
VALUES
('Popi','Sin',0729993),
('Carl','Willims',0982288),
('Josh','Smith', 0928826762)

CREATE TABLE [RoomStatus](
 [RoomStatus] VARCHAR (20) PRIMARY KEY,
 [Notes] NVARCHAR(100)
)

INSERT INTO [RoomStatus]([RoomStatus])
VALUES
('free'),
('deaprting'),
('taken')

CREATE TABLE [RoomTypes](
 [RoomType] VARCHAR (20) PRIMARY KEY,
 [Notes] NVARCHAR(100)
)

INSERT INTO [RoomTypes]([RoomType])
VALUES
('single'),
('double'),
('apartament')

CREATE TABLE [BedTypes](
 [BedType] VARCHAR (20) PRIMARY KEY,
 [Notes] NVARCHAR(100)
)

INSERT INTO [BedTypes]([BedType])
VALUES
('single'),
('double'),
('king')

CREATE TABLE [Rooms](
 [RoomNumber] INT IDENTITY PRIMARY KEY,
 [RoomType] VARCHAR (20)FOREIGN KEY REFERENCES [RoomTypes],
 [BedType] VARCHAR (20)FOREIGN KEY REFERENCES [BedTypes],
 [Rate] MONEY NOT NULL,
 [RoomStatus] VARCHAR (20)FOREIGN KEY REFERENCES [RoomStatus],
 [Notes] NVARCHAR(100)
)



INSERT INTO [Rooms]([RoomType],[BedType],[Rate],[RoomStatus])
VALUES
('single','single',11.11,'free'),
('double','double',22.22,'deaprting'),
('apartament','king',33.33,'taken')

CREATE TABLE [Payments](
 [Id] INT IDENTITY PRIMARY KEY,
 [EmployeeId] INT FOREIGN KEY REFERENCES [Employees],
 [PaymentDate] DATE NOT NULL,
 [AccountNumber] INT FOREIGN KEY REFERENCES [Customers],
 [FirstDateOccupied] DATE NOT NULL,
 [LastDateOccupied] DATE NOT NULL,
 [TotalDays] INT NOT NULL,
 [AmountCharged] MONEY NOT NULL,
 [TaxRate] DECIMAL,
 [TaxAmount] MONEY,
 [PaymentTotal] MONEY NOT NULL,
 [Notes] NVARCHAR(100)
)

INSERT INTO [Payments]([EmployeeId],[PaymentDate],[AccountNumber],[FirstDateOccupied],[LastDateOccupied],[TotalDays],[AmountCharged],[PaymentTotal])
VALUES
(1,'2023-09-17',1,'2023-09-15','2023-09-17',2,100,100),
(2,'2023-09-17',2,'2023-09-15','2023-09-17',2,200,200),
(3,'2023-09-17',3,'2023-09-15','2023-09-17',2,300,300)

CREATE TABLE [Occupancies](
 [Id] INT IDENTITY PRIMARY KEY,
 [EmployeeId] INT FOREIGN KEY REFERENCES [Employees],
 [DateOccupied] DATE NOT NULL,
 [AccountNumber] INT FOREIGN KEY REFERENCES [Customers],
 [RateApplied] DECIMAL,
 [PhoneCharge] MONEY,
 [Notes] NVARCHAR(100)
)

INSERT INTO [Occupancies]([EmployeeId],[DateOccupied],[AccountNumber])
VALUES
(1,'2023-09-15',1),
(2,'2023-09-15',2),
(3,'2023-09-15',3)

UPDATE Payments SET TaxRate = TaxRate * 0.7
SELECT TaxRate FROM Payments

CREATE DATABASE [SoftUni]

CREATE TABLE [Towns](
[Id] INT IDENTITY PRIMARY KEY,
[Name] NVARCHAR (50) NOT NULL
)

INSERT INTO [Towns]([Name])
VALUES
('Sofia'),
('Pernik'),
('Svoge')


CREATE TABLE [Addresses](
[Id] INT IDENTITY PRIMARY KEY,
[AddressText] NVARCHAR (50) NOT NULL,
[TownId] INT FOREIGN KEY REFERENCES [Towns]
)

INSERT INTO [Addresses]([AddressText],[TownId])
VALUES
('obelq bl.279',1),
('obelq bl.279',2),
('obelq bl.279',3)

CREATE TABLE [Departments](
[Id] INT IDENTITY PRIMARY KEY,
[Name] NVARCHAR (50) NOT NULL
)

INSERT INTO [Departments]([Name])
VALUES
('Engeneering'),
('Sales'),
('Maitanens')

CREATE TABLE [Employees](
[Id] INT IDENTITY PRIMARY KEY,
[FirstName] NVARCHAR (50) NOT NULL,
[MiddleName] NVARCHAR (50) NOT NULL,
[LastName] NVARCHAR (50) NOT NULL,
[JobTitle] NVARCHAR (50) NOT NULL,
[DepartmentId] INT FOREIGN KEY REFERENCES [Departments],
[HireDate] DATE NOT NULL,
[Salary] DECIMAL(8) NOT NULL,
[AddressId] INT FOREIGN KEY REFERENCES [Addresses]
)

INSERT INTO [Employees]([FirstName],[MiddleName],[LastName],[JobTitle],[DepartmentId],[HireDate],[Salary],[AddressId])
VALUES
('Pepi','Pepi','Pepi','Senior',1,'2023-09-13',123000.23,1),
('Geri','Geri','Geri','Junior',2,'2023-09-13',123000.23,2),
('Slavi','Slavi','Slavi','Supervisor',3,'2023-09-13',123000.23,3)

