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
    <div class="center-text margin-up">
    </div>
    <div class="height-tiny"></div>
    <%
    String name_user = (String) session.getAttribute("name_user");
    System.out.println(name_user);
    
		if (name_user == null || name_user == "") {
			%>
			<script>
				alert("You need to login to declare the winner of this auction.");
				window.location.href = "index.jsp";
			</script>
			<%
		}
    String a_id = request.getParameter("a_id");
	System.out.println(a_id);
	if (a_id == null || a_id == "") {
		%>
		<script>
			alert("Must declare winner on a real item.");
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
		
		String closeAuction =
				"UPDATE Auction SET status='closed' WHERE a_id=" + a_id;
		System.out.println("Closing the auction");
		
		stmt.executeUpdate(closeAuction);
		
		String getAmountsQuery =
				"SELECT a.min_amt, a.max_bid_amt, b.a_id, a.u_id, b.u_id, a.listing_name "
				+ "FROM Auction as a "
				+ "JOIN Bid as b using (a_id) "
				+ " WHERE a_id=" + a_id + " AND b.amount=a.max_bid_amt";
		
		System.out.println(getAmountsQuery);
		
		ResultSet amounts = stmt.executeQuery(getAmountsQuery);
		if (!amounts.next()) {
			%>
				<script>
				alert("The auction has ended. No one has bidded on this auction. Redirecting you to browsing page.");
				window.location.href = "browsing.jsp";
				</script>
			<%
			return;
		}
		int bidderID = amounts.getInt("b.u_id");
		int auctionerID = amounts.getInt("a.u_id");
		int reserveAmount = amounts.getInt("a.min_amt");
		int maxBidAmount = amounts.getInt("a.max_bid_amt");
		String listingName = amounts.getString("a.listing_name"); 
		
		//Figure out who to send the email to
		String getUsername = 
				"SELECT name_user "
				+ "FROM Account as a "
				+ "WHERE u_id=" + bidderID;
		ResultSet username = stmt.executeQuery(getUsername);
		username.next();
		String email = "INSERT INTO Email (sender, reciever, subject, content, date_time)"
				+ " VALUES (?, ?, ?, ?, ?)";
		
		if (reserveAmount <= maxBidAmount) {
			String subject = "Auction " + listingName + " won";
			String content = "You have won the auction! Congratulations.";
			PreparedStatement ps = con.prepareStatement(email);
			ps.setString(1, Integer.toString(auctionerID));
			ps.setString(2, Integer.toString(bidderID));
			ps.setString(3, subject);
			ps.setString(4, content);
			
			java.util.Date dt = new java.util.Date();
			java.text.SimpleDateFormat sdf = 
			     new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentTime = sdf.format(dt);
			
			ps.setString(5, currentTime);
			ps.executeUpdate();
			%>
			<script>
				alert("This auction has ended. The winner of the auction is <%=username.getString("name_user").replaceAll("_", " ")%>. Redirecting you to the auction.");
				window.location.href = "auctionItem.jsp?a_id=" + <%=a_id%>;
			</script>
			<% 
		} else {
			String subject = "Auction " + listingName + " lost";
			String content = "You have lost the auction! You did not meet the reserve amount.";
			PreparedStatement ps = con.prepareStatement(email);
			ps.setString(1, Integer.toString(auctionerID));
			ps.setString(2, Integer.toString(bidderID));
			ps.setString(3, subject);
			ps.setString(4, content);
			
			java.util.Date dt = new java.util.Date();
			java.text.SimpleDateFormat sdf = 
			     new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentTime = sdf.format(dt);
			
			ps.setString(5, currentTime);
			ps.executeUpdate();
			%>
			<script>
				alert("This auction has ended. The reserve price for this auction has not been met. Redirecting you to browsing page.");
				window.location.href = "browsing.jsp";
			</script>
			<%
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	}
	%>
</body>

</html>

