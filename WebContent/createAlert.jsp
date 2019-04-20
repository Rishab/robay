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
<title>roBay: Create Email</title>
<link rel="stylesheet" href="css/main.css">
</head>
<body>
	<div class="center-text margin-up">
		<h2>
			<em>Email creation</em>
		</h2>
	</div>
	<%
		//Get parameters from the HTML form at the register.jsp
		String query = request.getParameter("query").replaceAll("\'","\\\\'");
		if(query == null || query == ""){
			%>
			<script>
				alert("You need to query for an alert.");
				window.location.href = "index.jsp";
			</script>
			<%
		}
		
		String user_email = (String) session.getAttribute("email_addr");
		if (user_email == null || user_email == "") {
			%>
			<script>
				alert("You need to login to create alerts.");
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

			if (query.equals("")) {
				System.out.println("You can't create an alert for an empty string.");
	%>
	<script>
		alert("Need a query to set an alert. Try again.");
		window.location.href = "browsing.jsp";
	</script>
	<%
		return;
			}
			//insert in table
			String insertStr = "INSERT INTO Alert (u_id, descr)"
					+ " VALUES (?, ?)";
			PreparedStatement ps = con.prepareStatement(insertStr);
			
			
			String findUserID = "SELECT u_id FROM Account WHERE email_addr = '";
			findUserID += user_email;
		    findUserID += "';";
			
		    ResultSet senderIDSet = stmt.executeQuery(findUserID);
		    
		    String u_id = "";
		    
		    if(senderIDSet.next()){
		    	u_id  = senderIDSet.getString("u_id");
		    } else{
		    %>
		    <script>
			   alert("Your email is not valid. Try again.");
			   window.location.href = "inbox.jsp";
			</script>
		    <%
		    }

			ps.setString(1, u_id);
			ps.setString(2, query);
			ps.executeUpdate();
			con.close();
	%>
	<script>
		alert("Alert created. Check your inbox for any updates.");
		window.location.href = "browsing.jsp";
	</script>
	<%
		} catch (Exception e) {
			System.out.println("Creation error");
	%>
	<script>
		alert("Something went wrong. Please try again.");
		window.location.href = "index.jsp";
	</script>
	<%
		return;
		}
	%>
</body>
</html>
