/* =========================================
   DATABASE
========================================= */
CREATE DATABASE DsaPrepTrackerDB;
GO

USE DsaPrepTrackerDB;
GO

/* =========================================
   USERS TABLE
========================================= */
CREATE TABLE Users (
    Id UNIQUEIDENTIFIER NOT NULL
        CONSTRAINT PK_Users PRIMARY KEY
        DEFAULT NEWID(),

    Email NVARCHAR(100) NOT NULL
        CONSTRAINT UQ_Users_Email UNIQUE,

    PasswordHash NVARCHAR(255) NOT NULL,

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSDATETIME()
);
GO

/* =========================================
   DSA PROBLEMS TABLE
========================================= */
CREATE TABLE DsaProblems (
    Id INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_DsaProblems PRIMARY KEY,

    UserId UNIQUEIDENTIFIER NOT NULL,

    Title NVARCHAR(200) NOT NULL,

    Topic INT NOT NULL,
    Difficulty INT NOT NULL,
    Platform INT NOT NULL,
    Status INT NOT NULL,

    ProblemLink NVARCHAR(500) NULL,

    Notes NVARCHAR(MAX) NULL,

    SolvedDate DATETIME2 NULL,

    RevisionCount INT NOT NULL
        DEFAULT 0,

    CreatedAt DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),
UpdatedAt DATETIME2 NULL,
     NeedRevision BIT NOT NULL
    CONSTRAINT DF_DsaProblems_NeedRevision DEFAULT 0,

    CONSTRAINT FK_DsaProblems_Users
        FOREIGN KEY (UserId)
        REFERENCES Users(Id)
        ON DELETE CASCADE
);
GO

/* =========================================
   CHECK CONSTRAINTS (ENUM SAFETY)
========================================= */

-- Difficulty: 0 = Easy, 1 = Medium, 2 = Hard
ALTER TABLE DsaProblems
ADD CONSTRAINT CK_DsaProblems_Difficulty
CHECK (Difficulty IN (0, 1, 2));
GO

-- Status: 0 = NotStarted, 1 = InProgress, 2 = Solved, 3 = Revisit
ALTER TABLE DsaProblems
ADD CONSTRAINT CK_DsaProblems_Status
CHECK (Status IN (0, 1, 2));
GO

/* =========================================
   INDEXES (PERFORMANCE)
========================================= */
CREATE INDEX IX_DsaProblems_UserId
ON DsaProblems(UserId);
GO

CREATE INDEX IX_DsaProblems_Topic
ON DsaProblems(Topic);
GO

CREATE INDEX IX_DsaProblems_Status
ON DsaProblems(Status);
GO

/* =========================================
   SAMPLE DATA (OPTIONAL - FOR TESTING)
========================================= */

INSERT INTO Users (Email, PasswordHash)
VALUES ('test@example.com', 'hashed-password');
GO

INSERT INTO DsaProblems
(
    UserId,
    Title,
    Topic,
    Difficulty,
    Platform,
    Status,
    ProblemLink,
    Notes
)
VALUES
(
    (SELECT Id FROM Users WHERE Email = 'test@example.com'),
    'Two Sum',
    0,  -- Arrays
    0,  -- Easy
    0,  -- LeetCode
    2,  -- Solved
    'https://leetcode.com/problems/two-sum/',
    'Use hashmap to store complement'
);
GO

CREATE PROCEDURE sp_AddUser
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        RAISERROR ('User already exists', 16, 1);
        RETURN;
    END

    INSERT INTO Users (Email, PasswordHash)
    VALUES (@Email, @PasswordHash);
END;
GO

CREATE PROCEDURE sp_AddDsaProblem
    @UserId UNIQUEIDENTIFIER,
    @Title NVARCHAR(200),
    @Topic INT,
    @Difficulty INT,
    @Platform INT,
    @Status INT,
    @ProblemLink NVARCHAR(500) = NULL,
    @Notes NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRAN;

    INSERT INTO DsaProblems
    (
        UserId,
        Title,
        Topic,
        Difficulty,
        Platform,
        Status,
        ProblemLink,
        Notes
    )
    VALUES
    (
        @UserId,
        @Title,
        @Topic,
        @Difficulty,
        @Platform,
        @Status,
        @ProblemLink,
        @Notes
    );

    COMMIT TRAN;
END;
GO


select * from Users;
select * from DsaProblems;