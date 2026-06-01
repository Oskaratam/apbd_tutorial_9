USE ApbdLecture9DbFirstTask;
GO

CREATE TABLE dbo.Students (
    StudentId INT IDENTITY(1,1) PRIMARY KEY,
    IndexNumber NVARCHAR(20) NOT NULL UNIQUE,
    FirstName NVARCHAR(80) NOT NULL,
    LastName NVARCHAR(80) NOT NULL,
    Email NVARCHAR(160) NOT NULL UNIQUE,
    EnrollmentDate DATE NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE dbo.Courses (
    CourseId INT IDENTITY(1,1) PRIMARY KEY,
    Code NVARCHAR(20) NOT NULL UNIQUE,
    Name NVARCHAR(160) NOT NULL,
    Credits INT NOT NULL CHECK (Credits BETWEEN 1 AND 10),
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE dbo.Enrollments (
    EnrollmentId INT IDENTITY(1,1) PRIMARY KEY,
    StudentId INT NOT NULL REFERENCES dbo.Students(StudentId),
    CourseId INT NOT NULL REFERENCES dbo.Courses(CourseId),
    EnrolledAt DATE NOT NULL,
    Status NVARCHAR(30) NOT NULL CHECK (Status IN ('Active', 'Completed', 'Dropped')),
    UNIQUE(StudentId, CourseId)
);

CREATE TABLE dbo.Assignments (
    AssignmentId INT IDENTITY(1,1) PRIMARY KEY,
    CourseId INT NOT NULL REFERENCES dbo.Courses(CourseId),
    Title NVARCHAR(160) NOT NULL,
    Description NVARCHAR(1000) NULL,
    DueDate DATETIME2 NOT NULL,
    MaxPoints INT NOT NULL CHECK (MaxPoints > 0),
    IsPublished BIT NOT NULL DEFAULT 0
);

CREATE TABLE dbo.Submissions (
    SubmissionId INT IDENTITY(1,1) PRIMARY KEY,
    AssignmentId INT NOT NULL REFERENCES dbo.Assignments(AssignmentId),
    StudentId INT NOT NULL REFERENCES dbo.Students(StudentId),
    RepositoryUrl NVARCHAR(300) NOT NULL,
    SubmittedAt DATETIME2 NOT NULL,
    Score INT NULL CHECK (Score >= 0),
    Feedback NVARCHAR(1000) NULL,
    Status NVARCHAR(30) NOT NULL CHECK (Status IN ('Submitted', 'Late', 'Graded')),
    UNIQUE(AssignmentId, StudentId)
);

CREATE INDEX IX_Enrollments_CourseId ON dbo.Enrollments(CourseId);
CREATE INDEX IX_Assignments_CourseId ON dbo.Assignments(CourseId);
CREATE INDEX IX_Assignments_DueDate ON dbo.Assignments(DueDate);
CREATE INDEX IX_Submissions_StudentId ON dbo.Submissions(StudentId);
CREATE INDEX IX_Submissions_AssignmentId ON dbo.Submissions(AssignmentId);
CREATE INDEX IX_Submissions_Status ON dbo.Submissions(Status);
GO

INSERT INTO dbo.Students (IndexNumber, FirstName, LastName, Email, EnrollmentDate, IsActive) VALUES
('s30001', 'Anna', 'Kowalska', 'anna.kowalska@students.example.edu', '2023-10-01', 1),
('s30002', 'Jan', 'Nowak', 'jan.nowak@students.example.edu', '2023-10-01', 1),
('s30003', 'Maria', 'Zielinska', 'maria.zielinska@students.example.edu', '2023-10-01', 1),
('s30004', 'Piotr', 'Wisniewski', 'piotr.wisniewski@students.example.edu', '2023-10-01', 1),
('s30005', 'Katarzyna', 'Lewandowska', 'katarzyna.lewandowska@students.example.edu', '2024-02-15', 1),
('s30006', 'Tomasz', 'Kaminski', 'tomasz.kaminski@students.example.edu', '2024-02-15', 1),
('s30007', 'Ewa', 'Wojcik', 'ewa.wojcik@students.example.edu', '2024-02-15', 1),
('s30008', 'Adam', 'Kaczmarek', 'adam.kaczmarek@students.example.edu', '2024-02-15', 0);

INSERT INTO dbo.Courses (Code, Name, Credits, IsActive) VALUES
('APBD', 'Database Applications', 5, 1),
('PGO', 'Object-Oriented Programming', 5, 1),
('ABD', 'Advanced Databases', 4, 1),
('IDH', 'Data Warehousing and Analytics', 4, 1),
('LEGACY', 'Legacy Systems Integration', 3, 0);

INSERT INTO dbo.Enrollments (StudentId, CourseId, EnrolledAt, Status) VALUES
(1, 1, '2024-10-01', 'Active'),
(1, 2, '2024-10-01', 'Active'),
(2, 1, '2024-10-01', 'Active'),
(2, 3, '2024-10-01', 'Active'),
(3, 1, '2024-10-01', 'Active'),
(3, 4, '2024-10-01', 'Active'),
(4, 1, '2024-10-01', 'Active'),
(4, 2, '2024-10-01', 'Completed'),
(5, 1, '2025-02-20', 'Active'),
(5, 3, '2025-02-20', 'Active'),
(6, 1, '2025-02-20', 'Active'),
(6, 4, '2025-02-20', 'Active'),
(7, 2, '2025-02-20', 'Active'),
(8, 1, '2025-02-20', 'Dropped');

INSERT INTO dbo.Assignments (CourseId, Title, Description, DueDate, MaxPoints, IsPublished) VALUES
(1, 'EF Core Database First', 'Create a SQL Server database, scaffold EF Core classes, and implement selected endpoints.', '2026-06-15T23:59:00', 20, 1),
(1, 'CRUD REST API', 'Implement CRUD endpoints using EF Core and DTOs.', '2026-06-22T23:59:00', 30, 1),
(1, 'Performance Review', 'Find N+1 query issues and fix them with Include or projections.', '2026-06-29T23:59:00', 25, 1),
(2, 'Interfaces and Abstract Classes', 'Prepare a Java application using interfaces and abstract classes.', '2026-06-18T23:59:00', 20, 1),
(3, 'Indexes and Query Plans', 'Analyze query plans and propose useful indexes.', '2026-06-25T23:59:00', 25, 1),
(4, 'Star Schema Design', 'Design a star schema from OLTP data sources.', '2026-07-02T23:59:00', 30, 1),
(1, 'Final API Project', 'Build a small API using EF Core and DTOs.', '2026-07-10T23:59:00', 40, 0);

INSERT INTO dbo.Submissions (AssignmentId, StudentId, RepositoryUrl, SubmittedAt, Score, Feedback, Status) VALUES
(1, 1, 'https://github.com/example/s30001-db-first', '2026-06-10T18:20:00', 18, 'Good scaffold command and clear model structure.', 'Graded'),
(1, 2, 'https://github.com/example/s30002-db-first', '2026-06-11T12:10:00', 15, 'Missing partial class explanation.', 'Graded'),
(1, 3, 'https://github.com/example/s30003-db-first', '2026-06-09T09:45:00', 19, 'Very clean solution.', 'Graded'),
(1, 4, 'https://github.com/example/s30004-db-first', '2026-06-16T10:30:00', 12, 'Late, but mostly correct.', 'Graded'),
(1, 5, 'https://github.com/example/s30005-db-first', '2026-06-12T21:00:00', NULL, NULL, 'Submitted'),
(2, 1, 'https://github.com/example/s30001-crud-api', '2026-06-20T15:30:00', 27, 'Good use of DTOs.', 'Graded'),
(2, 2, 'https://github.com/example/s30002-crud-api', '2026-06-21T11:00:00', 21, 'Repository layer needs cleanup.', 'Graded'),
(2, 3, 'https://github.com/example/s30003-crud-api', '2026-06-19T19:15:00', 29, 'Excellent service layer.', 'Graded'),
(2, 6, 'https://github.com/example/s30006-crud-api', '2026-06-23T08:40:00', NULL, NULL, 'Late'),
(5, 2, 'https://github.com/example/s30002-indexes', '2026-06-24T17:00:00', 22, 'Correct indexes.', 'Graded'),
(5, 5, 'https://github.com/example/s30005-indexes', '2026-06-25T20:00:00', NULL, NULL, 'Submitted'),
(6, 3, 'https://github.com/example/s30003-star-schema', '2026-06-28T14:00:00', 26, 'Good dimensional model.', 'Graded'),
(6, 6, 'https://github.com/example/s30006-star-schema', '2026-06-29T16:10:00', NULL, NULL, 'Submitted');
GO

SELECT 'Database setup complete!' AS Status;
SELECT COUNT(*) AS StudentCount FROM dbo.Students;
SELECT COUNT(*) AS CourseCount FROM dbo.Courses;
GO
