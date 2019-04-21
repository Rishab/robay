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
<header>
	<div class="left-float">
		<b><em>roBay</em></b>, by Group 18
	</div>
	<div class="right-text">
		<a href="landingPage.jsp" class="capitalize padding-right-tiny decoration-hover visited-navy color-navy">Home</a>
		
		<%
			String acc_type = (String) session.getAttribute("acc_type");
			boolean admin = false;
			boolean staff = false;
			if (acc_type == null) {
				%>
					<a href="login.jsp" class="capitalize padding-right-tiny decoration-hover visited-navy color-navy">Log in</a>
				<%
			} else {
				if (acc_type.equals("A")) {
					admin = true;
				} else if (acc_type.equals("S")) {
					staff = true;
				}
				%>
					<a href="logOut.jsp" class="capitalize padding-right-tiny decoration-hover visited-navy color-navy">Logout</a>
				<%
			}
			
		%>
	</div>
	<hr>
</header>
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
                    <input type="email" name="reciever" maxlength="255" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Subject:</em>
                    <br>
                    <input type="text" name="subject" maxlength="255" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Content:</em>
                    <br>
                    <textarea name="content" cols="40" rows="5" maxlength="5000" class="width-most width-capped-avg"></textarea>
                </div>
            </div>
            <div class="center-flex margin-down-tiny">
                <input type="submit" value="Send" class="width-some width-capped-small pointer card-box-2 feedback">
            </div>
        </form>
    </div>
</body>

</html>
