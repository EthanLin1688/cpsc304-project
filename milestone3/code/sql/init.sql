-- Create table statements

CREATE TABLE Applicant (
  ApplicantID        int,
  FirstName          varchar(50),
  LastName           varchar(50),
  CONSTRAINT applicant_pk PRIMARY KEY (ApplicantID)     
);

CREATE TABLE JobApplication (
  JobApplicationID      int,
  CoverLetterLink    varchar(100),
  ResumeLink         varchar(100),
  Decision           varchar(20),
  ApplicantID        int,
  PostingID          int,
  RecruiterID        int,
  CompanyName        varchar(100) NOT NULL,
  CONSTRAINT application_pk PRIMARY KEY (ApplicantID, PostingID)
);

CREATE TABLE Posting (
  PostingID          int,
  PostingType        varchar(20),
  Salary             int,
  StartDate          date,
  JobDescription     varchar(1000),
  PostingLocation           varchar(100),
  CompanyName        varchar(100) NOT NULL,
  CONSTRAINT posting_pk PRIMARY KEY (PostingID)
);

CREATE TABLE Company (
  CompanyName        varchar(100),
  StreetName         varchar(100),
  City               varchar(100),
  StateProvince      varchar(100),
  Country            varchar(100),
  PostalCode         varchar(50),
  CONSTRAINT company_pk PRIMARY KEY (CompanyName)
);

CREATE TABLE Interviewer (
  InterviewerID      int,
  FirstName          varchar(50),
  LastName           varchar(50),
  Position           varchar(50),
  CompanyName        varchar(100) NOT NULL,
  CONSTRAINT interviewer_pk PRIMARY KEY (InterviewerID)
);

CREATE TABLE Host (
  InterviewID         int,
  InterviewerID       int DEFAULT NULL,
  CONSTRAINT host_pk PRIMARY KEY (InterviewID, InterviewerID)
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
  CONSTRAINT online_assessment_pk PRIMARY KEY (InterviewID)
);

CREATE TABLE PhoneScreen (
  InterviewID        int,
  StartDateTime      date,
  EndDateTime        date,
  ApplicantID        int NOT NULL,
  PostingID          int NOT NULL,
  CONSTRAINT phone_screen_pk PRIMARY KEY (InterviewID)
);

CREATE TABLE OnsiteInterview (
  InterviewID        int,
  StartDateTime      date,
  EndDateTime        date,
  ApplicantID        int NOT NULL,
  PostingID          int NOT NULL,
  CONSTRAINT onsite_interview_pk PRIMARY KEY (InterviewID)
);

CREATE TABLE TeamMatching (
  InterviewID        int,
  StartDateTime      date,
  EndDateTime        date,
  ApplicantID        int NOT NULL,
  PostingID          int NOT NULL,
  CONSTRAINT team_matching_pk PRIMARY KEY (InterviewID)
);

CREATE TABLE Recruiter (
  RecruiterID        int,
  FirstName          varchar(50),
  LastName           varchar(50),
  CompanyName        varchar(100) NOT NULL,
  CONSTRAINT recruiter_pk PRIMARY KEY (RecruiterID)
);

CREATE TABLE InformationSession (
  SessionID          int,
  SessionLocation    varchar(100),
  SessionDate        date,
  CompanyName        varchar(100) NOT NULL,
  CONSTRAINT information_session_pk PRIMARY KEY (SessionID)
);

CREATE TABLE Participate (
  ApplicantID        int,
  PostingID          int,
  SessionID          int,
  CONSTRAINT participate_pk PRIMARY KEY (ApplicantID, PostingID, SessionID)
);

-- Add foreign keys

