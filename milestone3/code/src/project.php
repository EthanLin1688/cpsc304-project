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

        <h2>Insertion</h2>
        <p>Insert a new posting</p>
        <form method="POST" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="insertQueryRequest" name="insertQueryRequest">
            Posting ID: <input type="text" name="postingID"> <br /><br />
            Posting Type: <input type="text" name="postingName"> <br /><br />
            Salary: <input type="text" name="salary"> <br /><br />
            Start Date (MM/DD/YYYY): <input type="text" name="startDate"> <br /><br />
            Job Description: <input type="text" name="jobDescription"> <br /><br />
            Posting Location : <input type="text" name="postingLocation"> <br /><br />
            Company Name: <input type="text" name="companyName"> <br /><br />
            <input type="submit" value="Insert" name="insertSubmit"></p>
        </form>
        <hr />

        <h2>Deletion</h2>
        <p> Remove a company from the database </p>
        <form method="POST" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="deleteQueryRequest" name="deleteQueryRequest">
            Company Name: <input type="text" name="companyName"> <br /><br />
            <input type="submit" value="Delete" name="deleteSubmit"></p>
        </form>
        <hr />

        <h2>Update</h2>
        <p>Reject an applicant from all applied positions at a company</p>
        <form method="POST" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="updateQueryRequest" name="updateQueryRequest">
            First Name: <input type="text" name="firstName"> <br /><br />
            Last Name: <input type="text" name="lastName"> <br /><br />
            Company Name: <input type="text" name="companyName"> <br /><br />
            <input type="submit" value="Update" name="updateSubmit"></p>
        </form>
        <hr />

        <h2>Selection Query</h2>
        <p>Find all the information sessions at specified location </p>
        <form method="GET" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="selectionQueryRequest" name="selectionQueryRequest">
            Location: <input type="text" name="location"> <br /><br />
            <input type="submit" name="selectSubmit"></p>
        </form>
        <hr />

        <h2>Projection Query</h2>
        <p>Find the names of all the companies which have internships availible</p>
        <form method="GET" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="projectionQueryRequest" name="projectionQueryRequest">
            <input type="submit" name="projectionSubmit"></p>
        </form>
        <hr />

        <h2>Join Applicant, Application, Internship Tables</h2>
        <p>Select all applicants who have been offered a position in a given Location</p>
        <form method="GET" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="joinQueryRequest" name="joinQueryRequest">
            Location: <input type="text" name="values"> <br /><br />
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
        <p>Find the company who has accepted the most interns.</p>
        <form method="GET" action="project.php"> <!--refresh page when submitted-->
            <input type="hidden" id="nestedAggregationRequest" name="nestedAggregationRequest">
            <input type="submit" name="nestedAggregationSubmit"></p>
        </form>

        <h2>Division</h2>
        <p>Find all the applicants who have applied to every company that offers internships</p>
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
            $db_conn = OCILogon("ora_ssl59", "a95102885", "dbhost.students.cs.ubc.ca:1522/stu");

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

        function handleUpdateRequest() {
            global $db_conn;

            $old_name = $_POST['oldName'];
            $new_name = $_POST['newName'];

            // you need the wrap the old name and new name values with single quotations
            executePlainSQL("UPDATE demoTable SET name='" . $new_name . "' WHERE name='" . $old_name . "'");
            OCICommit($db_conn);
        }

        function handleSelectionRequest() {
            global $db_conn;

            $old_name = $_POST['oldName'];
            $new_name = $_POST['newName'];

            // you need the wrap the old name and new name values with single quotations
            executePlainSQL("UPDATE demoTable SET name='" . $new_name . "' WHERE name='" . $old_name . "'");
            OCICommit($db_conn);
        }
        
        function handleInsertRequest() {
            global $db_conn;

            //Getting the values from user and insert data into the table
            $tuple = array (
                ":bind1" => $_POST['postingID'],
                ":bind2" => $_POST['postingType'],
                ":bind3" => $_POST['salary'],
                ":bind4" => strtotime($_POST['startDate']),
                ":bind5" => $_POST['jobDescription'],
                ":bind6" => $_POST['postingLocation'],
                ":bind7" => $_POST['companyName'],
            );

            $alltuples = array (
                $tuple
            );

            write_to_console($alltuples);

            executeBoundSQL("INSERT into Posting (PostingID, PostingType, Salary, StartDate, JobDescription, PostingLocation, CompanyName) values (:bind1, :bind2, :bind3, :bind4, :bind5, :bind6, :bind7)", $alltuples);
            
            $result = executePlainSQL("SELECT PostingID, PostingType, Salary, StartDate, JobDescription, PostingLocation, CompanyName FROM Posting");

            echo "<br>Retrieved data from Posting table:<br>";
            echo "<table>";
            echo "<tr><th>Posting ID</th><th>Posting Type</th><th>Salary</th><th>Start Date</th><th>Job Description</th><th>Posting Location</th><th>Company Name</th></tr>";

            while ($row = OCI_Fetch_Array($result, OCI_BOTH)) {
                echo "<tr><td>" . $row[0] . "</td><td>" . $row[1] . "</td><td>" . $row[2] . "</td><td>" . $row[3] . "</td><td>" . $row[4] . "</td><td>" . $row[5] . "</td><td>" . $row[6] . "</td></tr>"; //or just use "echo $row[0]"
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
                    handleNestedAggregationSubmitRequest();
                } else if (array_key_exists('divisionSubmit', $_GET)) {
                    handleDivisionRequest();
                }

                disconnectFromDB();
            }
        }

		if (isset($_POST['deleteSubmit']) || isset($_POST['updateSubmit']) || isset($_POST['insertSubmit'])) {
            handlePOSTRequest();
        } else if (isset($_GET['selectQueryRequest'])) {
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
        
		?>
	</body>
</html>
