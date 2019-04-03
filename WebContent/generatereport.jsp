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
	<%!	
		private boolean readBox(String response) {
			
			if (response == null) {
				return false;
			}
			
			return true;
		}
	%>
	<%
		String acc_type = (String) session.getAttribute("acc_type");
		if (acc_type.equals("A")) {
			// This assumes session is secured by the server and can't be fudged by an end user...
			
			boolean item, type, user, best_items, best_users;
			item = readBox(request.getParameter("item"));
			type = readBox(request.getParameter("type"));
			user = readBox(request.getParameter("user"));
			best_items = readBox(request.getParameter("best_items"));
			best_users = readBox(request.getParameter("best_users"));
            
            try {
            	
    			String url = "jdbc:mysql://db-project.cvdxoiqfbf2x.us-east-2.rds.amazonaws.com:3306/RobayProjectSchema";
    			Class.forName("com.mysql.jdbc.Driver");

    			Connection con = DriverManager.getConnection(url, "sqlgroup", "be_my_robae");
    			if (con != null) {
    				// System.out.println("Successfully connected to the database.");
    			} else {
    				System.out.println("Failed to connect to the database.");
    			}

    			Statement stmt = con.createStatement();
            	
    			String dateresult = "";
    			String datequery = "SELECT NOW()";
				ResultSet dateset = stmt.executeQuery(datequery);
				
				int num_cols = dateset.getMetaData().getColumnCount();
				
				while (dateset.next()) {
				    for (int i = 1; i <= num_cols; i++) {
				        dateresult = dateset.getString(i);
				    }
				}
				
				%>
				    <div class="center-text margin-up color-brown">
				        <h2>
				            <em>roBay</em> Sales Report<%=" for " + dateresult%>
				        </h2>
				    </div>
				    <div class="height-tiny"></div>
				
				    <div class="center width-most width-capped-decent card-box debug" style="padding: 10px 10px 10px 10px;">
				    	<h2>Total Earnings</h2>
				    	
						<%
							if (item || type || user) {
								%>
									<hr>
									<h2>Earnings by</h2>
									<br>
									
									<%
										if (item) {
											%>
											<h3><em>Item</em></h3>
											<br>
											
											<%											
										}
									
										if (type) {
											%>
											<h3><em>Type</em></h3>
											<br>
											
											<%											
										}
										
										if (user) {
											%>
											<h3><em>User</em></h3>
											<br>
											
											<%											
										}
									%>
								<%
							}
						%>
				    	
						<%
							if (best_items || best_users) {
								%>
									<hr>
									<h2>Best Sellers</h2>
									<br>
									
									<%
										if (best_items) {
											%>
											<h3><em>Top Items</em></h3>
											<br>
											
											<%											
										}
									
										if (best_users) {
											%>
											<h3><em>Top Users</em></h3>
											<br>
											
											<%											
										}
									%>
								<%
							}
						%>
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
			
            } catch (Exception e) {
            	e.printStackTrace();
            }
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