ALTER TABLE JobApplication ADD (
  CONSTRAINT application_fk_applicant
    FOREIGN KEY (ApplicantID) 
      REFERENCES Applicant (ApplicantID) 
        ON DELETE CASCADE,
  CONSTRAINT application_fk_posting
    FOREIGN KEY (PostingID) 
      REFERENCES Posting (PostingID) 
        ON DELETE CASCADE,
  CONSTRAINT application_fk_recruiter
    FOREIGN KEY (RecruiterID) 
      REFERENCES Recruiter (RecruiterID) 
        ON DELETE CASCADE,
  CONSTRAINT application_fk_company
    FOREIGN KEY (CompanyName) 
      REFERENCES Company (CompanyName) 
        ON DELETE CASCADE
);

ALTER TABLE Posting ADD (
  CONSTRAINT posting_fk_company
    FOREIGN KEY (CompanyName) 
      REFERENCES Company (CompanyName) 
        ON DELETE CASCADE
);

ALTER TABLE Interviewer ADD (
  CONSTRAINT interviewer_fk_company
    FOREIGN KEY (CompanyName) 
      REFERENCES Company (CompanyName) 
        ON DELETE CASCADE
);

ALTER TABLE Host ADD (
  CONSTRAINT host_fk_interview
    FOREIGN KEY (InterviewID) 
      REFERENCES Interview (InterviewID)
        ON DELETE CASCADE,
  CONSTRAINT host_fk_interviewer
    FOREIGN KEY (InterviewerID) 
      REFERENCES Interviewer (InterviewerID)
        ON DELETE CASCADE
);

ALTER TABLE OnlineAssessment ADD (
  CONSTRAINT online_assessment_fk_application 
    FOREIGN KEY (ApplicantID, PostingID) 
      REFERENCES JobApplication (ApplicantID, PostingID) 
        ON DELETE CASCADE
);

ALTER TABLE PhoneScreen ADD (
  CONSTRAINT phone_screen_fk_application
    FOREIGN KEY (ApplicantID, PostingID)
      REFERENCES JobApplication (ApplicantID, PostingID)
        ON DELETE CASCADE
);

ALTER TABLE OnsiteInterview ADD (
  CONSTRAINT onsite_interview_fk_application
    FOREIGN KEY (ApplicantID, PostingID)
      REFERENCES JobApplication (ApplicantID, PostingID)
        ON DELETE CASCADE
);

ALTER TABLE TeamMatching ADD (
  CONSTRAINT team_matching_fk_application
    FOREIGN KEY (ApplicantID, PostingID)
      REFERENCES JobApplication (ApplicantID, PostingID)
        ON DELETE CASCADE
);

ALTER TABLE Recruiter ADD (
  CONSTRAINT recruiter_fk_company
    FOREIGN KEY (CompanyName) 
      REFERENCES Company (CompanyName) 
        ON DELETE CASCADE
);

ALTER TABLE InformationSession ADD (
  CONSTRAINT information_session_fk_company
    FOREIGN KEY (CompanyName) 
      REFERENCES Company (CompanyName) 
        ON DELETE CASCADE
);

