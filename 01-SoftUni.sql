CREATE DATABASE [SoftUni]
USE [SoftUni]


CREATE TABLE [Towns](
[Id] INT IDENTITY PRIMARY KEY,
[Name] NVARCHAR (50) NOT NULL
)

INSERT INTO [Towns]([Name])
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

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
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

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

INSERT INTO [Employees]([FirstName],[MiddleName],[LastName],[JobTitle],[DepartmentId],[HireDate],[Salary])
VALUES
('Ivan','Ivanov','Ivanov','.NET Developer',1,'2013-02-01',3500.00),
('Petar','Petrov','Petrov','Senior Engineer',1,'2004-03-02',4000.00),
('Maria','Petrova','Ivanova','Intern',1,'2016-08-28',525.25),
('Georgi','Teziev','Ivanov','CEO',2,'2007-12-09',3000.00),
('Peter','Pan','Pan','Intern',3,'2016-08-28',599.88)

--19
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM [Employees]

--20
SELECT * FROM Towns ORDER BY [Name]
SELECT * FROM Departments ORDER BY [Name]
SELECT * FROM Employees ORDER BY [Salary] DESC

--21
SELECT [Name] FROM Towns ORDER BY [Name]
SELECT [Name] FROM Departments ORDER BY [Name]
SELECT FirstName,LastName,JobTitle,Salary FROM Employees ORDER BY [Salary] DESC

--22
UPDATE Employees SET Salary = Salary * 1.1
SELECT Salary FROM Employees

--23
USE Hotel

UPDATE Payments SET TaxRate = TaxRate - TaxRate * 0.3
SELECT TaxRate FROM Payments ORDER BY TaxRate

--24
TRUNCATE TABLE Occupancies


