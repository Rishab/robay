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
<title>roBay: Login</title>
</head>
<body>
	<%
		String email = request.getParameter("email").replaceAll("\'","\\\\'");
		String password = request.getParameter("password").replaceAll("\'","\\\\'");

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

			if (email.equals("") || password.equals("")) {
				System.out.println("One of the parameters was missing. Enter all information!");
	%>
	<script>
		alert("All fields are necessary to login to an account.");
		window.location.href = "login.jsp";
	</script>
	<%
		return;
			}
			String validateEmailQuery = "SELECT * FROM Account a WHERE a.email_addr='" + email + "'";
			ResultSet emailResults = stmt.executeQuery(validateEmailQuery);

			if (!emailResults.next()) {
				System.out.println("There is no account associated with this email address.");
	%>
	<script>
		alert("You must enter a registered email account to proceed");
		window.location.href = "login.jsp";
	</script>
	<%
		return;
			}
			String resultEmail = emailResults.getString("email_addr");
			String resultPass = emailResults.getString("pass_hash");

			MessageDigest sha1 = MessageDigest.getInstance("SHA1");
			byte[] result = sha1.digest(password.getBytes());
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < result.length; i++) {
				sb.append(Integer.toString((result[i] & 0xff) + 0x100, 16).substring(1));
			}
			String passwordHash = sb.toString();
			System.out.println(passwordHash);

			if (!resultPass.equals(passwordHash)) {
				System.out.println("The password provided is incorrect.");
	%>
	<script>
		alert("The password entered is incorrect. Please provide the correct password!");
		window.location.href = "login.jsp";
	</script>
	<%
	
		return;
			}
			session.setAttribute("name_user", emailResults.getString("name_user"));
			session.setAttribute("email_addr", emailResults.getString("email_addr"));
			session.setAttribute("u_id", emailResults.getString("u_id"));
			session.setAttribute("acc_type", emailResults.getString("acc_type"));
			con.close();
	%>
	<script>
		alert("Login successful.");
		window.location.href = "landingPage.jsp";
	</script>
	<%
		} catch (Exception e) {
			e.printStackTrace();
	%>
	<script>
		alert("Something went wrong. Please try again.");
		window.location.href = "register.jsp";
	</script>
	<%
		return;
		}
	%>
</body>
</html>