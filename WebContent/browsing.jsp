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
		//Get parameters from the search bar on landing.jsp
		//String searchParams = request.getParameter("query");
    String sortBy = "ASC";
    if(request.getParameter("sortBy") != null && request.getParameter("a_id")!= ""){
      sortBy = request.getParameter("sortBy");
    }
    int numResults = 1;
    if(request.getParameter("numResults")!= null && request.getParameter("a_id")!= ""){
      numResults = Integer.parseInt(request.getParameter("numResults"));
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
      String countItems = "SELECT count(*) FROM Auction WHERE status='open'";
      ResultSet countOfItems = stmt.executeQuery(countItems);
      countOfItems.next();
      int numItems = countOfItems.getInt("count(*)");
	%>

  <div>
    <h2>
      <em>Robay Browsing</em>
    </h2>
  </div>

  <form action="browsing.jsp">
    <select name="sortBy">
  <%
    if(sortBy == null || sortBy.equals("ASC")){
  %>
      <option selected = "selected" value="ASC">Price: Ascending</option>
      <option value="DESC">Price: Descending</option>
  <%
    }else{
  %>
      <option value="ASC">Price: Ascending</option>
      <option selected = "selected" value="DESC">Price: Descending</option>
  <%
    }
  %>
    </select>
    <select name="numResults">
    <%
      int[] displayOpts = {1, 5, 10, 20, 50, 100, 200};
      for(int displayVal : displayOpts){
        %>
          <option value= <%=displayVal %> <%= (displayVal == numResults)?"selected":""%>> Show <%=displayVal %> items.</option>
        <%
        if(displayVal > numItems){
          break;
        }
      }
    %>
    </select>
    <input type="submit" value="Submit">
  </form>
  </br>
  <%
    String retrieveItems = ("SELECT a.listing_name, a.max_bid_amt, a.status, a.a_id, r.pic_url FROM "
    + "Auction a join Robot r using(robot_id) WHERE a.status = 'open' ORDER BY max_bid_amt");
    if(sortBy != null){
      retrieveItems += (" " + sortBy);
    }else{
      retrieveItems += (" ASC");
    }
    ResultSet items = stmt.executeQuery(retrieveItems);


    for(int i = 0; i < numResults; i++){
      if(!items.next()){
        break;
      }else{
        String listingName  = items.getString("listing_name");
        float maxBidAmt = items.getFloat("max_bid_amt");
        String status = items.getString("status");
        String picURL = items.getString("pic_url");
        int a_id = items.getInt("a_id");
    %>
      <a href= <%="auctionItem.jsp?a_id="+ a_id %> style="text-decoration:none; color:black;">
      <div class = "card-box">
        <h2><%= listingName %></h2>
        <img src= <%=picURL%> alt="Robot image missing." style="max-width:200px; max-height:200px;">
        <p>Max Bid Amount: <%= "$" + String.format("%.2f", maxBidAmt) %></p>
      </div>
      </br>
      </a>
    <%
      }
    }
    %>
    <%
      if(numResults < numItems){
    %>
    </br>
    <a href= <%=("browsing.jsp?numResults=" +(numResults+10>numItems?numItems:numResults+10) +"&sortBy=" + sortBy)%> style="text-decoration:none; color:black;">
      <input type="submit" value="Show More Items &raquo;">
    </a>
    <%
      }
    %>
  <%
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
