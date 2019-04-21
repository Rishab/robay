<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>roBay: Make Bid</title>
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
    String name_user = (String) session.getAttribute("name_user");
    System.out.println(name_user);
    
		if (name_user == null || name_user == "") {
			%>
			<script>
				alert("You need to login to answer a question.");
				window.location.href = "index.jsp";
			</script>
			<%
		}
    String a_id = request.getParameter("a_id");
	System.out.println(a_id);
	if (a_id == null || a_id == "") {
		%>
		<script>
			alert("Must answer a question on a real item.");
			window.location.href = "browsing.jsp";
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
		
		String answer = request.getParameter("answer").replaceAll("\'","\\\\'");
		String viewerUserID = request.getParameter("v_u_id");
		String q_id = request.getParameter("q_id");
		System.out.println("Answer given: " + answer);
		
		String postQuestionQuery =
				"INSERT INTO Answer (answer, a_u_id, q_id) "
				+ "VALUES('" 
				+ answer + "', "
				+ viewerUserID + ", "
				+ q_id + ")";
		
		System.out.println(postQuestionQuery);
		stmt.executeUpdate(postQuestionQuery);
		%>
		<script>
			alert("Successfully answered the question. Redirecting you back to the auction.");
			window.location.href = "auctionItem.jsp?a_id=" + <%=a_id%>;
		</script>
		<%
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>
</body>

</html>
