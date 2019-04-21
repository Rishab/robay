<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<title>roBay: Change User Password</title>
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
		if (admin || staff) {
			// This assumes session is secured by the server and can't be fudged by an end user...
			
			Connection con = null;
			
			try {
			    String url = "jdbc:mysql://db-project.cvdxoiqfbf2x.us-east-2.rds.amazonaws.com:3306/RobayProjectSchema";
    			Class.forName("com.mysql.jdbc.Driver");

    			con = DriverManager.getConnection(url, "sqlgroup", "be_my_robae");
    			if (con != null) {
    				// System.out.println("Successfully connected to the database.");
    			} else {
    				System.out.println("Failed to connect to the database.");
    			}
			} catch (Exception e) {
				%>
					<script>
						alert("Something went wrong; please try again.");
						window.location.href = "staffcontrols.jsp";
					</script>
				<%
			}
    			
			%>
			    <div class="center-text margin-up color-navy">
			        <h2>
			            <em>roBay</em> Update a User's Password
			        </h2>
			    </div>
			    <div class="height-tiny"></div>
			
			    <div class="center width-most width-capped-decent card-box border-blue">
			        <form action="changePwUser.jsp" method = "post" class="">
			            <div class="margin-up-tiny margin-down-tiny margin-left-small">
			            	<div class="margin-down-tiny">
			            		<em>Affect User</em>
			            		<br>
			                    <select name="user_id_selector" id="user_id_selector">
			                    	<%
			                    		//TODO query DB for all Users' emails, IDs, and names
			                    		
			                    		ResultSet set = null;
										try {
											Statement stmt = con.createStatement();
											set = stmt.executeQuery("SELECT u_id, email_addr, name_user FROM Account WHERE acc_type = 'U';");
											
										} catch(Exception e) {
											%>
												<script>
													alert("Something went wrong; please try again.");
													window.location.href = "staffcontrols.jsp";
												</script>
											<%
										}
										
										if (set == null) {
											%>
												<script>
													alert("Something went wrong; please try again.");
													window.location.href = "staffcontrols.jsp";
												</script>
											<%
										}
			
										try {
											int num_cols = set.getMetaData().getColumnCount();
																
											while (set.next()) {
												String user_id = "??";
												String user_email = "EMAILUNKNOWN";
												String user_name = "NAMEUNKNOWN";
												
					                    		user_id = set.getString(1);
					                    		user_email = set.getString(2);
					                    		user_name = set.getString(3);
					                    		
					                    		%>
			                    					<option value="<%=user_id%>"><%=user_email%> (ID=<%=user_id%>): <%=user_name%></option>
			                    				<%
											}
										} catch(Exception e) {
											%>
												<script>
													alert("Something went wrong; please try again.");
													window.location.href = "staffcontrols.jsp";
												</script>
											<%
										}
			                    	%>
								</select> 
							</div>
							<br>	                    
			                <div class="margin-down-tiny">
			                    <em>New password</em>
			                    <br>
			                    <input type="password" name="password" class="width-most width-capped-avg">
			                </div>
			                <div class="margin-down-tiny">
			                    <em>Confirm new password</em>
			                    <br>
			                    <input type="password" name="password_confirm" class="width-most width-capped-avg">
			                </div>
			                <em>* Note: make sure you remember the change!</em>
			                <br>
			            </div>
			            <div class="center-flex margin-down-tiny">
			                <input type="submit" value="Submit" class="width-some width-capped-small pointer card-box-2 feedback">
			            </div>
			        </form>
			    </div>
			
			    <div class="height-tiny"></div>
			    <div class="center-text">
			        <a href="staffcontrols.jsp"><em>Return to Staff Controls</em></a>
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
