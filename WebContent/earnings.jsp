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
			        <form action="generatereport.jsp" method =  "post" class="">
			            <div class="margin-up-tiny margin-down-tiny margin-left-small">
			                <div class="margin-down-tiny">
			                	<br>
			                	<h3>Toggle these settings to affect what appears on the report</h3>
			                	<br>
			                    <em>Include Sections Grouped By:</em>
			                    <br>
			                    <!--
			                    <select>
									<option value="all">All</option>
									<option value="personal">Personal</option>
									<option value="medical">Medical</option>
									<option value="military">Military</option>
								</select>
								-->
								<input type="checkbox" checked class="pointer" name="item" value="item" id="item"><label for="item" class="pointer"> Item</label>
				                <br>
				                <input type="checkbox" checked class="pointer" name="type" value="type" id="type"><label for="type" class="pointer"> Robot Type</label>
				                <br>
				                <input type="checkbox" checked class="pointer" name="user" value="user" id="user"><label for="user" class="pointer"> Selling User</label>
				                <br>
								<br>
								
								<script>
				                	function checkCheckboxes() {
				                		if (!document.getElementById('best_items').checked && !document.getElementById('best_users').checked) {
				                			document.getElementById('num_tops').disabled = true;
				                		} else {
				                			document.getElementById('num_tops').disabled = false;
				                		}
				                    }
				                </script>
				                
				                <em>List Best Sellers:</em>
				                <br>
				                <div onclick="checkCheckboxes()">
					                <input type="checkbox" checked class="pointer" name="best_items" value="best_items" id="best_items"><label for="best_items" class="pointer"> Top Items</label>
					                <br>
					                <input type="checkbox" checked class="pointer" name="best_users" value="best_users" id="best_users"><label for="best_users" class="pointer"> Top Users</label>
				                </div>
				                <br><br>
				                Show top <input type="number" class="pointer" name="num_tops" id="num_tops" min="1" max="1000" value="5">
				                <br>
				                <small>* <em>Only used when "Top Items" or "Top Users" is checked</em></small>
				                <br>
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
