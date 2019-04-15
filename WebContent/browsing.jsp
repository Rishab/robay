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
    String name_user = (String) session.getAttribute("name_user");
    System.out.println(name_user);
    
		if (name_user == null || name_user == "") {
			%>
			<script>
				alert("You need to login to browse");
				window.location.href = "index.jsp";
			</script>
			<%
		}
    String query = "";
    if(request.getParameter("query") != null && request.getParameter("query")!= ""){
      query = request.getParameter("query");
    }
    String sortBy = "ASC";
    if(request.getParameter("sortBy") != null && request.getParameter("a_id")!= ""){
      sortBy = request.getParameter("sortBy");
    }
    int numResults = 1;
    if(request.getParameter("numResults")!= null && request.getParameter("a_id")!= ""){
      numResults = Integer.parseInt(request.getParameter("numResults"));
    }
		String robotType = "";
		if(request.getParameter("robotType")!= null && request.getParameter("robotType")!= ""){
      robotType = request.getParameter("robotType");
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

    String retrieveItems = ("SELECT a.listing_name, a.max_bid_amt, a.status, a.a_id, r.pic_url, r.r_type, CONCAT_WS('', a.listing_name, r.production_year, r.mobility_level, r.personality, r.purpose, r.expertise, r.specialty, r.r_type) as descr ");
		retrieveItems += "FROM Auction a join Robot r using(robot_id) WHERE a.status = 'open' ";
		if(robotType != null && robotType != ""){
			retrieveItems += "AND r.r_type = '";
			retrieveItems += robotType;
			retrieveItems += "' ";
		}
		retrieveItems += "GROUP BY a.a_id ";
		String[] searchParams = {};
		if(query != null && query != ""){
      searchParams = query.split(" ");
      retrieveItems += "HAVING (";
      for(String param : searchParams){
        retrieveItems+=" descr like \'%"+param+"%\' AND";
      }
      retrieveItems = retrieveItems.substring(0, retrieveItems.length()-3);
      retrieveItems += ")";
    }
    retrieveItems+= "ORDER BY max_bid_amt ";
    if(sortBy != null){
      retrieveItems += sortBy;
    }else{
      retrieveItems += "ASC";
    }

		String countItems = "SELECT count(*) FROM (";
		countItems+= retrieveItems;
		countItems+= ") as t1";
		ResultSet countOfItems = stmt.executeQuery(countItems);
		countOfItems.next();
		int numItems = countOfItems.getInt("count(*)");

		String typesAvailableQuery = "SELECT DISTINCT t1.r_type FROM (";
		typesAvailableQuery +=retrieveItems;
		typesAvailableQuery += ") as t1 GROUP BY t1.r_type ORDER BY t1.r_type ASC";
		ResultSet typesAvailableSet = stmt.executeQuery(typesAvailableQuery);

		ArrayList<String> typesAvailable = new ArrayList<String>();
		while(typesAvailableSet.next()){
			typesAvailable.add(typesAvailableSet.getString("r_type"));
		}


    ResultSet items = stmt.executeQuery(retrieveItems);

		%>
		<p><%= retrieveItems %></p>
  <div>
    <h2>
      <em>Robay Browsing</em>
    </h2>
  </div>

  <form action="browsing.jsp">
    <input type="text" name="query" value = <%= "\"" + query + "\"" %>>
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
		<%
		if(typesAvailable.size() > 0){
		%>
			<select name = "robotType">
			<%
				for(String type: typesAvailable){
			%>
				<option value= <%=type%> <%= (type == robotType)?"selected":""%>><%=type.substring(0, 1).toUpperCase() + type.substring(1)%></option>
			<%
			}
			%>
			</select>
		<%
		}
		%>
    <input type="submit" value="Submit">
  </form>
  </br>
		<%

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
    }if(numItems == 0){
    %>
			<p>No such items found. </p>
    <%
		}
      if(numResults < numItems){
				String moreItemsLink = "browsing.jsp?numResults=" + (numResults+10>numItems?numItems:numResults+10);
				moreItemsLink += "&sortBy=" + sortBy;
				if(query != null && query != ""){
					moreItemsLink+= "&query=";
					for(String param : searchParams){
						moreItemsLink += param;
						moreItemsLink += "+";
					}
					moreItemsLink = moreItemsLink.substring(0, moreItemsLink.length()-1);
				}
				if(robotType != null && robotType != ""){
					moreItemsLink+= "&robotType=";
					moreItemsLink+= robotType;
				}
    %>
    </br>
    <a href= <%=moreItemsLink%> style="text-decoration:none; color:black;">
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
    window.location.href = "index.jsp";
  </script>
  <%
    }
  %>
</body>
</html>
