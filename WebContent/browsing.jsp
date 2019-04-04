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
	<div>
		<h2>
			<em>Robay Browsing</em>
		</h2>
	</div>
	<%
		//Get parameters from the search bar on landing.jsp
		//String searchParams = request.getParameter("query");
    String sortBy = null;
    sortBy = request.getParameter("sortBy");
		try {

			String url = "jdbc:mysql://db-project.cvdxoiqfbf2x.us-east-2.rds.amazonaws.com:3306/RobayProjectSchema";
			Class.forName("com.mysql.jdbc.Driver");

			Connection con = DriverManager.getConnection(url, "sqlgroup", "be_my_robae");
			if (con != null) {
				System.out.println("Successfully connected to the database.");
			} else {
				System.out.println("Failed to connect to the database.");
			}
	%>
  <form action="browsing.jsp">
    <select name="sortBy">
      <option value="ASC">Price: Ascending</option>
      <option value="DESC">Price: Descending</option>
    </select>
    <input type="submit" value="Submit">
  </form>

  </select>
  </br>
  <%
    Statement stmt = con.createStatement();
    String retrieveItems = "SELECT * FROM Auction ORDER BY max_bid_amt";
    if(sortBy != null){
      retrieveItems += (" " + sortBy);
    }else{
      retrieveItems += (" ASC");
    }
    ResultSet items = stmt.executeQuery(retrieveItems);
    int numResults = 10;
    for(int i = 0; i < numResults; i++){
      if(!items.next()){
        break;
      }else{
        String listingName  = items.getString("listing_name");
        float maxBidAmt = items.getFloat("max_bid_amt");
        String status = items.getString("status");
    %>
      <div class = "card-box">
        <h2><%= listingName %></h2>
        <p>Max Bid Amount: <%= maxBidAmt %> Status: <%= status.toUpperCase() %></p>
      </div>
    <%
      }
    }
    return;
  } catch (Exception e) {
  %>
  <script>
    alert("Something went wrong. Please try again.");
    window.location.href = "register.jsp";
  </script>
  <%
    }
  %>
</body>
</html>
