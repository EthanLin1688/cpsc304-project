-- Create table statements

CREATE TABLE Applicant (
  ApplicantID        int,
  FirstName          varchar(50),
  LastName           varchar(50),
  PRIMARY KEY (ApplicantID)     
);

CREATE TABLE Application (
  ApplicationID      int,
  CoverLetterLink    varchar(100),
  ResumeLink         varchar(100),
  Decision           varchar(20),
  ApplicantID        int,
  PostingID          int,
  RecruiterID        int DEFAULT NULL,
  CompanyName        varchar(100) NOT NULL,
  PRIMARY KEY (ApplicantID, PostingID)
);

CREATE TABLE Internship (
  PostingID          int,
  Salary             int,
  StartDate          date,
  JobDescription     varchar(1000),
  Location           varchar(100),
  CompanyName        varchar(100) NOT NULL,
  PRIMARY KEY (PostingID)
);

CREATE TABLE FullTime (
  PostingID          int,
  Salary             int,
  StartDate          date,
  JobDescription     varchar(1000),
  Location           varchar(100),
  CompanyName        varchar(100) NOT NULL,
  PRIMARY KEY (PostingID)
);

CREATE TABLE Company (
  CompanyName        varchar(100),
  StreetName         varchar(100),
  City               varchar(100),
  StateProvince      varchar(100),
  Country            varchar(100),
  PostalCode         varchar(50),
  PRIMARY KEY (CompanyName)
);

CREATE TABLE Interviewer (
  InterviewerID      int,
  FirstName          varchar(50),
  LastName           varchar(50),
  Position           varchar(50),
  CompanyName        varchar(100) NOT NULL,
  PRIMARY KEY (InterviewerID)
);

CREATE TABLE Host (
  InterviewID         int,
  InterviewerID       int DEFAULT NULL,
  PRIMARY KEY (InterviewID, InterviewerID)
);

CREATE TABLE OnlineAssessment (
  InterviewID        int,
  PositionType       varchar(50),
  Duration           int,
  Difficulty         varchar(10),
  NumberOfQuestions  int,
  CutoffScore        int,
  StartDateTime      date,
  EndDateTime        date,
  ApplicantID        int NOT NULL,
  PostingID          int NOT NULL,
  PRIMARY KEY (InterviewID)
);

CREATE TABLE PhoneScreen (
  InterviewID        int,
  StartDateTime      date,
  EndDateTime        date,
  ApplicantID        int NOT NULL,
  PostingID          int NOT NULL,
  PRIMARY KEY (InterviewID)
);

CREATE TABLE OnsiteInterview (
  InterviewID        int,
  StartDateTime      date,
  EndDateTime        date,
  ApplicantID        int NOT NULL,
  PostingID          int NOT NULL,
  PRIMARY KEY (InterviewID)
);

CREATE TABLE TeamMatching (
  InterviewID        int,
  StartDateTime      date,
  EndDateTime        date,
  ApplicantID        int NOT NULL,
  PostingID          int NOT NULL,
  PRIMARY KEY (InterviewID)
);

CREATE TABLE Recruiter (
  RecruiterID        int,
  FirstName          varchar(50),
  LastName           varchar(50),
  CompanyName        varchar(100) NOT NULL,
  PRIMARY KEY (RecruiterID)
);

CREATE TABLE InformationSession (
  SessionID          int,
  Location           varchar(100),
  DateTime           date,
  CompanyName        varchar(100) NOT NULL,
  PRIMARY KEY (SessionID)
);

CREATE TABLE Participates (
  ApplicantID        int,
  PostingID          int,
  SessionID          int,
  PRIMARY KEY (ApplicantID, PostingID, SessionID)
);

-- Add foreign keys

ALTER TABLE Application ADD
  FOREIGN KEY (ApplicantID) 
    REFERENCES Applicant (ApplicantID) 
      ON DELETE CASCADE,
  FOREIGN KEY (PostingID) 
    REFERENCES Posting (PostingID) 
      ON DELETE CASCADE,
  FOREIGN KEY (RecruiterID) 
    REFERENCES Recruiter (RecruiterID) 
      ON DELETE SET NULL,
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE;

