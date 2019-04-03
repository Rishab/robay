<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>roBay: Earnings Page</title>
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
			            <em>roBay</em> Generate Sales Report
			        </h2>
			    </div>
			    <div class="height-tiny"></div>
			
			    <div class="center width-most width-capped-decent card-box debug">
			        <form action="error.jsp" method =  "post" class="">
			            <div class="margin-up-tiny margin-down-tiny margin-left-small">
			                <div class="margin-down-tiny">
			                	<br>
			                	<h3>Toggle these settings to affect what appears on the report</h3>
			                	<br>
			                	<input type="checkbox" checked class="items" name="items" value="items" id="items"><label for="items" class="pointer"> Include Reports for Specific Items</label>
			                	<br>
			                	<br>
			                    <em>Count Sales of Robot Type:</em>
			                    <br>
			                    <!--
			                    <select>
									<option value="all">All</option>
									<option value="personal">Personal</option>
									<option value="medical">Medical</option>
									<option value="military">Military</option>
								</select>
								-->
								<input type="checkbox" checked class="pointer" name="personal" value="personal" id="personal"><label for="personal" class="pointer"> Personal</label>
				                <br>
				                <input type="checkbox" checked class="pointer" name="medical" value="medical" id="medical"><label for="medical" class="pointer"> Medical</label>
				                <br>
				                <input type="checkbox" checked class="pointer" name="military" value="military" id="military"><label for="military" class="pointer"> Military</label>
				                <br>
								<br>
				                
				                <em>List Best Sellers:</em>
				                <br>
				                <input type="checkbox" checked class="pointer" name="best_items" value="best_items" id="best_items"><label for="best_items" class="pointer"> Top Items</label>
				                <br>
				                <input type="checkbox" checked class="pointer" name="best_users" value="best_users" id="best_users"><label for="best_users" class="pointer"> Top Users</label>
			                </div>

			                <br>
			            </div>
			            <div class="center-flex margin-down-tiny">
			                <input type="submit" value="Generate Report" class="width-some width-capped-small pointer card-box-2 feedback">
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
