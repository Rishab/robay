<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*, java.text.*,java.sql.*"%>
<%@ page
	import=" java.security.MessageDigest, java.security.NoSuchAlgorithmException"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
	<% 
		
		//Check to see that the user is logged in. If the user is not logged in, make them 
		//login before they can view profile 
		String currentUser = (String) session.getAttribute("name_user");
		String profileUser = (String) request.getParameter("name_user").replaceAll("\'","\\\\'");
		System.out.println(currentUser);
		System.out.println(profileUser);
		if (currentUser == null || currentUser.equals("")) {
	%>
		<script>
			alert("You need to login to view this user's profile");
			window.location.href = "index.jsp";
		</script>
	<%
		} 
	%>

<title>roBay: Profile
</title>
<link rel="stylesheet" href="css/main.css">
<style>
</style>
</head>
<body>
	<%
		try {
			//Try to connect to the database schema
			String url = "jdbc:mysql://db-project.cvdxoiqfbf2x.us-east-2.rds.amazonaws.com:3306/RobayProjectSchema?zeroDateTimeBehavior=convertToNull";
			Class.forName("com.mysql.jdbc.Driver");
			
			Connection con = DriverManager.getConnection(url, "sqlgroup", "be_my_robae");
			if (con != null) {
				System.out.println("Profile: Successfully connected to the database.");
			} else {
				System.out.println("Profile: Failed to connect to the database.");
			}
			
			//used to create SQL statements to query the database
			Statement stmt = con.createStatement();
					
			// Retrieve the email address of the current user to get the currentUser's ID
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
				System.out.println(viewerUserID);
				System.out.println(viewerAccountType);
			} else {
				System.out.println("The user does not exist in the database");
				return;
			}
			
			int profileUserID;
			System.out.println("Check");
			if (profileUser == null) {
				System.out.println(" Checking");
				profileUserID = viewerUserID;
				profileUser = currentUser;
			} else {
				String profileUserIDStr = (String) request.getParameter("profileUserID");
				profileUserID = Integer.parseInt(profileUserIDStr);
				System.out.println("profileUserID: " + profileUserID);
			}
			
			
	%>
	<h2>
		<%
			System.out.println("checking");
			if (viewerUserID == profileUserID || viewerAccountType.equals("A") || viewerAccountType.equals("S")) {
				System.out.println("Still checking");
		%>
				<em>My Profile</em>
				<div class="height-tiny"></div>
				<div class="center-flex">
        			<button onclick="location.href='newAuction.jsp';" class="width-some feedback card-box-2">
            			<h3 class="capitalize">Create Auction</h3>
       				</button>
       				<div class="width-tiny"></div>
        			<button onclick="location.href='inbox.jsp';" class="width-some feedback card-box-2">
           				<h3 class="capitalize">Check Email</h3>
        			</button>
   					<div class="width-tiny"></div>
   					<button onclick="location.href='deleteAccount.jsp';" class="width-some feedback card-box-2">
           				<h3 class="capitalize">Delete Account</h3>
        			</button>
   				</div>
   				<div class="height-tiny"></div>
   		<%
			}
			profileUser = profileUser.replaceAll("_", " ");
		%>
		<em><%=profileUser%>'s Profile</em>
	</h2>
	<h3>
		<em>Currently Selling</em>
	</h3>
		<%
		//Prepare a SQL query to retrieve all the bids that the user ID of the associated profile have participated in
		String currentListings = 
			"FROM Auction as a "
			+ "JOIN Robot  as r using (robot_id) "
			+ "WHERE a.status='open' AND a.u_id=" 
			+ profileUserID + " "
			+ "ORDER BY a.start_time DESC";
		String selectListingsColumns = 
			"SELECT a.listing_name, a.max_bid_amt, a.start_time, a.end_time, r.pic_url, r.r_type "
			+ currentListings;
		String countListingsEntries = 
			"SELECT count(*) "
			+ currentListings;
		System.out.println(countListingsEntries);
		ResultSet listingsResults = stmt.executeQuery(countListingsEntries);
		System.out.println("Successfully executed query");
		listingsResults.next();
		int numOfListings = listingsResults.getInt("count(*)");
		if (numOfListings > 0) {
			%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<th>Robot Image</th>
				<th>Auction Name</th>
				<th>Robot Type</th>
				<th>Start Time</th>
				<th>End Time</th>
				<th>Max Bid Amount</th>
			<%
			listingsResults = stmt.executeQuery(selectListingsColumns);
			
			for (int i = 0; i < numOfListings && listingsResults.next(); i++) {				
			%>
				<tr>
					<td style="text-align: center; vertical-align: middle">
						<img src=<%=listingsResults.getString("pic_url")%> onerror="this.style.display='none'" style="max-width:200px; max-height:200px;">
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%=listingsResults.getString("listing_name")%>
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%=listingsResults.getString("r_type")%>
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%
						Timestamp startTimestamp = listingsResults.getTimestamp("start_time");
						if (startTimestamp == null) {
							%> 
							No Real Date
							<%
						} else {
							DateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd hh:mm:ss");
							java.util.Date date = new java.util.Date(startTimestamp.getTime());
							String startStrDate = dateFormat.format(date);
							%>
							<%=startStrDate%>
						<%
						} 
						%>
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%
						Timestamp endTimestamp = listingsResults.getTimestamp("end_time");
						if (endTimestamp == null) {
							%> 
							No Real Date
							<%
						} else {
							DateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd hh:mm:ss");
							java.util.Date date = new java.util.Date(endTimestamp.getTime());
							String endStrDate = dateFormat.format(date);
							%>
							<%=endStrDate%>
						<%
						} 
						%>
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%System.out.println("Retrieving amount");%>
						
						<%="$" + listingsResults.getString("max_bid_amt")%>
					</td>
				</tr>
			<% 
			}
			%>
			</table>
			</div>
			<%
		} else {
			%>
			<p>This user is not selling an item.</p>
			<%
		}
		%>
	<h3>
		<em>Sold</em>
	</h3>
	<%
		//Prepare a SQL query to retrieve all the bids that the user ID of the associated profile have participated in
		String pastListings = 
			"FROM Auction as a "
			+ "JOIN Robot  as r using (robot_id) "
			+ "WHERE a.status='closed' AND a.u_id=" 
			+ profileUserID + " "
			+ "ORDER BY a.start_time DESC";
		String pastListingsColumns = 
			"SELECT a.listing_name, a.max_bid_amt, a.start_time, a.end_time, r.pic_url, r.r_type "
			+ pastListings;
		String countPastListingsEntries = 
			"SELECT count(*) "
			+ pastListings;
		System.out.println(countPastListingsEntries);
		ResultSet pastListingsResults = stmt.executeQuery(countPastListingsEntries);
		pastListingsResults.next();
		int numOfPastListings = pastListingsResults.getInt("count(*)");

		if (numOfPastListings > 0) {
			%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<th>Robot Image</th>
				<th>Auction Name</th>
				<th>Robot Type</th>
				<th>Start Time</th>
				<th>End Time</th>
				<th>Max Bid Amount</th>
			<%
			pastListingsResults = stmt.executeQuery(pastListingsColumns);
			
			for (int i = 0; i < numOfPastListings && pastListingsResults.next(); i++) {				
			%>
				<tr>
					<td style="text-align: center; vertical-align: middle">
						<img src=<%=pastListingsResults.getString("pic_url")%> onerror="this.style.display='none'" style="max-width:200px; max-height:200px;">
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%=pastListingsResults.getString("listing_name")%>
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%=pastListingsResults.getString("r_type")%>
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%
						Timestamp startTimestamp = pastListingsResults.getTimestamp("start_time");
						if (startTimestamp == null) {
							%> 
							No Real Date
							<%
						} else {
							DateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd hh:mm:ss");
							java.util.Date date = new java.util.Date(startTimestamp.getTime());
							String startStrDate = dateFormat.format(date);
							%>
							<%=startStrDate%>
						<%
						} 
						%>
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%
						Timestamp endTimestamp = pastListingsResults.getTimestamp("end_time");
						if (endTimestamp == null) {
							%> 
							No Real Date
							<%
						} else {
							DateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd hh:mm:ss");
							java.util.Date date = new java.util.Date(endTimestamp.getTime());
							String endStrDate = dateFormat.format(date);
							%>
							<%=endStrDate%>
						<%
						} 
						%>
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%System.out.println("Retrieving amount");%>
						
						<%="$" + pastListingsResults.getString("max_bid_amt")%>
					</td>
				</tr>
			<% 
			}
		
			%>
			</table>
			</div>
			<%
		} else {
			%>
			<p>This user has not sold an item.</p>
			<%
		}
		%>
	<!-- Populate the table that displays history of bids and items bidded on -->
	<h3>
		<em>Bid History</em>
	</h3>
	<%
		//Prepare a SQL query to retrieve all the bids that the user ID of the associated profile have participated in
		String bidHistory = 
			"FROM Auction as a join Bid as b using (a_id) join Robot as r using (robot_id) "
			+ "WHERE b.u_id=" 
			+ profileUserID + " "
			+ "ORDER BY b_date_time DESC";
		String selectBidColumns = 
			"SELECT a.listing_name, a.status, b.amount, b.b_date_time, r.pic_url, r.r_type "
			+ bidHistory;
		String countBidEntries = 
			"SELECT count(*) "
			+ bidHistory;
		System.out.println(countBidEntries);
		ResultSet bidResults = stmt.executeQuery(countBidEntries);
		System.out.println("Successfully executed query");
		bidResults.next();
		int numOfBids = bidResults.getInt("count(*)");
		if (numOfBids > 0) {
			%>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<th>Robot Image</th>
				<th>Auction Name</th>
				<th>Robot Type</th>
				<th>Auction Status</th>
				<th>Bid Date</th>
				<th>Bid Amount</th>
			<%
			bidResults = stmt.executeQuery(selectBidColumns);
			
			for (int i = 0; i < numOfBids && bidResults.next(); i++) {				
			%>
				<tr>
					<td style="text-align: center; vertical-align: middle">
						<img src=<%=bidResults.getString("pic_url")%> alt="Robot image missing." style="max-width:200px; max-height:200px;">
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%=bidResults.getString("listing_name")%>
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%=bidResults.getString("r_type")%>
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%=bidResults.getString("status")%>
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
							<%=strDate%>
						<%
						} 
						%>
					</td>
					<td style="text-align: center; vertical-align: middle">
						<%System.out.println("Retrieving amount");%>
						
						<%="$" + bidResults.getString("amount")%>
					</td>
				</tr>
			<% 
			}
			%>
			</table>
			</div>
			<%
		} else {
			%>
			<p>This user has not bidded on an item.</p>
			<%
		}
		
		} catch (Exception e) {
			e.printStackTrace();
	%>
	<script>
		alert("Something went wrong. Please try again.");
		window.location.href = "index.jsp";
	</script>
	<%
			return;
		}
	%>
	<hr>
    <footer class="center center-text width-most">
        <h4>
            <em>roBay</em>, an assignment for Rutgers University CS336, Spring 2019
        </h4>
        <h5>
            Group 18: Rishab Chawla, Amber Rawson, Jason Scot, Roshni Shah
        </h5>
    </footer>
</body>
</html>