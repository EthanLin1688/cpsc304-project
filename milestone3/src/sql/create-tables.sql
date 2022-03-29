CREATE TABLE Applicant (
  ApplicantID      int,
  FirstName          varchar(50),
  LastName           varchar(50),
  PRIMARY KEY (ApplicationID)     
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
  PRIMARY KEY (ApplicantID, PostingID),
  FOREIGN KEY (ApplicantID) 
    REFERENCES Applicant (ApplicantID) 
      ON DELETE CASCADE,
  FOREIGN KEY (PostingID) 
    REFERENCES Posting (PostingID) 
      ON DELETE CASCADE,
  FOREIGN KEY (RecruiterID) 
    REFERENCES Recruiter (RecruiterID) 
      ON DELETE SET DEFAULT,
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE
);

CREATE TABLE Internship (
  PostingID          int,
  Salary             int,
  StartDate          date,
  JobDescription     varchar(100000),
  Location           varchar(100),
  CompanyName        varchar(100) NOT NULL,
  PRIMARY KEY (PostingID),
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE
);

CREATE TABLE FullTime (
  PostingID          int,
  Salary             int,
  StartDate          date,
  JobDescription     varchar(100000),
  Location           varchar(100),
  CompanyName        varchar(100) NOT NULL,
  PRIMARY KEY (PostingID),
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE
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
  PRIMARY KEY (InterviewerID),
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE
);

CREATE TABLE Host (
  InterviewID         int,
  InterviewerID       int DEFAULT NULL,
  PRIMARY KEY (InterviewID, InterviewerID),
  FOREIGN KEY (InterviewID) 
    REFERENCES Interview (InterviewID)
      ON DELETE CASCADE,
  FOREIGN KEY (InterviewerID) 
    REFERENCES Interviewer (InterviewerID)
      ON DELETE SET DEFAULT
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
  PRIMARY KEY (InterviewID),
  FOREIGN KEY (ApplicantID, PostingID) 
    REFERENCES Application (ApplicantID, PostingID) 
      ON DELETE CASCADE
);

CREATE TABLE PhoneScreen (
  InterviewID        int,
  StartDateTime      date,
  EndDateTime        date,
  ApplicantID        int NOT NULL,
  PostingID          int NOT NULL,
  PRIMARY KEY (InterviewID),
  FOREIGN KEY (ApplicantID, PostingID)
    REFERENCES Application (ApplicantID, PostingID)
      ON DELETE CASCADE
);

CREATE TABLE OnsiteInterview (
  InterviewID        int,
  StartDateTime      date,
  EndDateTime        date,
  ApplicantID        int NOT NULL,
  PostingID          int NOT NULL,
  PRIMARY KEY (InterviewID),
  FOREIGN KEY (ApplicantID, PostingID)
    REFERENCES Application (ApplicantID, PostingID)
      ON DELETE CASCADE
);

CREATE TABLE TeamMatching (
  InterviewID        int,
  StartDateTime      date,
  EndDateTime        date,
  ApplicantID        int NOT NULL,
  PostingID          int NOT NULL,
  PRIMARY KEY (InterviewID),
  FOREIGN KEY (ApplicantID, PostingID)
    REFERENCES Application (ApplicantID, PostingID)
      ON DELETE CASCADE
);

CREATE TABLE Recruiter (
  RecruiterID        int,
  FirstName          varchar(50),
  LastName           varchar(50),
  CompanyName        varchar(100) NOT NULL,
  PRIMARY KEY (RecruiterID),
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE
);

CREATE TABLE Post (
  ApplicantID        int,
  PostingID          int,
  CompanyName        varchar(100) NOT NULL,
  PRIMARY KEY (ApplicantID, PostingID),
  FOREIGN KEY (ApplicantID, PostingID) 
    REFERENCES Application (ApplicantID, PostingID),
      ON DELETE CASCADE
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE
);

CREATE TABLE InformationSession (
  SessionID            int,
  Location             varchar(100),
  DateTime             date,
  CompanyName          varchar(100) NOT NULL,
  PRIMARY KEY (SessionID), 
  FOREIGN KEY (CompanyName) 
    REFERENCES Company (CompanyName) 
      ON DELETE CASCADE
);

CREATE TABLE Participates (
  ApplicantID          int,
  PostingID            int,
  SessionID            int,
  PRIMARY KEY (ApplicantID, PostingID, SessionID),
  FOREIGN KEY (ApplicantID, PostingID)
    REFERENCES Application (ApplicantID, PostingID)
      ON DELETE CASCADE,
  FOREIGN KEY (SessionID) 
    REFERENCES InformationSessionHosting(SessionID)
      ON DELETE CASCADE
);
