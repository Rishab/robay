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
		String reciever = request.getParameter("reciever");
		String subject = request.getParameter("subject");
		String content = request.getParameter("content");
		
		String user_email = (String) session.getAttribute("email_addr");
		if (user_email == null || user_email == "") {
			%>
			<script>
				alert("You need to login to check mail.");
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

			if (reciever.equals("") || subject.equals("") || content.equals("")) {
				System.out.println("One of the parameters was missing. Enter all information!");
	%>
	<script>
		alert("All fields are necessary to create an email. Try again.");
		window.location.href = "inbox.jsp";
	</script>
	<%
		return;
			}
			//insert in table
			String insertStr = "INSERT INTO Email (sender, reciever, subject, content)"
					+ " VALUES (?, ?, ?, ?)";
			PreparedStatement ps = con.prepareStatement(insertStr);
			
			
			String findUserID = "SELECT u_id FROM Account WHERE email_addr = '";
			findUserID += user_email;
		    findUserID += "';";
			
		    ResultSet senderIDSet = stmt.executeQuery(findUserID);
		    
		    String sender_id = "";
		    
		    if(senderIDSet.next()){
		    	sender_id  = senderIDSet.getString("u_id");
		    } else{
		    %>
		    <script>
			   alert("Your email is not valid. Try again.");
			   window.location.href = "inbox.jsp";
			</script>
		    <%
		    }
		    
		    findUserID = "SELECT u_id FROM Account WHERE email_addr = '";
			findUserID += reciever;
		    findUserID += "';";
			
		    senderIDSet = stmt.executeQuery(findUserID);
		    
		    String reciever_id = "";
		    if(senderIDSet.next()){
		    	reciever_id  = senderIDSet.getString("u_id");
		    } else{
		    %>
		    <script>
			   alert("That recipient email is not valid. Try again.");
			   window.location.href = "inbox.jsp";
			</script>
		    <%
		    }

			ps.setString(1, sender_id);
			ps.setString(2, reciever_id);
			ps.setString(3, subject);
			ps.setString(4, content);

			ps.executeUpdate();
			con.close();
	%>
	<script>
		alert("Email sent.");
		window.location.href = "inbox.jsp";
	</script>
	<%
		} catch (Exception e) {
			System.out.println("Creation error");
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
