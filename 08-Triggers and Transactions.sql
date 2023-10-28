--1
USE Bank

CREATE TABLE Logs
(
	LogId INT IDENTITY,
	AccountId INT FOREIGN KEY REFERENCES Accounts(Id),
	OldSum DECIMAL(18, 4),
	NewSum DECIMAL(18, 4)
)
GO

CREATE TRIGGER tr_AddToLogsOnAccountUpdate
ON Accounts FOR UPDATE
AS
INSERT INTO Logs VALUES
(
	(SELECT Id FROM inserted), 
	(SELECT Balance FROM deleted), 
	(SELECT Balance FROM inserted)
)

--2

CREATE TABLE NotificationEmails(
	Id INT PRIMARY KEY IDENTITY
	,Recipient VARCHAR(50)
	,Subject NVARCHAR (300)
	,Body NVARCHAR (300)
)

GO

CREATE OR ALTER TRIGGER tr_CreateNewEmail
ON Logs FOR UPDATE
AS
INSERT INTO NotificationEmails VALUES
(
 (SELECT AccountId  FROM inserted)
 ,(SELECT 'Balance change for account: '+ CAST(AccountId AS VARCHAR(300)) FROM inserted)
 ,(SELECT 'On' + 
	FORMAT(GETDATE(), 'MMM DD YYYY H:MMTT') +
	' your balance was changed from ' +
	CAST(OldSum AS VARCHAR(300)) +
	' to ' +
	CAST(NewSum AS VARCHAR(300)) + '.'
	FROM inserted)
)

--3

CREATE OR ALTER PROC usp_DepositMoney(@AccountId INT, @MoneyAmount DECIMAL(18,4)) 
AS
	IF (@moneyAmount < 0) THROW 50001, 'Invalid amount', 1
	UPDATE Accounts
	SET Balance += @moneyAmount
	WHERE Id = @accountId

EXEC usp_DepositMoney 1 ,10

--4


CREATE OR ALTER PROC usp_WithdrawMoney(@AccountId INT, @MoneyAmount DECIMAL(18,4)) 
AS
	IF (@moneyAmount < 0) THROW 50001, 'Invalid amount', 1
	UPDATE Accounts
	SET Balance -= @moneyAmount
	WHERE Id = @accountId

EXEC usp_WithdrawMoney 1 ,10

--5

CREATE OR ALTER PROC usp_TransferMoney (@SenderId INT, @ReceiverId INT, @Amount DECIMAL(18,4))
AS
	IF (@Amount < 0) THROW 50001, 'Invalid amount', 1
	UPDATE Accounts
	SET Balance -= @Amount
	WHERE Id = @SenderId
	
	UPDATE Accounts
	SET Balance += @Amount
	WHERE Id = @ReceiverId
--6 MISSING
--7*


--8
USE SoftUni

CREATE OR ALTER PROC usp_AssignProject(@emloyeeId INT, @projectID INT)
AS
	BEGIN TRANSACTION 
		DECLARE @ProjectCount int =  
			(
			SELECT COUNT(ProjectID)
			FROM EmployeesProjects
			WHERE EmployeeID = @emloyeeId
			)
			IF (@ProjectCount >= 3) -- Equal to 3?? Problem description incorrect
	BEGIN
		RAISERROR('The employee has too many projects!', 16, 1)
		ROLLBACK		
	END

	INSERT INTO EmployeesProjects VALUES
		(@emloyeeId, @projectID)
COMMIT TRANSACTION
 
 --9
 CREATE TABLE Deleted_Employees
(
	EmployeeId INT PRIMARY KEY IDENTITY, 
	FirstName VARCHAR(50), 
	LastName VARCHAR(50), 
	MiddleName VARCHAR(50), 
	JobTitle VARCHAR(50), 
	DepartmentId INT, 
	Salary DECIMAL(18, 2)
)
GO


CREATE TRIGGER tr_AddEntityToDeletedEmployeesTable
ON Employees FOR DELETE
AS
INSERT INTO Deleted_Employees
	SELECT		
		FirstName,
		LastName,
		MiddleName,
		JobTitle,
		DepartmentID,
		Salary
	FROM deleted