INSERT INTO Applicant VALUES(95102885, 'Steven', 'Li');
INSERT INTO Applicant VALUES(56009681, 'Ethan', 'Lin');
INSERT INTO Applicant VALUES(75758795, 'Anton', 'Chen');
INSERT INTO Applicant VALUES(10000000, 'Raymond', 'Ng');
INSERT INTO Applicant VALUES(10000001, 'Kanye', 'West');

INSERT INTO Application VALUES('stevenli.com/coverletter.pdf', 'stevenli.com/resume.pdf', 'Offer', 95102885, 10000000, 30000000, 'Asana');
INSERT INTO Application VALUES('ethanlin.com/coverletter.pdf', 'ethanlin.com/resume.pdf', 'Accepted', 56009681, 10000001, 30000001, 'Google');
INSERT INTO Application VALUES('antonchen.com/coverletter.pdf', 'antonchen.com/resume.pdf', 'Rejected', 75858795, 10000002, 30000002, 'Amazon');

INSERT INTO Internship VALUES(1000, 10, '10/22/2022', 'janitor', 'company bathroom', 'Happy Land');
INSERT INTO Internship VALUES(1001, 50, '5/1/2022', 'secretary', 'office', 'Google');
INSERT INTO Internship VALUES(1002, 100, '12/4/2022', 'sales', 'office', 'Housekeeper');
INSERT INTO Internship VALUES(1003, 500, '10/30/2022', 'worker', 'warehouse', 'Amazon');
INSERT INTO Internship VALUES(1004, 30, '2/28/2023', 'sorting documents', 'office', 'Google');

INSERT INTO FullTime VALUES(1005, 10, '10/22/2022', 'janitor', 'company bathroom', 'Happy Land');
INSERT INTO FullTime VALUES(1006, 50, '5/1/2022', 'secretary', 'office', 'Google');
INSERT INTO FullTime VALUES(1007, 100, '12/4/2022', 'sales', 'office', 'Housekeeper');
INSERT INTO FullTime VALUES(1008, 500, '10/30/2022', 'worker', 'warehouse', 'Amazon');
INSERT INTO FullTime VALUES(1009, 30, '2/28/2023', 'sorting documents', 'office', 'Google');

INSERT INTO Recruiter VALUES(7800776, 'Steven', 'Li', 'Amazon');
INSERT INTO Recruiter VALUES(4352343, 'Ethan', 'Lin', 'Amazon');
INSERT INTO Recruiter VALUES(4365645, 'Anton', 'Chen', 'Happy Land');
INSERT INTO Recruiter VALUES(4537451, 'Raymond', 'Ng', 'Housekeeper');
INSERT INTO Recruiter VALUES(1232433, 'Kanye', 'West', 'Google');

INSERT INTO Company VALUES('Amazon', 'Vine', 'Vancouver', 'BC', 'Canada', 'V2A3A6');
INSERT INTO Company VALUES('Google', 'Heather', 'Vancouver', 'BC', 'Canada', 'V6H7A6');
INSERT INTO Company VALUES('Happy', 'Queen', 'Vancouver', 'BC', 'Canada', 'V1N4B6');
INSERT INTO Company VALUES('Housekeeper', 'Oak', 'Vancouver', 'BC', 'Canada', 'V7A5A6');
INSERT INTO Company VALUES('Asana', 'Victoria', 'Vancouver', 'BC', 'Canada', 'V2H7U6');

INSERT INTO Interviewer VALUES(7800776, 'Steven', 'Li', 'Amazon');
INSERT INTO Interviewer VALUES(4352343, 'Ethan', 'Lin', 'Amazon');
INSERT INTO Interviewer VALUES(4365645, 'Anton', 'Chen', 'Happy Land');
INSERT INTO Interviewer VALUES(4537451, 'Raymond', 'Ng', 'Housekeeper');
INSERT INTO Interviewer VALUES(1232433, 'Kanye', 'West', 'Google');

INSERT INTO Host VALUES(7800776, 586785947);
INSERT INTO Host VALUES(4352343, 928143721);
INSERT INTO Host VALUES(4365645, 983473298);
INSERT INTO Host VALUES(4537451, 921837921);
INSERT INTO Host VALUES(4532421, 872463872);