ALTER TABLE Internship ADD
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE;

ALTER TABLE FullTime ADD
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE;

ALTER TABLE Interviewer ADD
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE;

ALTER TABLE Host ADD
  FOREIGN KEY (InterviewID) 
    REFERENCES Interview (InterviewID)
      ON DELETE CASCADE,
  FOREIGN KEY (InterviewerID) 
    REFERENCES Interviewer (InterviewerID)
      ON DELETE SET DEFAULT;

ALTER TABLE OnlineAssessment ADD
  FOREIGN KEY (ApplicantID, PostingID) 
    REFERENCES Application (ApplicantID, PostingID) 
      ON DELETE CASCADE;


ALTER TABLE PhoneScreen ADD
  FOREIGN KEY (ApplicantID, PostingID)
    REFERENCES Application (ApplicantID, PostingID)
      ON DELETE CASCADE;

ALTER TABLE OnsiteInterview ADD
  FOREIGN KEY (ApplicantID, PostingID)
    REFERENCES Application (ApplicantID, PostingID)
      ON DELETE CASCADE;

ALTER TABLE TeamMatching ADD
  FOREIGN KEY (ApplicantID, PostingID)
    REFERENCES Application (ApplicantID, PostingID)
      ON DELETE CASCADE;

ALTER TABLE Recruiter ADD
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE;

ALTER TABLE Recruiter ADD
  FOREIGN KEY (ApplicantID, PostingID) 
    REFERENCES Application (ApplicantID, PostingID)
      ON DELETE CASCADE
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE;

ALTER TABLE InformationSession ADD
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE;

ALTER TABLE Participates ADD
  FOREIGN KEY (ApplicantID, PostingID)
    REFERENCES Application (ApplicantID, PostingID)
      ON DELETE CASCADE,
  FOREIGN KEY (SessionID) 
    REFERENCES InformationSessionHosting(SessionID)
      ON DELETE CASCADE;


-- Populate tables

