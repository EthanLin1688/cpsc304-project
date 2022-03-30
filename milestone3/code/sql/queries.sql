-- INSERT
-- "Insert a new job internship job posting."
INSERT 
INTO Internship 
VALUES (
  :posting_id, 
  :salary, 
  :start_date, 
  :job_description, 
  :location, 
  :company_name
);

-- DELETE
-- "Remove a company from the database."
DELETE 
FROM Company C
WHERE C.CompanyName = :company_name;

-- UPDATE
-- "Reject an applicant from all applied positions at a company."
UPDATE JobApplication J
SET J.Decision = 'Rejected'
WHERE J.CompanyName = :company_name
  AND J.ApplicantID IN (
    SELECT A.ApplicantID 
    FROM Applicant A
    WHERE A.FirstName = :first_name
      AND A.LastName = :last_name
);

-- SELECTION
-- "Find all the information sessions at specified location."
SELECT *
FROM InformationSession I
WHERE I.Location IS :location;

-- PROJECTION QUERY
-- "Find the names of all companies which have internships available."
SELECT DISTINCT I.CompanyName
FROM Internship I;

-- JOIN QUERY
-- "Select all applicants who will join a position in a given location."
SELECT A.FirstName, A.LastName
FROM Applicant A, JobApplication J, Posting P
WHERE A.ApplicantID = J.ApplicantID 
  AND J.PostingID = P.PostingID
  AND P.PostingLocation = :location
  AND J.Decision = 'Accepted';

-- AGGREGATION
-- "Find the number of recruiters for each company."
SELECT R.CompanyName, COUNT(*) AS NumRecruiters
FROM Recruiter R
GROUP BY R.CompanyName
ORDER BY NumRecruiters DESC;

-- NESTED AGGREGATION
-- "Find the company who has given out the most offers."
WITH OfferCount AS (
  SELECT J.CompanyName, COUNT(*) AS NumOffers
  FROM JobApplication J, Posting P
  WHERE J.PostingID = P.PostingID 
    AND (J.Decision = 'Offer' OR J.Decision = 'Accepted')
  GROUP BY J.CompanyName
)
SELECT OC.CompanyName, OC.NumOffers
FROM OfferCount OC
WHERE OC.NumOffers = (
  SELECT MAX(OC2.NumOffers)
  FROM OfferCount OC2
);

-- DIVISION
-- "Find all the applicants who have applied to every company that has postings."
SELECT A.FirstName, A.LastName
FROM Applicant A
WHERE NOT EXISTS (
  (
    SELECT P.CompanyName 
    FROM Posting P
  ) MINUS (
    SELECT J.CompanyName
    FROM JobApplication J
    WHERE A.ApplicantID = J.ApplicantID
  )
);
