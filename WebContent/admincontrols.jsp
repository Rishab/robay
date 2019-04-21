<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>roBay: Admin Controls</title>
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
	<%
		if (admin) {
			// This assumes session is secured by the server and can't be fudged by an end user...
			%>
			    <div class="center-text margin-up color-brown">
			        <h2>
			            <em>roBay</em> Administrator Control Panel
			        </h2>
			    </div>
			    <div class="height-tiny"></div>
			
			    <div class="center-flex">
			        <button onclick="location.href='registerstaff.jsp';" class="width-some feedback-red card-box-2">
			            <h3 class="capitalize">Register Staff</h3>
			        </button>
			        <div class="width-tiny"></div>
			        <button onclick="location.href='earnings.jsp';" class="width-some feedback-red card-box-2">
			            <h3 class="capitalize">Earnings Page</h3>
			        </button>
			    </div>
			    <br>
			    <div class="center-flex">
			    	<div class="width-tiny"></div>
			        <button onclick="location.href='staffcontrols.jsp';" class="width-some feedback-blue card-box-2">
			            <h3 class="capitalize">Staff Control Panel</h3>
			        </button>
			        <div class="width-tiny"></div>
			    </div>
			    <div class="center-text margin-up-tiny"><a href="landingPage.jsp"><em>Back to roBay</em></a></div>
			
			    <div class="height-some"></div>
			    <hr>
			    <footer class="center center-text width-most">
			        <h4>
			            <em>roBay</em>, an assignment for Rutgers University CS336, Spring 2019
			        </h4>
			        <h5>
			            Group 18: Rishab Chawla, Amber Rawson, Jason Scot, Roshni Shah
			        </h5>
			    </footer>
			<%
		} else {
			%>
				<script>
					alert("You don't have permission to view this page. Redirecting to login...");
					window.location.href = "index.jsp";
				</script>			
			<%
		}
	%>
</body>

</html>