INSERT ALL
INTO Applicant VALUES (1, 'Steven', 'Li')
INTO Applicant VALUES (2, 'Ethan', 'Lin') 
INTO Applicant VALUES (3, 'Anton', 'Chen') 
INTO Applicant VALUES (4, 'Raymond', 'Ng')
INTO Applicant VALUES (5, 'Kanye', 'West')
INTO Company VALUES ('Amazon', 'Vine', 'Vancouver', 'BC', 'Canada', 'V2A3A6')
INTO Company VALUES ('Google', 'Heather', 'Vancouver', 'BC', 'Canada', 'V6H7A6')
INTO Company VALUES ('Asana', 'Victoria', 'Vancouver', 'BC', 'Canada', 'V2H7U6')
INTO Company VALUES ('Citadel' 'Queen', 'Vancouver', 'BC', 'Canada', 'V1N4B6')
INTO Company VALUES ('Rippling' 'Oak', 'Vancouver', 'BC', 'Canada', 'V7A5A6')
INTO Internship VALUES (1, 10, TO_DATE('10/22/2022', 'DD/MM/YYYY'), 'janitor', 'company bathroom', 'Asana')
INTO Internship VALUES (2, 50, TO_DATE('5/1/2022', 'DD/MM/YYYY'), 'secretary', 'office', 'Google')
INTO Internship VALUES (3, 100, TO_DATE('12/4/2022', 'DD/MM/YYYY'), 'sales', 'office', 'Amazon')
INTO Internship VALUES (4, 500, TO_DATE('10/30/2022', 'DD/MM/YYYY'), 'worker', 'warehouse', 'Amazon')
INTO Internship VALUES (5, 30, TO_DATE('2/28/2023', 'DD/MM/YYYY'), 'sorting documents', 'office', 'Google')
INTO FullTime VALUES (6, 10, TO_DATE('10/22/2022', 'DD/MM/YYYY'), 'janitor', 'company bathroom', 'Happy Land')
INTO FullTime VALUES (7, 50, TO_DATE('5/1/2022', 'DD/MM/YYYY'), 'secretary', 'office', 'Google')
INTO FullTime VALUES (8, 100, TO_DATE('12/4/2022', 'DD/MM/YYYY'), 'sales', 'office', 'Housekeeper')
INTO FullTime VALUES (9, 500, TO_DATE('10/30/2022', 'DD/MM/YYYY'), 'worker', 'warehouse', 'Amazon')
INTO FullTime VALUES (10, 30, TO_DATE('2/28/2023', 'DD/MM/YYYY'), 'sorting documents', 'office', 'Google')
INTO Recruiter VALUES (1, 'Kevin', 'Durant', 'Asana')
INTO Recruiter VALUES (2, 'Kyrie', 'Irving', 'Google')
INTO Recruiter VALUES (3, 'Jeff', 'Bezos', 'Amazon')
INTO Recruiter VALUES (4, 'Lil', 'Pump', 'Housekeeper')
INTO Recruiter VALUES (5, 'Kanye', 'West', 'Google')
INTO Interviewer VALUES (1, 'James', 'Harden', 'Senior Engineer', 'Asana')
INTO Interviewer VALUES (2, 'LeBron', 'James', 'Junior Engineer', 'Google')
INTO Interviewer VALUES (3, 'Michael', 'Jordan', 'Junior Engineer', 'Amazon')
INTO Interviewer VALUES (4, 'Stephen', 'Curry', 'Project Manager', 'Housekeeper')
INTO Interviewer VALUES (5, 'Chris', 'Paus', 'Principal Engineer', 'Google')
INTO Application VALUES (1, 'stevenli.com/coverletter.pdf', 'stevenli.com/resume.pdf', 'Offer', 1, 1, 1, 'Asana')
INTO Application VALUES (2, 'ethanlin.com/coverletter.pdf', 'ethanlin.com/resume.pdf', 'Accepted', 2, 2, 2, 'Google')
INTO Application VALUES (3, 'antonchen.com/coverletter.pdf', 'antonchen.com/resume.pdf', 'Rejected', 3, 3, 3, 'Amazon')
INTO Application VALUES (4, 'antonchen.com/coverletter.pdf', 'antonchen.com/resume.pdf', 'Rejected', 3, 2, 2, 'Google')
INTO Application VALUES (5, 'antonchen.com/coverletter.pdf', 'antonchen.com/resume.pdf', 'Rejected', 3, 1, 1, 'Asana')
INTO InformationSession VALUES (1, 'zoom', TO_DATE('5/1/2022', 'DD/MM/YYYY'), 'Asana')
INTO InformationSession VALUES (2, 'zoom', TO_DATE('5/10/2022', 'DD/MM/YYYY'), 'Google')
INTO InformationSession VALUES (3, 'zoom', TO_DATE('10/10/2022', 'DD/MM/YYYY'), 'Amazon')
INTO InformationSession VALUES (4, 'zoom', TO_DATE('11/11/2022', 'DD/MM/YYYY'), 'Citadel')
INTO InformationSession VALUES (5, 'zoom', TO_DATE('12/12/2022', 'DD/MM/YYYY'), 'Rippling')
INTO OnlineAssessment VALUES 
(1, 'Intern', 70, 'Easy', 4, 800, TO_DATE('5/2/2022', 'DD/MM/YYYY'), TO_DATE('5/9/2022', 'DD/MM/YYYY'), 1, 1)
INTO OnlineAssessment VALUES 
(2, 'Intern', 80, 'Medium', 4, 800, TO_DATE('3/4/2022', 'DD/MM/YYYY'), TO_DATE('5/1/2022', 'DD/MM/YYYY'), 2, 2)
INTO OnlineAssessment VALUES 
(3, 'Intern', 90, 'Hard', 4, 800, TO_DATE('5/6/2022', 'DD/MM/YYYY'), TO_DATE('5/19/2022', 'DD/MM/YYYY'), 3, 3)
INTO OnlineAssessment VALUES 
(4, 'Intern', 70, 'Medium', 4, 800, TO_DATE('5/7/2022', 'DD/MM/YYYY'), TO_DATE('5/9/2022', 'DD/MM/YYYY'), 3, 2)
INTO OnlineAssessment VALUES 
(5, 'Intern', 60, 'Easy', 4, 800, TO_DATE('5/8/2022', 'DD/MM/YYYY'), TO_DATE('6/9/2022', 'DD/MM/YYYY'), 3, 1)
INTO PhoneScreen VALUES 
(6, TO_DATE('5/1/2022', 'DD/MM/YYYY'), TO_DATE('10/30/2022', 'DD/MM/YYYY'), 1, 1)
INTO PhoneScreen VALUES 
(7, TO_DATE('6/2/2022', 'DD/MM/YYYY'), TO_DATE('11/20/2022', 'DD/MM/YYYY'), 2, 2)
INTO PhoneScreen VALUES 
(8, TO_DATE('7/2/2022', 'DD/MM/YYYY'), TO_DATE('8/10/2022', 'DD/MM/YYYY'), 3, 3)
INTO PhoneScreen VALUES 
(9, TO_DATE('8/2/2022', 'DD/MM/YYYY'), TO_DATE('8/10/2022', 'DD/MM/YYYY'), 3, 1)
INTO PhoneScreen VALUES 
(10, TO_DATE('6/2/2022', 'DD/MM/YYYY'), TO_DATE('6/1/2022', 'DD/MM/YYYY'), 3, 2)
INTO OnsiteInterview VALUES 
(11, TO_DATE('5/1/2022', 'DD/MM/YYYY'), TO_DATE('10/30/2022', 'DD/MM/YYYY'), 1, 1)
INTO OnsiteInterview VALUES 
(12, TO_DATE('6/2/2022', 'DD/MM/YYYY'), TO_DATE('11/20/2022', 'DD/MM/YYYY'), 2, 2)
INTO OnsiteInterview VALUES 
(13, TO_DATE('7/2/2022', 'DD/MM/YYYY'), TO_DATE('8/10/2022', 'DD/MM/YYYY'), 3, 3)
INTO OnsiteInterview VALUES 
(14, TO_DATE('8/2/2022', 'DD/MM/YYYY'), TO_DATE('8/10/2022', 'DD/MM/YYYY'), 3, 1)
INTO OnsiteInterview VALUES 
(15, TO_DATE('6/2/2022', 'DD/MM/YYYY'), TO_DATE('6/1/2022', 'DD/MM/YYYY'), 3, 2)
INTO TeamMatching VALUES 
(16, TO_DATE('5/1/2022', 'DD/MM/YYYY'), TO_DATE('10/30/2022', 'DD/MM/YYYY'), 1, 1)
INTO TeamMatching VALUES 
(17, TO_DATE('6/2/2022', 'DD/MM/YYYY'), TO_DATE('11/20/2022', 'DD/MM/YYYY'), 2, 2)
INTO TeamMatching VALUES 
(18, TO_DATE('7/2/2022', 'DD/MM/YYYY'), TO_DATE('8/10/2022', 'DD/MM/YYYY'), 3, 3)
INTO TeamMatching VALUES 
(19, TO_DATE('8/2/2022', 'DD/MM/YYYY'), TO_DATE('8/10/2022', 'DD/MM/YYYY'), 3, 1)
INTO TeamMatching VALUES 
(20, TO_DATE('6/2/2022', 'DD/MM/YYYY'), TO_DATE('6/1/2022', 'DD/MM/YYYY'), 3, 2)
INTO Participate VALUES (1, 1, 1)
INTO Participate VALUES (2, 3, 2)
INTO Participate VALUES (3, 3, 3)
INTO Participate VALUES (3, 1, 1)
INTO Participate VALUES (3, 2, 2)
INTO Host VALUES (1, 1) 
INTO Host VALUES (2, 2)
INTO Host VALUES (3, 3)
INTO Host VALUES (4, 4)
INTO Host VALUES (5, 5)
SELECT 1 FROM DUAL;
