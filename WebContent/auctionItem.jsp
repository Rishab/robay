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
<title>roBay: Browsing</title>
<link rel="stylesheet" href="css/main.css">
</head>
<body>
	<%
    int a_id = -1;
    if(request.getParameter("a_id")!= null && request.getParameter("a_id")!= ""){
      a_id = Integer.parseInt(request.getParameter("a_id"));
    }
  %>
  <div>
  	<h2>
  		<em>Auction Listing: a_id: <%=a_id%></em>
  	</h2>
  </div>
</body>
</html>
