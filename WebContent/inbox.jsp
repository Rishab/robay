<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<title>roBay: Inbox</title>
<link rel="stylesheet" href="css/main.css">
</head>
<body>
	<%
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

    String retrieveEmails = ("SELECT e.subject, e.content, sender.email_addr as emailSender, reciever.email_addr  as emailReciever, e.date_time ");
    retrieveEmails += "FROM Email e join Account sender on(e.sender = sender.u_id) join Account reciever on(e.reciever= reciever.u_id) WHERE reciever.email_addr = '";
    retrieveEmails += user_email;
    retrieveEmails += "'";

    ResultSet emails = stmt.executeQuery(retrieveEmails);
    %>
  <div>
    <h2>
      <em>Mail</em>
    </h2>
  </div>
  <div>
  	<a href= "composeEmail.jsp" style="text-decoration:none; color:black;">
      <input type="submit" value="Create Email">
    </a>
  </div>
  <%
    while(emails.next()){
        String date_time = emails.getString("date_time");
        String subject  = emails.getString("subject");
        String senderEmail  = emails.getString("emailSender");
        String content  = emails.getString("content");

    %>
      <div class = "card-box">
        <h2><%= subject %></h2>
        <p>From: <%=senderEmail%></p>
        <%
    	if(date_time != null){
    	%>
        <p> <%=date_time %> </p>
         <%
    	}
    	%>
        <p><%=content%></p>
      </div>
    <%
      }
    return;
  } catch (Exception e) {
  %>
  <script>
    alert("Something went wrong. Please try again.");
    window.location.href = "index.jsp";
  </script>
  <%
  	System.out.println("Error: " + e);
    }
  %>
</body>
</html>
