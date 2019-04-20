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
<title>roBay: Create New Auction</title>
<link rel="stylesheet" href="css/main.css">
</head>
<body>
	<div class="center-text margin-up">
		<h2>
			<em>Auction creation</em>
		</h2>
	</div>
	<%
		try {
			//Get parameters from the HTML form at the register.jsp
			String bid_amt = "";
			String secret_bid  = "";
			String a_id  = "";
			String secret_bid_amt = "";
			String min_bid_inc = "";
			String min_bid_amt = "";
			
			bid_amt = request.getParameter("bid_amt");
			secret_bid = request.getParameter("secret_bid");
			secret_bid_amt = request.getParameter("bid_amt");
			a_id = request.getParameter("a_id");
			min_bid_inc = request.getParameter("min_bid_inc");
			min_bid_amt = request.getParameter("min_bid_allowed");
			
			System.out.println("We got params: " + bid_amt + " " + secret_bid + " " +
				secret_bid_amt + " " + a_id + " " + min_bid_inc + " " + min_bid_amt);
			if(secret_bid == null){
				secret_bid = "";
			}
			String user_email = (String) session.getAttribute("email_addr");
			if (user_email == null || user_email == "") {
				%>
				<script>
					alert("You need to login to create a new auction.");
					window.location.href = "index.jsp";
				</script>
				<%
			}
			if (min_bid_amt.equals("")) {
				%>
				<script>
					alert("That is not a valid minimum bid amount.");
					window.location.href = "browsing.jsp";
				</script>
				<%
				return;
			}
			if (secret_bid.equals("true")) {
				bid_amt = min_bid_amt;
			}
			if (a_id.equals("")) {
				%>
				<script>
					alert("That is not a valid item to bid on.");
					window.location.href = "browsing.jsp";
				</script>
				<%
				return;
			}
			if (min_bid_inc.equals("")) {
				%>
				<script>
					alert("That is not a valid minimum increment.");
					window.location.href = "browsing.jsp";
				</script>
				<%
				return;
			}
			
			String url = "jdbc:mysql://db-project.cvdxoiqfbf2x.us-east-2.rds.amazonaws.com:3306/RobayProjectSchema";
			Class.forName("com.mysql.jdbc.Driver");

			Connection con = DriverManager.getConnection(url, "sqlgroup", "be_my_robae");
			if (con != null) {
				System.out.println("Successfully connected to the database.");
			} else {
				System.out.println("Failed to connect to the database.");
			}
				
			Statement stmt = con.createStatement();
			PreparedStatement ps;
			
			String findUserID = "SELECT u_id FROM Account WHERE email_addr = '";
			findUserID += user_email;
		    findUserID += "';";
			
		    ResultSet senderIDSet = stmt.executeQuery(findUserID);
		    
		    String u_id = "";
		    
		    if(senderIDSet.next()){
		    	u_id  = senderIDSet.getString("u_id");
		    } else{
		    %>
		    <script>
			   alert("Account invalid. Please login again.");
			   window.location.href = "index.jsp";
			</script>
		    <%
		    }
			
			java.util.Date dt = new java.util.Date();
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentTime = sdf.format(dt);
			
			System.out.println("We hit the logic folks!");
			
			// Find person who is the current highest bidder
			
			findUserID = "SELECT a.u_id FROM Account a join Bid b using(u_id) WHERE b.amount = (SELECT max(b.amount)" +
					"FROM Account a join Bid b using(u_id) WHERE b.a_id = ";
			findUserID += a_id;
		    findUserID += ");";
			
		    senderIDSet = stmt.executeQuery(findUserID);
		    
		    String prev_u_id = "";
		    
		    if(senderIDSet.next()){
		    	prev_u_id  = senderIDSet.getString("u_id");
		    }
			
			String insertStr = "";
			
			if(secret_bid.equals("true")){
				//secret bid - u_id, a_id, max_amt
				
				if (secret_bid_amt.equals("")) {
					%>
					<script>
						alert("A secret bid must have an amount.");
						window.location.href = "browsing.jsp";
					</script>
					<%
					return;
				}
				String findSecretBids = "SELECT * FROM setSecretBid WHERE a_id =";
				findSecretBids += a_id;
				findSecretBids += " AND u_id =";
				findSecretBids += u_id;
			    ResultSet secretBidSet = stmt.executeQuery(findSecretBids);
			    
			    String updateStr;
			    int records = -1;
			    
			    if(secretBidSet.next()){
			    	
			    	updateStr = "UPDATE setSecretBid SET max_amt= " + secret_bid_amt + " WHERE a_id= " + a_id + " AND u_id= " + u_id;
			    	System.out.println("Updating secret bid: " + updateStr);
			    	records = stmt.executeUpdate(updateStr);
			    	
					System.out.println("Records changed in secret bid " + records);
					
			    }else{
			    	
			    	insertStr = "INSERT INTO setSecretBid(u_id, a_id, max_amt) " + "VALUES (" + u_id + ", " + a_id + ", " + secret_bid_amt + ")";
			    	System.out.println("Making new secret bid: " + insertStr);
			    	records = stmt.executeUpdate(insertStr, Statement.RETURN_GENERATED_KEYS);
			    	
					System.out.println("Records changed in secret bid " + records);
					ResultSet rs = stmt.getGeneratedKeys();
					if(rs.next()){
						System.out.println(rs.getString("u_id"));
					}
			    }
				
			}
			
			//put in bid
			if (!prev_u_id.equals(u_id) || secret_bid.equals("")){
				System.out.println("Creating a bid");
				
				insertStr = "INSERT INTO Bid (amount, b_date_time, a_id, u_id)"
						+ " VALUES (?, ?, ?, ?)";
				ps = con.prepareStatement(insertStr);
				
				ps.setString(1, bid_amt);
				ps.setString(2, currentTime);
				ps.setString(3, a_id);
				ps.setString(4, u_id);
				
				ps.executeUpdate();
				
				// email person who was outbid
				if(!prev_u_id.equals("") && !prev_u_id.equals(u_id)){
					insertStr = "INSERT INTO Email (content, subject, date_time, sender, reciever)"
							+ " VALUES (?, ?, ?, ?, ?)";
					ps = con.prepareStatement(insertStr);
					
					ps.setString(1, ("You've been outbid on the following item: auctionItem.jsp?a_id=" + a_id));
					ps.setString(2, "You've been outbid");
					ps.setString(3, currentTime);
					ps.setString(4, prev_u_id);
					ps.setString(5, "15");
					
					ps.executeUpdate();
				}
				
				prev_u_id = u_id;
			}
			String deleteStr = "";
			String findSecretBids = "SELECT * FROM setSecretBid WHERE a_id =";
			findSecretBids += a_id;
			
		    ResultSet secretBidSet = stmt.executeQuery(findSecretBids);
		    
		    String secret_u_id = "";
		    String secret_max_amt = "";
		    
		    ArrayList<ArrayList<String>> bidQueue = new ArrayList<ArrayList<String>>();
		    ArrayList<String> secretBid = new ArrayList<String>();
		    
		    
		    while(secretBidSet.next()){
		    	secretBid = new ArrayList<String>();
		    	
		    	secret_u_id  = secretBidSet.getString("u_id");
		    	secret_max_amt = secretBidSet.getString("max_amt");
		    	
		    	secretBid.add(secret_u_id);
		    	secretBid.add(secret_max_amt);
		    	
		    	System.out.println("adding a secret bid to the queue");
		    	
		    	bidQueue.add(secretBid);
		    }
		    
		    System.out.println("Bid queue size: " + bidQueue.size());
		    
		    
		    while(bidQueue.size() > 0){
		    	secret_u_id = bidQueue.get(0).get(0);
		    	secret_max_amt = bidQueue.get(0).get(1);
		    	
		    	System.out.println(secret_u_id + " " + secret_max_amt);
		    	
		    	if(bidQueue.size() == 1 && prev_u_id.equals(secret_u_id)){
		    		System.out.println("I'm breaking! ");
		    		break;
		    	}
		    	
		    	System.out.println("I shouldn't be here but prev id = " + prev_u_id);
		    	
		    	if(Float.parseFloat(bid_amt)+Float.parseFloat(min_bid_inc) > Float.parseFloat(secret_max_amt)){
		    		// remove secret bid
		    		deleteStr = "DELETE FROM setSecretBid WHERE u_id = ? AND max_amt = ?";
					ps = con.prepareStatement(deleteStr);
					
					ps.setString(1, secret_u_id);
					ps.setString(2, secret_max_amt);
					
					ps.executeUpdate();
					
					//	email user that their secret bid lost
					insertStr = "INSERT INTO Email (content, subject, date_time, sender, reciever)"
							+ " VALUES (?, ?, ?, ?, ?)";
					ps = con.prepareStatement(insertStr);
					
					ps.setString(1, ("Your secret bid been outbid on the following item: auctionItem.jsp?a_id=" + a_id));
					ps.setString(2, "Your secret bid has been outbid.");
					ps.setString(3, currentTime);
					ps.setString(4, secret_u_id);
					ps.setString(5, "15");
					
					ps.executeUpdate();
					
					bidQueue.remove(0);
					
		    	}else{
		    		// place new bid
		    		insertStr = "INSERT INTO Bid (amount, b_date_time, a_id, u_id)"
					+ " VALUES (?, ?, ?, ?)";
					ps = con.prepareStatement(insertStr);
					
					bid_amt = Float.toString(Float.parseFloat(bid_amt)+ Float.parseFloat(min_bid_inc));
					
					ps.setString(1, bid_amt);
					ps.setString(2, currentTime);
					ps.setString(3, a_id);
					ps.setString(4, secret_u_id);
					
					ps.executeUpdate();
				
					// email person who was outbid
					
					insertStr = "INSERT INTO Email (content, subject, date_time, sender, reciever)"
							+ " VALUES (?, ?, ?, ?, ?)";
					ps = con.prepareStatement(insertStr);
					
					ps.setString(1, ("You've been outbid on the following item: auctionItem.jsp?a_id=" + a_id));
					ps.setString(2, "You've been outbid");
					ps.setString(3, currentTime);
					ps.setString(4, prev_u_id);
					ps.setString(5, "15");
					
					ps.executeUpdate();
					
					//update new highest bidder					
					prev_u_id = secret_u_id;
				
					// put at the back of the line
					bidQueue.add(bidQueue.get(0));
					bidQueue.remove(0);
		    	}	
		    	
		    }	
				
	%>
	<script>
		alert("Bid made.");
		window.location.href = <%="\"auctionItem.jsp?a_id="+a_id +"\""%>;
	</script>
	<%
		con.close();
		} catch (Exception e) {
			System.out.println("Creation error" + e);
	%>
	<script>
		alert("Something went wrong. Please try again.");
		window.location.href = "browsing.jsp";
	</script>
	<%
		return;
		}
	%>
</body>
</html>
