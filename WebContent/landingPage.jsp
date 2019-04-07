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
		if (acc_type.equals("A")) {
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
	Hi
	<%=name%>, Welcome to Robay!

	<div class="navbar">

		<a href="login.jsp" id="login"> Login </a>
	  
		<a href="register.jsp" id="signup"> SignUp </a>

	</div>

	<div class="search-box">
		<input type= "search-text" name="" placeholder="Type to search">
		<a class="search-btn" href="#"> </a>
		<button id="myBtn" 
		onclick="location.href='browsing.jsp';">Submit</button> 

	</div>

	<script>
		var input = document.getElementById("myInput");
		input.addEventListener("keyup", function(event) {
  		if (event.keyCode === 13) {
   			event.preventDefault();
  			 document.getElementById("myBtn").click();
  			}
		});
	</script>
</body>

</html>
