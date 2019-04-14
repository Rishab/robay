<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>roBay</title>
<link rel="stylesheet" href="css/main.css">
</head>
<body>
	<%
		String acc_type = (String) session.getAttribute("acc_type");
		if (acc_type!=null && acc_type.equals("A")) {
			// This assumes session is secured by the server and can't be fudged by an end user...
			%>
				Welcome, ADMINISTRATOR. Click this button to go to the admin control panel, or continue down the page to browse roBay as normal.
				<br>
				<button onclick="location.href='admincontrols.jsp';" class="width-some feedback card-box-2">Admin control panel</button><br>
				<hr>
				<br>
			<%
		}
	%>

	<%
		String name = (String) session.getAttribute("name_user");
	%>
	<h1>Welcome to Robay!</h1>

	<div class="navbar">
		<div class="loginNameChange">
		
		<%
		
		String login_type= "Login";
		if(name !=null){
			login_type = name;
		}

		%>

		<a href="login.jsp" id="login"> <%=login_type%> </a>
		
		</div>

		<a href="register.jsp" id="signup"> Sign Up </a>

		<a href="landingPage.jsp" id="logout onclick= "<% 
				session.invalidate();
			%>"
		> Log Out </a>
	</div>
	
	<div class="search-box">
	<form action="browsing.jsp" method="post">
		<input type= "search-text" name="query" placeholder="Type to search">
		<a class="search-btn" href="#"> </a>
		<button id="myBtn" 
		onclick="location.href='browsing.jsp';">Submit</button> 

	</form>
	</div>

	
</body>

</html>
