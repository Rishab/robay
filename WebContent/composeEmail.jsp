<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>roBay: Compose Email</title>
    <link rel="stylesheet" href="css/main.css">
</head>
<body>
    <div class="center-text margin-up">
        <h2>
            <em>Compose Email</em>
        </h2>
    </div>
    <div class="height-tiny"></div>

    <div class="center width-most width-capped-decent card-box">
        <form action="createEmail.jsp" method =  "post" class="">
            <div class="margin-up-tiny margin-down-tiny margin-left-small">
                <div class="margin-down-tiny">
                    <em>To:</em>
                    <br>
                    <input type="email" name="reciever" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Subject:</em>
                    <br>
                    <input type="text" name="subject" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Content:</em>
                    <br>
                    <input type="text" name="content" class="width-most width-capped-avg">
                </div>
            </div>
            <div class="center-flex margin-down-tiny">
                <input type="submit" value="Send" class="width-some width-capped-small pointer card-box-2 feedback">
            </div>
        </form>
    </div>
</body>

</html>
