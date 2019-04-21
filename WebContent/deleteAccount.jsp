<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page
	import=" java.security.MessageDigest, java.security.NoSuchAlgorithmException"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>roBay: Delete Account</title>
</head>
<body>
	<%
		String currentUser = (String) session.getAttribute("name_user");
		if (currentUser == null || currentUser.equals("")) {
		%>
			<script>
				alert("You need to delete your account");
				window.location.href = "index.jsp";
			</script>
		<%
			}
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
			String currentUserEmail = (String) session.getAttribute("email_addr");
			String deleteAccountQuery = 
					"DELETE "
					+ "FROM Account "
					+ "WHERE email_addr='"
					+ currentUserEmail + "'";
			System.out.println(deleteAccountQuery);
			stmt.executeUpdate(deleteAccountQuery);
			%>
			<script>
				alert("Successfully deleted account. Redirecting you to the login page.");
				window.location.href = "index.jsp";
			</script>
			<%
		} catch (Exception e) {
			e.printStackTrace();
		}
	%>
	<hr>
    <footer class="center center-text width-most">
        <h4>
            <em>roBay</em>, an assignment for Rutgers University CS336, Spring 2019
        </h4>
        <h5>
            Group 18: Rishab Chawla, Amber Rawson, Jason Scot, Roshni Shah
        </h5>
    </footer>
</body>
</html>
   
	