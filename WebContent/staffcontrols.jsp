<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>roBay: Staff Controls</title>
<link rel="stylesheet" href="css/main.css">
</head>
<body>
	<%
		String acc_type = (String) session.getAttribute("acc_type");
		if (acc_type.equals("A") || acc_type.equals("S")) {
			// This assumes session is secured by the server and can't be fudged by an end user...
			%>
			    <div class="center-text margin-up color-navy">
			        <h2>
			            <em>roBay</em> Staff Control Panel
			        </h2>
			    </div>
			    <div class="height-tiny"></div>
			
			    <div class="center-flex">
			        <button onclick="location.href='changepw_user.jsp';" class="width-some feedback-blue card-box-2">
			            <h3 class="capitalize">Change a User's Password</h3>
			        </button>
			        <div class="width-tiny"></div>
			        <button onclick="location.href='changepw_self.jsp';" class="width-some feedback-blue card-box-2">
			            <h3 class="capitalize">Change Your Own Password</h3>
			        </button>
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
