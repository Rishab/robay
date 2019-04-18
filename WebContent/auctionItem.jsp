<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*, java.text.*,java.sql.*"%>
<%@ page
	import=" java.security.MessageDigest, java.security.NoSuchAlgorithmException"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<title>roBay: Item Auction Page</title>
<link rel="stylesheet" href="css/main.css">
</head>
<body>
	<%
	
	//Check to see that the user is logged in. If the user is not logged in, make them login before they can view the profile.
	String currentUser = (String) session.getAttribute("name_user");
	if (currentUser == null || currentUser.equals("")) {
		%>
		<script>
			alert("You need to login to view the details of this auction");
			window.location.href("index.jsp");
		</script>
	<% 
	}
    int a_id = -1;
    if(request.getParameter("a_id")!= null && request.getParameter("a_id")!= ""){
      a_id = Integer.parseInt(request.getParameter("a_id"));
    }
    
    try {
    	//Try to connect to the database Schema
    	String url="jdbc:mysql://db-project.cvdxoiqfbf2x.us-east-2.rds.amazonaws.com:3306/RobayProjectSchema";
    	Class.forName("com.mysql.jdbc.Driver");
    	
		Connection con = DriverManager.getConnection(url, "sqlgroup", "be_my_robae");
    	if (con != null) {
    		System.out.println("Item Auction Page: Successfully connected to the database");
    	} else {
    		System.out.println("Item Auction PAge: Failed to connect to the database");
    	}
    	
    	//used to create SQL statements to query the database
    	Statement stmt = con.createStatement();
    	
    	String currentUserEmailAddr = (String) session.getAttribute("email_addr");
		String getCurrentUserIDQuery = 
				"SELECT a.u_id, a.acc_type "
				+ "FROM Account as a "
				+ "WHERE a.email_addr='"
				+ currentUserEmailAddr + "'";
		System.out.println(getCurrentUserIDQuery);
		
		//Get the userID of the current user
		ResultSet emailResults = stmt.executeQuery(getCurrentUserIDQuery);
		
		int viewerUserID = -1;
		String viewerAccountType = "";
		if (emailResults.next()) {
			viewerUserID = emailResults.getInt("u_id");
			viewerAccountType = emailResults.getString("acc_type");
		} else {
			System.out.println("The user does not exist in the database");
			return;
		}
		
		String getAuctionInformation = 
				"SELECT r.pic_url, a.listing_name, a.u_id "
				+ "FROM Auction as a "
				+ "JOIN Robot as r using (robot_id) "
				+ "WHERE a.a_id="
				+ a_id;
		
		ResultSet auctionInfo = stmt.executeQuery(getAuctionInformation);
		auctionInfo.next();
		
  %>
  
  <div>
  	<h2>
  		<em>Auction Listing: <%=auctionInfo.getString("listing_name") %></em>
  	</h2>
  </div>
  <img src=<%=auctionInfo.getString("pic_url")%> alt="Robot image missing." class="center" style="max-width:200px; max-height:200px;">
  <h3>
  	<em>Item Bid History</em>
  </h3>
  <% 
  	if (viewerUserID != auctionInfo.getInt("u_id")) {
  		%>
  		<h3>
  			<em>Set a Bid</em>
  		</h3>
  		<form action="addBid.jsp?a_id=<%=a_id%>">
  	  		Enter an amount:<br>
  	  		<input type="text" name="firstname">
  	  		<br>
  	  		<input type="submit" value="Submit">
  	  	</form>
  		<%

  	}
  %>
  	<% 
  		//Prepare a SQL query to retrieve all the bids and names of users where the auction id is equal to a_id
  		String currentBidHistory = 
  			"FROM Bid as b "
  			+ "JOIN Account as a using (u_id) "
			+ "WHERE b.a_id="
			+ a_id + " "
			+ "ORDER BY b.b_date_time DESC";
  		String countBidHistory =
  				"SELECT count(*) "
  				+ currentBidHistory;
  		String selectBidColumns = 
  	  			"SELECT b.amount, a.name_user, a.email_addr, b.b_date_time, a.u_id, b.b_id "
  				+ currentBidHistory;
  		ResultSet bidResults = stmt.executeQuery(countBidHistory);
  		bidResults.next();
  		int numberOfBids = bidResults.getInt("count(*)");

  		//if the number of bids placed on the item is greater than 0, display a table with bids for that item
  		if (numberOfBids > 0) {
  			%>
  			<table width="100%" border="0" cellspace="0" cellpadding="0">
  				<th>Name</th>
  				<th>Time of Bid</th>
  				<th>Amount</th>	
  				<%
  				if (viewerAccountType.equals("A") || viewerAccountType.equals("S")) {
  					%>
  					<th>Delete Bid</th>	
 					<%
  				}
  					%>
  			<%
  			bidResults = stmt.executeQuery(selectBidColumns);
  			
  			for (int i = 0; i < numberOfBids && bidResults.next(); i++) {
  			%>
  				<tr>
  					<td style="text-align: center; vertical-align: middle">
  					<%   					
  						String profileUser = bidResults.getString("name_user");
  						int otherUserID = bidResults.getInt("u_id");
  					%>
  					
   							<a href=<%="profile.jsp?profileUserID=" + otherUserID + "&name_user=" + profileUser.replaceAll(" ", "_") %>>
   								<%=profileUser %>
   							</a>  							
  							
  						
  					</td>
  					<td style="text-align: center; vertical-align: middle">
  						<%
  						Timestamp timestamp = bidResults.getTimestamp("b_date_time");
  						if (timestamp == null) {
	  						%>
	  						No Real Date
	  						<% 
  						} else {
  							DateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd hh:mm:ss");
  							java.util.Date date = new java.util.Date(timestamp.getTime());
  							String strDate = dateFormat.format(date);
  							%>
  							<%=strDate %>
  						<%
  						}
  						%>
  					</td>
  					<td style="text-align: center; vertical-align: middle">
  						 <%=bidResults.getString("amount") %>
  					</td>
  					<%
  				if (viewerAccountType.equals("A") || viewerAccountType.equals("S")) {
  					%>
  					<td style="text-align: center; vertical-align: middle">
  						<button name="deleteButton" type="button" class="width-some feedback card-box-2" value="<%=viewerUserID%>" onclick=<%= "location.href='deleteBid.jsp?b_id=" + bidResults.getInt("b_id") + "&a_id=" + a_id + "';" %>>Delete</button>
  					</td>
  					
  					
 					<%
  				}
  					%>
  				</tr>
  			<%
  			}
  			%>
  			</table>
  			<script>
			function deleteBid() {				
				console.log("AHHHHH");
  				console.log(document.deleteButton.value);
			}
  			</script>
  			<%
  		} else {
  			%>
  			<p>This item has no bids.</p>
  			<%
  		}
    } catch (Exception e) {
    	e.printStackTrace();
    	return;
    }
			
  	%>
	
		<!--  display auction items from last month -->
		<%
		try {

			String url = "jdbc:mysql://db-project.cvdxoiqfbf2x.us-east-2.rds.amazonaws.com:3306/RobayProjectSchema";
			Class.forName("com.mysql.jdbc.Driver");

			Connection con = DriverManager.getConnection(url, "sqlgroup", "be_my_robae");
			if (con != null) {
			%>
			<p>
				CONNECTED!
			</p>
		<%
				System.out.println("Successfully connected to the database.");
			} else {
			%>
			<p>
				DISCONNECTED
			</p>
			<%
				System.out.println("Failed to connect to the database.");
			}
      Statement stmt = con.createStatement();
			
		String retrieveItems = ("SELECT a.listing_name, a.max_bid_amt, a.status, a.a_id, r.pic_url, r.r_type, r.description, a.end_time, CONCAT_WS('', a.listing_name, r.production_year, r.mobility_level, r.personality, r.purpose, r.expertise, r.specialty, r.r_type, r.description) as descr ");
		retrieveItems += "FROM Auction a join Robot r using(robot_id) WHERE a.status = 'open' AND a.start_time BETWEEN CURDATE() - INTERVAL 30 DAY AND CURDATE()";
		//retrieveItems += "GROUP BY a.a_id ";
		ResultSet items = stmt.executeQuery(retrieveItems);
		String countItems = "SELECT count(*) FROM (";
		countItems+= retrieveItems;
		countItems+= ") as t1";
		ResultSet countOfItems = stmt.executeQuery(countItems);
		countOfItems.next();
		int numItems = countOfItems.getInt("count(*)");
		%>
		<p>HERE! <%= retrieveItems%></p>
		<p><%= retrieveItems %></p> 
		<p>FOUND <%= numItems %> ITEMS</p>
		

		<%
		if(numItems == 0){
			%>
				<p>No such items found. </p>
			<%
		}else{
			int numResults= 1;
			for(int j = 0; j < numResults; j++){
				if(!items.next()){
					break;
				}else{
					String listingName  = items.getString("listing_name");
					//float maxBidAmt = items.getFloat("max_bid_amt");
					//String status = items.getString("status");
					//String picURL = items.getString("pic_url");
					int auction_id = items.getInt("a_id");
					if(listingName !=null){
					%>

				<p><%= listingName %></p>
					</br>
			<%
					}else{
						<p>"TEST"></p>
					</br>
					}
			%>
			<%
					} // inner else
 				} // outer for
			%>
			<%
			return;
			} // outer else
	 	} catch (Exception e) {
			//System.out.println(e.printStackTrace());
		%>
		<p>
			EXCEPTION!
		</p>
		<%
		}	//end catch	
		%>
</body>
</html>