INSERT INTO OnlineAssessment1 VALUES('FullTime', 3, 'Easy', 5, 90);
INSERT INTO OnlineAssessment1 VALUES('FullTime', 5, 'Hard', 5, 10);
INSERT INTO OnlineAssessment1 VALUES('Intern', 1, 'Easy', 100, 50);
INSERT INTO OnlineAssessment1 VALUES('FullTime', 6, 'Hard', 60, 70);
INSERT INTO OnlineAssessment1 VALUES('Intern', 12, 'Medium', 90, 30);

INSERT INTO OnlineAssessment2 VALUES(7800776, 586785947, 'FullTime', '5/1/2022', '10/30/2022', 762134827, 73648712);
INSERT INTO OnlineAssessment2 VALUES(4352343, 928143721, 'FullTime', '12/4/2022', '3/5/2023', 824637129, 271863427);
INSERT INTO OnlineAssessment2 VALUES(4365645, 983473298, 'Intern', '10/22/2022', '12/30/2022', 21984721987, 3984979128);
INSERT INTO OnlineAssessment2 VALUES(4537451, 921837921, 'FullTime', '2/28/2023', '2/28/2024', 29387210, 2198347219);
INSERT INTO OnlineAssessment2 VALUES(4532421, 872463872, 'Intern', '10/30/2022', '10/30/2022', 29837219, 129783378);

INSERT INTO PhoneScreen VALUES(7800776, 586785947, 'FullTime', 10, '5/1/2022', '10/30/2022', 762134827, 73648712);
INSERT INTO PhoneScreen VALUES(4352343, 928143721, 'FullTime', 10, '12/4/2022', '3/5/2023', 824637129, 271863427);
INSERT INTO PhoneScreen VALUES(4365645, 983473298, 'Intern', 5, '10/22/2022', '12/30/2022', 21984721987, 3984979128);
INSERT INTO PhoneScreen VALUES(4537451, 921837921, 'FullTime', 8, '2/28/2023', '2/28/2024', 29387210, 2198347219);
INSERT INTO PhoneScreen VALUES(4532421, 872463872, 'Intern', 20, '10/30/2022', '10/30/2022', 29837219, 129783378);

INSERT INTO OnsiteInterview VALUES(7800776, 586785947, 'FullTime', 10, '5/1/2022', '10/30/2022', 762134827, 73648712);
INSERT INTO OnsiteInterview VALUES(4352343, 928143721, 'FullTime', 10, '12/4/2022', '3/5/2023', 824637129, 271863427);
INSERT INTO OnsiteInterview VALUES(4365645, 983473298, 'Intern', 5, '10/22/2022', '12/30/2022', 21984721987, 3984979128);
INSERT INTO OnsiteInterview VALUES(4537451, 921837921, 'FullTime', 8, '2/28/2023', '2/28/2024', 29387210, 2198347219);
INSERT INTO OnsiteInterview VALUES(4532421, 872463872, 'Intern', 20, '10/30/2022', '10/30/2022', 29837219, 129783378);

INSERT INTO TeamMatching VALUES(7800776, 586785947, 'FullTime', 10, '5/1/2022', '10/30/2022', 762134827, 73648712);
INSERT INTO TeamMatching VALUES(4352343, 928143721, 'FullTime', 10, '12/4/2022', '3/5/2023', 824637129, 271863427);
INSERT INTO TeamMatching VALUES(4365645, 983473298, 'Intern', 5, '10/22/2022', '12/30/2022', 21984721987, 3984979128);
INSERT INTO TeamMatching VALUES(4537451, 921837921, 'FullTime', 8, '2/28/2023', '2/28/2024', 29387210, 2198347219);
INSERT INTO TeamMatching VALUES(4532421, 872463872, 'Intern', 20, '10/30/2022', '10/30/2022', 29837219, 129783378);

INSERT INTO InformationSession VALUES(7800776, 'zoom', '5/1/2022', 'Google');
INSERT INTO InformationSession VALUES(3847219, 'zoom', '5/10/2022', 'Google');
INSERT INTO InformationSession VALUES(2839721, 'zoom', '10/10/2022', 'Amazon');
INSERT INTO InformationSession VALUES(7238121, 'zoom', '11/11/2022', 'Amazon');
INSERT INTO InformationSession VALUES(2823980, 'zoom', '12/12/2022', 'Asana');

INSERT INTO Participate VALUES(7800776, 586785947, 23232322);
INSERT INTO Participate VALUES(4352343, 928143721, 23254654);
INSERT INTO Participate VALUES(4365645, 983473298, 32323223);
INSERT INTO Participate VALUES(4537451, 921837921, 23235455);
INSERT INTO Participate VALUES(4532421, 872463872, 325465676);
