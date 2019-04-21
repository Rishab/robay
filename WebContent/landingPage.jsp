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
		<style>
				.body {
					background-color: red;
				}
				.myHeader {
				  background-color: lightblue;
				  color: black;
				  padding: 40px;
				  text-align: center;
				} 
		
				</style>
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
		} else if (acc_type!=null && acc_type.equals("S")) {
			// This assumes session is secured by the server and can't be fudged by an end user...
			%>
				Welcome, STAFF. Click this button to go to the staff control panel, or continue down the page to browse roBay as normal.
				<br>
				<button onclick="location.href='staffcontrols.jsp';" class="width-some feedback card-box-2">Staff control panel</button><br>
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
		
		<%
		
		String login_type= "Login";
		if(name != null){
			login_type = name;

		%>
		
		<%="Weclome " + login_type%>
		</br>
		<a href="index.jsp" id="logout"> Log Out </a>
		<button onclick="location.href='profile.jsp';" class="width-some feedback card-box-2">
        	<h3 class="capitalize">Profile</h3>
        </button>


		<% 
		}else{
		%>
		
		<a href="register.jsp" id="signup"> Sign Up </a>
		<div class="loginNameChange">
		
		<a href="login.jsp" id="login"> <%=login_type%> </a>
		
		</div>
		
		<%
		}
		
		%>
	</div>
	
	<div class="search-box">
	<form action="browsing.jsp" method="post">
		<input type= "search-text" name="query" placeholder="Type to search"/>
		<input type="hidden" name="name_user" value="test"/>
		<a class="search-btn" href="#"> </a>
		<button id="myBtn" 
		onclick="location.href='browsing.jsp';">Submit</button> 

	</form>
	</div>

	
</body>

</html>