ALTER TABLE Participate ADD (
  CONSTRAINT participates_fk_application
    FOREIGN KEY (ApplicantID, PostingID)
      REFERENCES JobApplication (ApplicantID, PostingID)
        ON DELETE CASCADE,
  CONSTRAINT participates_fk_information_session
    FOREIGN KEY (SessionID) 
      REFERENCES InformationSession(SessionID)
        ON DELETE CASCADE
);

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
INTO Company VALUES ('Citadel', 'Queen', 'Vancouver', 'BC', 'Canada', 'V1N4B6')
INTO Company VALUES ('Rippling', 'Oak', 'Vancouver', 'BC', 'Canada', 'V7A5A6')
INTO Posting VALUES (1, 'Internship', 10, TO_DATE('10/22/2022', 'MM/DD/YYYY'), 'janitor', 'company bathroom', 'Asana')
INTO Posting VALUES (2, 'Internship', 50, TO_DATE('5/1/2022', 'MM/DD/YYYY'), 'secretary', 'office', 'Google')
INTO Posting VALUES (3, 'FullTime', 100, TO_DATE('12/4/2022', 'MM/DD/YYYY'), 'sales', 'office', 'Amazon')
INTO Posting VALUES (4, 'FullTime', 500, TO_DATE('10/30/2022', 'MM/DD/YYYY'), 'worker', 'warehouse', 'Amazon')
INTO Posting VALUES (5, 'Internship', 30, TO_DATE('2/28/2023', 'MM/DD/YYYY'), 'sorting documents', 'office', 'Google')
INTO Recruiter VALUES (1, 'Kevin', 'Durant', 'Asana')
INTO Recruiter VALUES (2, 'Kyrie', 'Irving', 'Google')
INTO Recruiter VALUES (3, 'Jeff', 'Bezos', 'Amazon')
INTO Recruiter VALUES (4, 'Lil', 'Pump', 'Rippling')
INTO Recruiter VALUES (5, 'Kanye', 'West', 'Google')
INTO Interviewer VALUES (1, 'James', 'Harden', 'Senior Engineer', 'Asana')
INTO Interviewer VALUES (2, 'LeBron', 'James', 'Junior Engineer', 'Google')
INTO Interviewer VALUES (3, 'Michael', 'Jordan', 'Junior Engineer', 'Amazon')
INTO Interviewer VALUES (4, 'Stephen', 'Curry', 'Project Manager', 'Rippling')
INTO Interviewer VALUES (5, 'Chris', 'Paus', 'Principal Engineer', 'Google')
INTO JobApplication VALUES (1, 'stevenli.com/coverletter.pdf', 'stevenli.com/resume.pdf', 'Offer', 1, 1, 1, 'Asana')
INTO JobApplication VALUES (2, 'ethanlin.com/coverletter.pdf', 'ethanlin.com/resume.pdf', 'Accepted', 2, 2, 2, 'Google')
INTO JobApplication VALUES (3, 'antonchen.com/coverletter.pdf', 'antonchen.com/resume.pdf', 'Rejected', 3, 3, 3, 'Amazon')
INTO JobApplication VALUES (4, 'antonchen.com/coverletter.pdf', 'antonchen.com/resume.pdf', 'Rejected', 3, 2, 2, 'Google')
INTO JobApplication VALUES (5, 'antonchen.com/coverletter.pdf', 'antonchen.com/resume.pdf', 'Rejected', 3, 1, 1, 'Asana')
INTO InformationSession VALUES (1, 'zoom', TO_DATE('5/1/2022', 'MM/DD/YYYY'), 'Asana')
INTO InformationSession VALUES (2, 'zoom', TO_DATE('5/10/2022', 'MM/DD/YYYY'), 'Google')
INTO InformationSession VALUES (3, 'zoom', TO_DATE('10/10/2022', 'MM/DD/YYYY'), 'Amazon')
INTO InformationSession VALUES (4, 'zoom', TO_DATE('11/11/2022', 'MM/DD/YYYY'), 'Citadel')
INTO InformationSession VALUES (5, 'zoom', TO_DATE('12/12/2022', 'MM/DD/YYYY'), 'Rippling')
INTO OnlineAssessment VALUES 
(1, 'Intern', 70, 'Easy', 4, 800, TO_DATE('5/2/2022', 'MM/DD/YYYY'), TO_DATE('5/9/2022', 'MM/DD/YYYY'), 1, 1)
INTO OnlineAssessment VALUES 
(2, 'Intern', 80, 'Medium', 4, 800, TO_DATE('3/4/2022', 'MM/DD/YYYY'), TO_DATE('5/1/2022', 'MM/DD/YYYY'), 2, 2)
INTO OnlineAssessment VALUES 
(3, 'Intern', 90, 'Hard', 4, 800, TO_DATE('5/6/2022', 'MM/DD/YYYY'), TO_DATE('5/19/2022', 'MM/DD/YYYY'), 3, 3)
INTO OnlineAssessment VALUES 
(4, 'Intern', 70, 'Medium', 4, 800, TO_DATE('5/7/2022', 'MM/DD/YYYY'), TO_DATE('5/9/2022', 'MM/DD/YYYY'), 3, 2)
INTO OnlineAssessment VALUES 
(5, 'Intern', 60, 'Easy', 4, 800, TO_DATE('5/8/2022', 'MM/DD/YYYY'), TO_DATE('6/9/2022', 'MM/DD/YYYY'), 3, 1)
INTO PhoneScreen VALUES 
(6, TO_DATE('5/1/2022', 'MM/DD/YYYY'), TO_DATE('10/30/2022', 'MM/DD/YYYY'), 1, 1)
INTO PhoneScreen VALUES 
(7, TO_DATE('6/2/2022', 'MM/DD/YYYY'), TO_DATE('11/20/2022', 'MM/DD/YYYY'), 2, 2)
INTO PhoneScreen VALUES 
(8, TO_DATE('7/2/2022', 'MM/DD/YYYY'), TO_DATE('8/10/2022', 'MM/DD/YYYY'), 3, 3)
INTO PhoneScreen VALUES 
(9, TO_DATE('8/2/2022', 'MM/DD/YYYY'), TO_DATE('8/10/2022', 'MM/DD/YYYY'), 3, 1)
INTO PhoneScreen VALUES 
(10, TO_DATE('6/2/2022', 'MM/DD/YYYY'), TO_DATE('6/1/2022', 'MM/DD/YYYY'), 3, 2)
INTO OnsiteInterview VALUES 
(11, TO_DATE('5/1/2022', 'MM/DD/YYYY'), TO_DATE('10/30/2022', 'MM/DD/YYYY'), 1, 1)
INTO OnsiteInterview VALUES 
(12, TO_DATE('6/2/2022', 'MM/DD/YYYY'), TO_DATE('11/20/2022', 'MM/DD/YYYY'), 2, 2)
INTO OnsiteInterview VALUES 
(13, TO_DATE('7/2/2022', 'MM/DD/YYYY'), TO_DATE('8/10/2022', 'MM/DD/YYYY'), 3, 3)
INTO OnsiteInterview VALUES 
(14, TO_DATE('8/2/2022', 'MM/DD/YYYY'), TO_DATE('8/10/2022', 'MM/DD/YYYY'), 3, 1)
INTO OnsiteInterview VALUES 
(15, TO_DATE('6/2/2022', 'MM/DD/YYYY'), TO_DATE('6/1/2022', 'MM/DD/YYYY'), 3, 2)
INTO TeamMatching VALUES 
(16, TO_DATE('5/1/2022', 'MM/DD/YYYY'), TO_DATE('10/30/2022', 'MM/DD/YYYY'), 1, 1)
INTO TeamMatching VALUES 
(17, TO_DATE('6/2/2022', 'MM/DD/YYYY'), TO_DATE('11/20/2022', 'MM/DD/YYYY'), 2, 2)
INTO TeamMatching VALUES 
(18, TO_DATE('7/2/2022', 'MM/DD/YYYY'), TO_DATE('8/10/2022', 'MM/DD/YYYY'), 3, 3)
INTO TeamMatching VALUES 
(19, TO_DATE('8/2/2022', 'MM/DD/YYYY'), TO_DATE('8/10/2022', 'MM/DD/YYYY'), 3, 1)
INTO TeamMatching VALUES 
(20, TO_DATE('6/2/2022', 'MM/DD/YYYY'), TO_DATE('6/1/2022', 'MM/DD/YYYY'), 3, 2)
INTO Participate VALUES (1, 1, 1)
INTO Participate VALUES (2, 2, 2)
INTO Participate VALUES (3, 3, 3)
INTO Participate VALUES (3, 1, 1)
INTO Participate VALUES (3, 2, 2)
INTO Host VALUES (1, 1) 
INTO Host VALUES (2, 2)
INTO Host VALUES (3, 3)
INTO Host VALUES (4, 4)
INTO Host VALUES (5, 5)
SELECT 1 FROM DUAL;
