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
    <div class="center-text margin-up">
    </div>
    <div class="height-tiny"></div>
    <%
    String name_user = (String) session.getAttribute("name_user");
    System.out.println(name_user);
    
		if (name_user == null || name_user == "") {
			%>
			<script>
				alert("You need to login to ask a question.");
				window.location.href = "index.jsp";
			</script>
			<%
		}
    String a_id = request.getParameter("a_id");
	System.out.println(a_id);
	if (a_id == null || a_id == "") {
		%>
		<script>
			alert("Must ask a question on a real item.");
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
		
		String question = request.getParameter("question");
		String viewerUserID = request.getParameter("v_u_id");
		System.out.println("Question asked: " + question);
		
		String postQuestionQuery =
				"INSERT INTO Question (question, a_id, q_u_id) "
				+ "VALUES('" 
				+ question + "', "
				+ a_id + ", "
				+ viewerUserID + ")";
		
		System.out.println(postQuestionQuery);
		stmt.executeUpdate(postQuestionQuery);
		%>
		<script>
			alert("Successfully asked your question. Redirecting you back to the auction.");
			window.location.href = "auctionItem.jsp?a_id=" + <%=a_id%>;
		</script>
		<%
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>
</body>

</html>