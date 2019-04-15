<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page
	import=" java.security.MessageDigest, java.security.NoSuchAlgorithmException"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<title>roBay: Change User's Password</title>
<link rel="stylesheet" href="css/main.css">
</head>
<body>
	<%
		String acc_type = (String) session.getAttribute("acc_type");
		
		if (acc_type.equals("A") || acc_type.equals("S")) {
			// This assumes session is secured by the server and can't be fudged by an end user...
			
			%>
			
				<div class="center-text margin-up">
					<h2>
						<em>User Password Change</em>
					</h2>
				</div>
				<%
					//Get parameters from the HTML form at the register.jsp
					String newPass = request.getParameter("password");
					String newPassConfirm = request.getParameter("password_confirm");
					String user_id = request.getParameter("user_id_selector");
			
					try {
			
						String url = "jdbc:mysql://db-project.cvdxoiqfbf2x.us-east-2.rds.amazonaws.com:3306/RobayProjectSchema";
						Class.forName("com.mysql.jdbc.Driver");
			
						Connection con = DriverManager.getConnection(url, "sqlgroup", "be_my_robae");
						if (con != null) {
							System.out.println("Successfully connected to the database.");
						} else {
							System.out.println("Failed to connect to the database.");
						}
							
						Statement stmt = con.createStatement();
						
						ResultSet set = null;
						
						set = stmt.executeQuery("SELECT acc_type FROM Account WHERE u_id = " + user_id + ";");
						
						if (!set.next()) {
							%>
								<script>
									alert("The selected user could not be found. Please try again.");
									window.location.href = "changepw_user.jsp";
								</script>
							<%
							return;
						}
						
						if (!set.getString(1).equals("U")) {
							%>
								<script>
									alert("The selected user is a Staff or Admin, whose password only they can change.");
									window.location.href = "changepw_user.jsp";
								</script>
							<%
							return;
						}
			
						if (newPass.equals("") || newPassConfirm.equals("")) {
							System.out.println("Please enter a new password two times to update your password.");
				%>
				<script>
					alert("Please enter a new password two times to update your password.");
					window.location.href = "changepw_user.jsp";
				</script>
				<%
					return;
						}
			
						if (!newPass.equals(newPassConfirm)) {
							System.out.println("The passwords do not match. Please try again.");
				%>
				<script>
					alert("The passwords do not match. Please try again.");
					window.location.href = "changepw_user.jsp";
				</script>
				<%
					return;
						}
			
						if (newPass.length() < 8) {
							System.out.println("Password must be longer than 7 characters.");
				%>
				<script>
					alert("Password must be at least 8 characters.");
					window.location.href = "changepw_user.jsp";
				</script>
				<%
					return;
						} else if (newPass.length() > 45) {
							System.out.println("Password is too long.");
				%>
				<script>
					alert("Password must be shorter than 45 characters.");
					window.location.href = "changepw_user.jsp";
				</script>
				<%
					return;
						}
						// update password in table
						String updateStr = "UPDATE Account SET pass_hash = ? WHERE u_id = ?;";
						
						PreparedStatement ps = con.prepareStatement(updateStr);
			
						MessageDigest mDigest = MessageDigest.getInstance("SHA1");
						byte[] result = mDigest.digest(newPass.getBytes());
						StringBuffer sb = new StringBuffer();
						for (int i = 0; i < result.length; i++) {
							sb.append(Integer.toString((result[i] & 0xff) + 0x100, 16).substring(1));
						}
						String newPassHash = sb.toString();
			
						ps.setString(1, newPassHash);
						ps.setString(2, user_id);
			
						ps.executeUpdate();
			
						con.close();
				%>
				<script>
					alert("Password Updated");
					window.location.href = "staffcontrols.jsp";
				</script>
				<%
					} catch (Exception e) {
						System.out.println("Update error");
				%>
				<script>
					alert("Something went wrong. Please try again.");
					window.location.href = "changepw_user.jsp";
				</script>
				<%
					return;
					}
				%>
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
