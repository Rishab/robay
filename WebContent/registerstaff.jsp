<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>roBay: Register Staff Account</title>
<link rel="stylesheet" href="css/main.css">
</head>
<body>
	<%
		String acc_type = (String) session.getAttribute("acc_type");
		if (acc_type.equals("A")) {
			// This assumes session is secured by the server and can't be fudged by an end user...
			%>
			    <div class="center-text margin-up color-brown">
			        <h2>
			            <em>roBay</em> New Staff Account
			        </h2>
			    </div>
			    <div class="height-tiny"></div>
			
			    <div class="center width-most width-capped-decent card-box debug">
			        <form action="createStaff.jsp" method =  "post" class="">
			            <div class="margin-up-tiny margin-down-tiny margin-left-small">
			                <div class="margin-down-tiny">
			                    <em>Staff Member's Name:</em>
			                    <br>
			                    <input type="text" name="name" class="width-most width-capped-avg">
			                </div>
			                <div class="margin-down-tiny">
			                    <em>Staff's email address</em>
			                    <br>
			                    <input type="email" name="email" class="width-most width-capped-avg">
			                </div>
			                <div class="margin-down-tiny">
			                    <em>Staff's password</em>
			                    <br>
			                    <input type="password" name="password" class="width-most width-capped-avg">
			                </div>
			                <div class="margin-down-tiny">
			                    <em>Confirm staff's password</em>
			                    <br>
			                    <input type="password" name="password_confirm" class="width-most width-capped-avg">
			                </div>
			                <em>* Note: Staff can change their password later</em>
			                <br>
			            </div>
			            <div class="center-flex margin-down-tiny">
			                <input type="submit" value="Register" class="width-some width-capped-small pointer card-box-2 feedback">
			            </div>
			        </form>
			    </div>
			
			    <div class="height-tiny"></div>
			    <div class="center-text">
			        <a href="admincontrols.jsp"><em>Return to Admin Controls</em></a>
			    </div>
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
