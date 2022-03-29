-- INSERT
-- "Insert a new job internship job posting"
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
UPDATE Applications AP, Applicant A
SET AP.Decision = 'rejected'
WHERE A.ApplicantID = AP.ApplicantID 
  AND A.FirstName = :first_name
  AND A.LastAnme = :last_name
  AND AP.CompanyName = :company_name;

-- SELECTION
-- "Find all the information sessions at specified location"
SELECT *
FROM InformationSession I
WHERE I.Location IS :location;

-- PROJECTION QUERY
-- "Find the names of all companies which have internships available."
SELECT I.CompanyName
FROM Internship I;

-- JOIN QUERY
-- "Select all applicants who have been offered a position in a given city."
SELECT A.FirstName, A.LastName
FROM Applicant A, Application AP, Internship I, FullTime FT
WHERE A.ApplicantID = AP.ApplicationID AND (
    AP.PostingID = I.PostingID
    AND I.Location LIKE :location
  ) OR (
    AP.PostingID = FT.PostingID
    AND I.Location LIKE :location
);

-- AGGREGATION
-- "Find the number of recruiters for each company"
SELECT R.CompanyName, COUNT(*)
FROM Recruiter R
GROUP BY R.CompanyName;

-- NESTED AGGREGATION
-- "Find the company who has accepted the most interns."
WITH InternCount AS (
  SELECT CompanyName, COUNT(*) AS NumInterns
  FROM Application AP, Internship I
  WHERE AP.PostingId = I.PostingID 
    AND (AP.Decision = 'Offer' OR AP.Decison = 'Accepted')
  GROUP BY AP.CompanyName
)
SELECT MAX(IC.NumInterns)
FROM InternCount IC;

-- DIVISION
-- "Find all the applicants who have applied to every company that offers internships."
SELECT A.FirstName, A.LastName
FROM Applicant A
WHERE NOT EXISTS (
  (
    SELECT C.CompanyName 
    FROM Company C;
  ) EXCEPT (
    SELECT AP.CompanyName
    FROM Application AP
    WHERE A.ApplicantID = AP.ApplicantID
  )
);
