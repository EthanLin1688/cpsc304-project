<!--Test Oracle file for UBC CPSC304 2018 Winter Term 1
  Created by Jiemin Zhang
  Modified by Simona Radu
  Modified by Jessica Wong (2018-06-22)
  This file shows the very basics of how to execute PHP commands
  on Oracle.
  Specifically, it will drop a table, create a table, insert values
  update values, and then query for values

  IF YOU HAVE A TABLE CALLED "demoTable" IT WILL BE DESTROYED

  The script assumes you already have a server set up
  All OCI commands are commands to the Oracle libraries
  To get the file to work, you must place it somewhere where your
  Apache server can run it, and you must rename it to have a ".php"
  extension.  You must also change the username and password on the
  OCILogon below to be your ORACLE username and password -->

  <html>
    <head>
        <title>CPSC 304 Job Board Project</title>
    </head>

    <body>
        <h1> CPSC 304 Job Board Database Demo </h1>
		<div>

        <h2>Result:</h2>
		<?php
		handle();
		?>
		<hr/>

        <h2>Insertion</h2>
        <p>Insert a new posting</p>
        <form method="POST" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="insertQueryRequest" name="insertQueryRequest">
            Posting ID: <input type="text" name="insertPostingID"> <br /><br />
            Posting Type: <input type="text" name="insertPostingType"> <br /><br />
            Salary: <input type="text" name="insertSalary"> <br /><br />
            Start Date (MM/DD/YYYY): <input type="text" name="insertStartDate"> <br /><br />
            Job Description: <input type="text" name="insertJobDescription"> <br /><br />
            Posting Location : <input type="text" name="insertPostingLocation"> <br /><br />
            Company Name: <input type="text" name="insertCompanyName"> <br /><br />
            <input type="submit" value="Insert" name="insertSubmit"></p>
        </form>

        <hr />
		</div>

        <h2>Deletion</h2>
        <p> Remove a company from the database </p>
        <form method="POST" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="deleteQueryRequest" name="deleteQueryRequest">
            Company Name: <input type="text" name="deleteCompanyName"> <br /><br />
            <input type="submit" value="Delete" name="deleteSubmit"></p>
        </form>
        <hr />

        <h2>Update</h2>
        <p>Reject an applicant from all applied positions at a company</p>
        <form method="POST" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="updateQueryRequest" name="updateQueryRequest">
            First Name: <input type="text" name="updateFirstName"> <br /><br />
            Last Name: <input type="text" name="updateLastName"> <br /><br />
            Company Name: <input type="text" name="updateCompanyName"> <br /><br />
            <input type="submit" value="Update" name="updateSubmit"></p>
        </form>
        <hr />

        <h2>Selection Query</h2>
        <p>Find all the information sessions at specified location </p>
        <form method="GET" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="selectionQueryRequest" name="selectionQueryRequest">
            Location: <input type="text" name="selectionLocation"> <br /><br />
            <input type="submit" name="selectionSubmit"></p>
        </form>
        <hr />

        <h2>Projection Query</h2>
        <p>Find the names of all the companies which have positions availible.</p>
        <form method="GET" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="projectionQueryRequest" name="projectionQueryRequest">
            <input type="submit" name="projectionSubmit"></p>
        </form>
        <hr />

        <h2>Join Applicant, Application, Position Tables</h2>
        <p>Select all applicants who will join a position in a given location.</p>
        <form method="GET" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="joinQueryRequest" name="joinQueryRequest">
            Location: <input type="text" name="joinLocation"> <br /><br />
            <input type="submit" name="joinSubmit"></p>
        </form>
        <hr />

        <h2>Aggregation with Count</h2>
        <p>Find the number of recruiters for each company</p>
        <form method="GET" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="aggregationCountRequest" name="aggregationCountRequest">
            <input type="submit" name="aggregationCountSubmit"></p>
        </form>

        <h2>Nested Aggregation with Group By</h2>
        <p>Find the company who has given out the most offers.</p>
        <form method="GET" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="nestedAggregationRequest" name="nestedAggregationRequest">
            <input type="submit" name="nestedAggregationSubmit"></p>
        </form>

        <h2>Division</h2>
        <p>Find all the applicants who have applied to every company that has open postings.</p>
        <form method="GET" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="divisionQueryRequest" name="divisionQueryRequest">
            <input type="submit" name="divisionSubmit"></p>
        </form>

        <?php
		//this tells the system that it's no longer just parsing html; it's now parsing PHP

        $success = True; //keep track of errors so it redirects the page only if there are no errors
        $db_conn = NULL; // edit the login credentials in connectToDB()
        $show_debug_alert_messages = False; // set to True if you want alerts to show you which methods are being triggered (see how it is used in debugAlertMessage())

        function debugAlertMessage($message) {
            global $show_debug_alert_messages;

            if ($show_debug_alert_messages) {
                echo "<script type='text/javascript'>alert('" . $message . "');</script>";
            }
        }

        function executePlainSQL($cmdstr) { //takes a plain (no bound variables) SQL command and executes it
            //echo "<br>running ".$cmdstr."<br>";
            global $db_conn, $success;

            $statement = OCIParse($db_conn, $cmdstr);
            // There are a set of comments at the end of the file that describe some of the OCI specific functions and how they work

            if (!$statement) {
                echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($db_conn); // For OCIParse errors pass the connection handle
                echo htmlentities($e['message']);
                $success = False;
            }

            $r = OCIExecute($statement, OCI_DEFAULT);
            if (!$r) {
                echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                $e = oci_error($statement); // For OCIExecute errors pass the statementhandle
                echo htmlentities($e['message']);
                $success = False;
            }

			return $statement;
		}

        function executeBoundSQL($cmdstr, $list) {
            /* Sometimes the same statement will be executed several times with different values for the variables involved in the query.
		    In this case you don't need to create the statement several times. Bound variables cause a statement to only be 
            parsed once and you can reuse the statement. This is also very useful in protecting against SQL injection.
		    See the sample code below for how this function is used */

			global $db_conn, $success;
			$statement = OCIParse($db_conn, $cmdstr);

            if (!$statement) {
                echo "<br>Cannot parse the following command: " . $cmdstr . "<br>";
                $e = OCI_Error($db_conn);
                echo htmlentities($e['message']);
                $success = False;
            }

            foreach ($list as $tuple) {
                foreach ($tuple as $bind => $val) {
                    //echo $val;
                    //echo "<br>".$bind."<br>";
                    OCIBindByName($statement, $bind, $val);
                    unset ($val); //make sure you do not remove this. Otherwise $val will remain in an array object wrapper which will not be recognized by Oracle as a proper datatype
				}

                $r = OCIExecute($statement, OCI_DEFAULT);
                if (!$r) {
                    echo "<br>Cannot execute the following command: " . $cmdstr . "<br>";
                    $e = OCI_Error($statement); // For OCIExecute errors, pass the statementhandle
                    echo htmlentities($e['message']);
                    echo "<br>";
                    $success = False;
                }
            }
        }

        function printResult($result) { //prints results from a select statement
            echo "<br>Retrieved data from table demoTable:<br>";
            echo "<table>";
            echo "<tr><th>ID</th><th>Name</th></tr>";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr><td>" . $row["ID"] . "</td><td>" . $row["NAME"] . "</td></tr>"; //or just use "echo $row[0]"
            }

            echo "</table>";
        }

        function connectToDB() {
            global $db_conn;

            // Your username is ora_(CWL_ID) and the password is a(student number). For example,
			// ora_platypus is the username and a12345678 is the password.
            $db_conn = OCILogon("ora_azchen", "a75858795", "dbhost.students.cs.ubc.ca:1522/stu");

            if ($db_conn) {
                debugAlertMessage("Database is Connected");
                return true;
            } else {
                debugAlertMessage("Cannot connect to Database");
                $e = OCI_Error(); // For OCILogon errors pass no handle
                echo htmlentities($e['message']);
                return false;
            }
        }

        function disconnectFromDB() {
            global $db_conn;

            debugAlertMessage("Disconnect from Database");
            OCILogoff($db_conn);
        }


		// QUERY FUNCTIONS

		function printInsertRequestResult() {
            $result = executePlainSQL("SELECT * FROM Posting");
            echo "<br>Retrieved data from Posting table:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>Posting ID</th>
					<th>Posting Type</th>
					<th>Salary</th>
					<th>Start Date</th>
					<th>Job Description</th>
					<th>Posting Location</th>
					<th>Company Name</th>
				</tr>";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
						"<td>" . $row[2] . "</td>" . 
						"<td>" . $row[3] . "</td>" . 
						"<td>" . $row[4] . "</td>" . 
						"<td>" . $row[5] . "</td>" . 
						"<td>" . $row[6] . "</td>" . 
					"<tr>";
            }
            echo "</table>";
		}

        function handleInsertRequest() {
            global $db_conn;

            //Getting the values from user and insert data into the table
            $tuple = array (
                ":posting_id" => $_POST['insertPostingID'],
                ":posting_type" => $_POST['insertPostingType'],
                ":salary" => $_POST['insertSalary'],
                ":job_description" => $_POST['insertJobDescription'],
                ":posting_location" => $_POST['insertPostingLocation'],
                ":company_name" => $_POST['insertCompanyName'],
            );

            $alltuples = array (
                $tuple
            );

			echo "<br>POSTING BEFORE INSERT:</br>";
			printInsertRequestResult();

            executeBoundSQL("
				INSERT INTO Posting (
					PostingID, 
					PostingType, 
					Salary, 
					StartDate,
					JobDescription,
					PostingLocation,
					CompanyName
				) 
				VALUES (
					:posting_id, 
					:posting_type, 
					:salary, 
					TO_DATE('".$_POST['insertStartDate']."', 'dd-mm-yyyy'), 
					:job_description, 
					:posting_location, 
					:company_name)
				", 
			$alltuples);
            
			echo "<br>POSTING AFTER INSERT:</br>";
			printInsertRequestResult();
            
            OCICommit($db_conn);
        }

		function printDeleteRequestResult() {
            $result = executePlainSQL("SELECT * FROM Company");

            echo "<br>Retrieved data from Company table:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>Company Name</th>
					<th>Street Name</th>
					<th>City</th>
					<th>State/Province</th>
					<th>Country</th>
					<th>Postal Code</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
						"<td>" . $row[2] . "</td>" . 
						"<td>" . $row[3] . "</td>" . 
						"<td>" . $row[4] . "</td>" . 
						"<td>" . $row[5] . "</td>" . 
					"<tr>"; //or just use "echo $row[0]"
            }

            echo "</table>";
		}

		function handleDeleteRequest() {
            global $db_conn;

            $tuple = array (
                ":company_name" => $_POST['deleteCompanyName'],
            );

            $alltuples = array (
                $tuple
            );

			echo "<br>BEFORE DELETE REQUEST: </br>";
			printDeleteRequestResult();

			executeBoundSQL("
				DELETE 
				FROM Company C
				WHERE C.CompanyName = :company_name
			", $alltuples);

			echo "<br>AFTER DELETE REQUEST: </br>";
			printDeleteRequestResult();
            
            OCICommit($db_conn);
		}

		function printUpdateRequestResult() {
            $result = executePlainSQL("
				SELECT A.FirstName, A.LastName, J.CompanyName, J.Decision
				FROM JobApplication J, Applicant A
				WHERE J.ApplicantID = A.ApplicantID
				ORDER BY J.CompanyName, A.FirstName
			");

            echo "<br>Retrieved data from JobApplication and Applicant tables:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>First Name</th>
					<th>Last Name</th>
					<th>Company Name</th>
					<th>Decision</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
						"<td>" . $row[2] . "</td>" . 
						"<td>" . $row[3] . "</td>" . 
					"<tr>"; //or just use "echo $row[0]"
            }

            echo "</table>";
		}

		function handleUpdateRequest() {
            global $db_conn;

            $tuple = array (
                ":first_name" => $_POST['updateFirstName'],
                ":last_name" => $_POST['updateLastName'],
                ":company_name" => $_POST['updateCompanyName'],
            );

            $alltuples = array (
                $tuple
            );

			echo "<br>RESULT BEFORE UPDATE:</br>";
			printUpdateRequestResult();

			executeBoundSQL("
				UPDATE JobApplication J
				SET J.Decision = 'Rejected'
				WHERE J.CompanyName = :company_name
				  	AND J.ApplicantID IN (
						SELECT A.ApplicantID 
						FROM Applicant A
						WHERE A.FirstName = :first_name
							  AND A.LastName = :last_name
				)
			", $alltuples);

			echo "<br>RESULT AFTER UPDATE:</br>";
			printUpdateRequestResult();
            
            OCICommit($db_conn);
		}

		function handleSelectionRequest() {
            global $db_conn;

			$result = executePlainSQL("
				SELECT *
				FROM InformationSession
				WHERE SessionLocation = '" . $_GET['selectionLocation'] . "'
			");

            echo "<br>Retrieved data from InformationSession table:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>Session ID</th>
					<th>Location</th>
					<th>Date</th>
					<th>CompanyName</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
						"<td>" . $row[2] . "</td>" . 
						"<td>" . $row[3] . "</td>" . 
					"<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
		}

		function handleProjectionRequest() {
            global $db_conn;

			$result = executePlainSQL("
				SELECT DISTINCT CompanyName
				FROM Posting
			");

            echo "<br>Retrieved data from Posting table:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>Company Name</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
					"<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
		}

		function handleJoinRequest() {
            global $db_conn;

			$query = "
				SELECT A.FirstName, A.LastName
				FROM Applicant A, JobApplication J, Posting P
				WHERE A.ApplicantID = J.ApplicantID 
					AND J.PostingID = P.PostingID
					AND P.PostingLocation = '" . $_GET['joinLocation'] . "'
					AND J.Decision = 'Accepted'";

			$result = executePlainSQL($query);

            echo "<br>Retrieved data from Join:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>First Name</th>
					<th>Last Name</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
					"<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
		}

		function handleAggregationCountRequest() {
            global $db_conn;

			$result = executePlainSQL("
				SELECT R.CompanyName, COUNT(*) AS NumRecruiters
				FROM Recruiter R
				GROUP BY R.CompanyName
				ORDER BY NumRecruiters DESC
			");

            echo "<br>Retrieved aggregate data from Recruiters:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>Company Name</th>
					<th>Number of Recruiters</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
					"<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
		}

		function handleNestedAggregationRequest() {
            global $db_conn;

			$result = executePlainSQL("
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
				)
			");

            echo "<br>Retrieved nested aggregate data:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>Company Name</th>
					<th>Number of Offers</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
					"<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
		}

		function handleDivisionRequest() {
            global $db_conn;

			$result = executePlainSQL("
				SELECT A.FirstName, A.LastName
				FROM Applicant A
				WHERE NOT EXISTS (
					(
						SELECT P.CompanyName 
						FROM Posting P
					) 
					MINUS (
						SELECT J.CompanyName
						FROM JobApplication J
						WHERE A.ApplicantID = J.ApplicantID
					)
				)
			");

            echo "<br>Retrieved division data:<br>";
            echo "<table>";
            echo "
				<tr>
					<th>First Name</th>
					<th>Last Name</th>
				</tr>
			";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr>" . 
						"<td>" . $row[0] . "</td>" . 
						"<td>" . $row[1] . "</td>" . 
					"<tr>";
            }

            echo "</table>";
            
            OCICommit($db_conn);
		}

        function write_to_console($data) {
            $console = $data;
            if (is_array($console))
            $console = implode(',', $console);
            
            echo "<script>console.log('Console: " . $console . "' );</script>";
        }


        // HANDLE ALL POST ROUTES
	    // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handlePOSTRequest() {
            if (connectToDB()) {
                if (array_key_exists('deleteQueryRequest', $_POST)) {
                    handleDeleteRequest();
                } else if (array_key_exists('updateQueryRequest', $_POST)) {
                    handleUpdateRequest();
                } else if (array_key_exists('insertQueryRequest', $_POST)) {
                    handleInsertRequest();
                }

                disconnectFromDB();
            }
        }

        // HANDLE ALL GET ROUTES
        // A better coding practice is to have one method that reroutes your requests accordingly. It will make it easier to add/remove functionality.
        function handleGETRequest() {
            if (connectToDB()) {
                if (array_key_exists('selectionSubmit', $_GET)) {
                    handleSelectionRequest();
                } else if (array_key_exists('projectionSubmit', $_GET)) {
                    handleProjectionRequest();
                } else if (array_key_exists('joinSubmit', $_GET)) {
                    handleJoinRequest();
                } else if (array_key_exists('aggregationCountSubmit', $_GET)) {
                    handleAggregationCountRequest();
                } else if (array_key_exists('nestedAggregationSubmit', $_GET)) {
                    handleNestedAggregationRequest();
                } else if (array_key_exists('divisionSubmit', $_GET)) {
                    handleDivisionRequest();
                } 

                disconnectFromDB();
            }
        }

		function handle() {
			if (isset($_POST['deleteSubmit']) || isset($_POST['updateSubmit']) || isset($_POST['insertSubmit'])) {
				handlePOSTRequest();
			} else if (isset($_GET['selectionQueryRequest'])) {
				handleGETRequest();
			} else if (isset($_GET['projectionQueryRequest'])) {
				handleGETRequest();
			} else if (isset($_GET['joinQueryRequest'])) {
				handleGETRequest();
			} else if (isset($_GET['aggregationCountRequest'])) {
				handleGETRequest();
			} else if (isset($_GET['nestedAggregationRequest'])) {
				handleGETRequest();
			} else if (isset($_GET['divisionQueryRequest'])) {
				handleGETRequest();
			} 
		}
        
		?>
	</body>
</html>
