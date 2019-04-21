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
			window.location.href = "index.jsp";
	</script> 
	<% 
	}
	
	//check to see that the user was directed to a valid auction. if not, take them back to the broswing page
    int a_id = -1;
    System.out.println(request.getParameter("a_id"));
    if(request.getParameter("a_id")!= null && request.getParameter("a_id")!= "") {
      a_id = Integer.parseInt(request.getParameter("a_id"));
    } else if (a_id == -1) {
    	%>
    	<script>
    			alert("You need to select a valid auction");
    			window.location.href = "browsing.jsp";
    	</script> 
    	<% 
    }
    
    //try-catch block to generate the entire page
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
			System.out.println(viewerUserID);
		} else {
			System.out.println("The user does not exist in the database");
			return;
		}
		
		//Prepare an SQL query to get information about the auction such as descriptions, amounts, pictures, times, etc.
		String getAuctionInformation = 
				"SELECT r.pic_url, r.description, a.listing_name, a.u_id, a.end_time, a.min_amt, a.status, a.max_bid_amt "
				+ "FROM Auction as a "
				+ "JOIN Robot as r using (robot_id) "
				+ "WHERE a.a_id="
				+ a_id;
		
		ResultSet auctionInfo = stmt.executeQuery(getAuctionInformation);
		auctionInfo.next();
		
		//find out the auction owner
		int auctionOwner = auctionInfo.getInt("u_id");
		
		//get the name of the listing for this auction
		String itemName = auctionInfo.getString("listing_name");
				
		//get the url for the picture of this listing
		String pic_url = auctionInfo.getString("pic_url");
				
		//get the description of this listing
		String listingDescr = auctionInfo.getString("description");

		//find out how long until the page has to be refreshed because the auction ended
		Timestamp timestampDifference = auctionInfo.getTimestamp("end_time");
		if (timestampDifference == null) {
				System.out.println("Auction never ends");
		}
		java.util.Date endDate = new java.util.Date(timestampDifference.getTime());
		java.util.Date currDate = new java.util.Date();
	
		//convert this difference to millisecond and set a time out for when the page should be refreshed and the winner declared
		long diffInMilliseconds = endDate.getTime() - currDate.getTime();
		System.out.println(diffInMilliseconds);
		if (diffInMilliseconds >= 0) {
			%>
			 	<script>
				 	setTimeout(function(){
				 	   window.location.href = "declareWinner.jsp?a_id=" + <%=a_id%>;
				 	   }, <%=diffInMilliseconds%>);
			 	</script>
		 	<% 
		}
 		String auctionStatus = auctionInfo.getString("status");
 		System.out.println("The status of this auction is: " + auctionStatus);
 		System.out.println(auctionStatus.equals("closed"));
	 	if (auctionStatus.equals("closed")) {
	 		String getAmountsQuery =
					"SELECT a.min_amt, a.max_bid_amt, b.a_id, a.u_id, b.u_id "
					+ "FROM Auction as a "
					+ "JOIN Bid as b using (a_id) "
					+ " WHERE a_id=" + a_id + " AND b.amount=a.max_bid_amt";
			
			
			ResultSet amounts = stmt.executeQuery(getAmountsQuery);
			amounts.next();
			
			if (amounts.getInt("min_amt") <= amounts.getInt("max_bid_amt")) {
				int bidderID = amounts.getInt("b.u_id");
				System.out.println(bidderID);
				int auctionerID = amounts.getInt("a.u_id");
				System.out.println(auctionerID);
				String getUsername = 
						"SELECT name_user "
						+ "FROM Account as a "
						+ "WHERE u_id=" + bidderID;
				ResultSet username = stmt.executeQuery(getUsername);
				username.next();
				%>
					<p>This auction has ended. The winner of the auction is: 
						<a
							href=<%="profile.jsp?profileUserID=" + bidderID + "&name_user=" + username.getString("name_user").replaceAll(" ", "_") %>>
							<%=username.getString("name_user") %>
						</a>
					</p>
				<% 
			} else {
				%>
				<p>No one has won this auction.</p>
				<%
			}
		}
 	%>
		<div>
			<h2>
				<em>Auction Listing: <%=itemName %></em>
			</h2>
		</div>
		<img src=<%=pic_url%>
			alt="Robot image missing." class="center"
			style="max-width: 200px; max-height: 200px;">
		<p class="center-text"><%=listingDescr %>
		<h3>
			<em>Item Bid History</em>
		</h3>
   		
   		<%
  		//Prepare a SQL query to retrieve all the bids and names of users where the auction id is equal to a_id
  		String currentBidHistory = 
  			"FROM Bid as b "
  			+ "JOIN Account as a using (u_id) "
			+ "WHERE b.a_id="
			+ a_id + " "
			+ "ORDER BY b.amount DESC";
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
	  					%> <a
					href=<%="profile.jsp?profileUserID=" + otherUserID + "&name_user=" + profileUser.replaceAll(" ", "_") %>>
						<%=profileUser %>
				</a>
	
	
				</td>
				<td style="text-align: center; vertical-align: middle">
					<%
	  						Timestamp timestamp = bidResults.getTimestamp("b_date_time");
	  						if (timestamp == null) {
		  						%> No Real Date <% 
	  						} else {
	  							DateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd hh:mm:ss");
	  							java.util.Date date = new java.util.Date(timestamp.getTime());
	  							String strDate = dateFormat.format(date);
	  							%> <%=strDate %> <%
	  						}
	  						%>
				</td>
				<td style="text-align: center; vertical-align: middle"><%=bidResults.getString("amount") %>
				</td>
				<%
	  				if (viewerAccountType.equals("A") || viewerAccountType.equals("S")) {
	  			%>
						<td style="text-align: center; vertical-align: middle">
							<button name="deleteButton" type="button"
								class="width-some feedback card-box-2" value="<%=viewerUserID%>"
								onclick=<%= "location.href='deleteBid.jsp?b_id=" + bidResults.getInt("b_id") + "&a_id=" + a_id + "';" %>>Delete</button>
						</td>
				<%
	  				}
	  			%>
			</tr>
			<%
	  			}
	  		%>
		</table>
	<%
  		} else {
  	%>
			<p>This item has no bids.</p>
	<%
  		}	
  	%>
  	
  	<% 
  	if ((viewerUserID != auctionOwner) && auctionStatus.equals("open")) {
  		%>
	<h3>
		<em>Set a Bid</em>
	</h3>
	<form action="makeBid.jsp?a_id=<%=a_id%>" method="post">
		<br> <input type="submit" value="Make A Bid">
	</form>
	<%
  	}
  	
  %>
	<h3>
		<strong>Questions</strong>
	</h3>
	<h3>
		<strong>Search Questions</strong>
	</h3>
	<div>
		<form action="auctionItem.jsp">
			<input type="text" name="descr"> 
			<input type="hidden" name="a_id" value=<%=a_id%>> 
			<br> 
			<input type="submit" value="Submit">
		</form>
	</div>
	<h3>
		<em>Ask a Question</em>
	</h3>
	<div>
	<form action="askQuestion.jsp?a_id=<%=a_id%>">
		<input type="hidden" name="a_id" value=<%=a_id%>> 
		<input type="hidden" name="v_u_id" value=<%=viewerUserID%>> 
		<input type="text" name="question"> <br> <input type="submit" value="Submit">
	</form>
	</div>
	<div>
	<h4>
		<em>Unanswered Questions</em>
	</h4>
  <%
  	String descr = request.getParameter("descr");
  		//retrieve all the unanswered questions from the database
   		String getUnansweredQuestions = 
   			"FROM Answer "
   			+ "RIGHT JOIN Question Using (q_id) "
   			+ "WHERE answer IS null "
   			+ "AND a_id=" + a_id;
   		if (descr != null && descr != "") {
			String searchQuery = " AND (question like \'%"+descr+"%\')";
			getUnansweredQuestions += searchQuery;
   	  	}
  		//count of unanswered questions
  		String countUnansweredQuestions = 
  				"SELECT count(*) "
  				+ getUnansweredQuestions;
  		
  		//result with unanswered questions and other valuable data
  		String selectUnansweredQuestions =
  				"SELECT q_id, question, a_id, q_u_id "
  				+ getUnansweredQuestions;
   		System.out.println(countUnansweredQuestions);
   		System.out.println(selectUnansweredQuestions);
   		//make the SQL query to retrieve all the unanswered questions
   		ResultSet unansweredQuestionsCount = stmt.executeQuery(countUnansweredQuestions);
   		unansweredQuestionsCount.next();
   		int numberOfUnansweredQuestions = unansweredQuestionsCount.getInt("count(*)");
   		if (numberOfUnansweredQuestions > 0) {
   			System.out.println("Make a list with forms of questions");
   			%>
   			<li style="list-style:none">
   			<% 
   				ResultSet unansweredQuestions = stmt.executeQuery(selectUnansweredQuestions);
  				for (int i = 0; i < numberOfUnansweredQuestions && unansweredQuestions.next(); i++) {
					%>
					<ul style="display: list-item">
						<p><%=unansweredQuestions.getString("question")%></p>
						<form action="answerQuestion.jsp">
							<textarea rows="5" cols="20" name="answer" placeholder="Answer the question."></textarea>
							<br>
							<input type="hidden" name="a_id" value=<%=a_id%>> 
							<input type="hidden" name="q_id" value=<%=unansweredQuestions.getInt("q_id")%>> 
							<input type="hidden" name="v_u_id" value=<%=viewerUserID%>>
							<input type="submit" value="Submit">
						</form>
					</ul>
					<%
  				}
   			%>
   			</li>
   			<% 
   		} else {
   			if (descr != null && descr != "") {
   				%>
   				<p>The search result produced no unanswered questions</p>
   				<%
   			}
   			
   			else {
   				%>
   				<p>There are no unanswered questions</p>
			<%
   			}
   		}
   		%>
   		</div>
   		<h4>
			<em>Answered Questions</em>
		</h4>
		<%
		//retrieve all the answered questions from the database
   		String getAnsweredQuestions = 
   			"FROM Answer "
   			+ "LEFT JOIN Question Using (q_id) "
   			+ "WHERE a_id=" + a_id;
		if (descr != null && descr != "") {
			String searchQuery = " AND (answer like \'%"+descr+"%\' OR question like \'%"+descr+"%\')";
			getAnsweredQuestions += searchQuery;
   	  	}
  		//count of unanswered questions
  		String countAnsweredQuestions = 
  				"SELECT count(*) "
  				+ getAnsweredQuestions;
  		
  		//result with unanswered questions and other valuable data
  		String selectAnsweredQuestions =
  				"SELECT * "
  				+ getAnsweredQuestions;
   		System.out.println(countAnsweredQuestions);
   		System.out.println(selectAnsweredQuestions);
   		
   		//make the SQL query to retrieve all the unanswered questions
   		ResultSet answeredQuestionsCount = stmt.executeQuery(countAnsweredQuestions);
   		answeredQuestionsCount.next();
   		int numberOfAnsweredQuestions = answeredQuestionsCount.getInt("count(*)");
   		if (numberOfAnsweredQuestions > 0) {
   			System.out.println("Make a list with forms of questions");
   			%>
   			<li style="list-style:none">
   			<% 
   				ResultSet answeredQuestions = stmt.executeQuery(selectAnsweredQuestions);
  				for (int i = 0; i < numberOfAnsweredQuestions && answeredQuestions.next(); i++) {
					%>
					<ul style="display: list-item">
						<p><%=answeredQuestions.getString("question")%></p>
						<p><strong>Answer:</strong> <%=answeredQuestions.getString("answer") %></p>
					</ul>
					<%
  				}
   			%>
   			</li>
   			<% 
   		} else {
   			if (descr != null && descr != "") {
   				%>
   				<p>The search result produced no unanswered questions</p>
   				<%
   			}
   			
   			else {
   				%>
   				<p>There are no unanswered questions</p>
			<%
   			}
   		}
   		%>

	<!--  display auction items from last month -->
	<%
			
		String retrieveItems = ("SELECT a.listing_name, a.max_bid_amt, a.status, a.a_id, r.pic_url, r.r_type, r.description, a.end_time ");
		retrieveItems += "FROM Auction a join Robot r using(robot_id) WHERE a.start_time BETWEEN CURDATE() - INTERVAL 31 DAY AND CURDATE() ";
		
		//These two lines replace the one above
		//retrieveItems += "FROM Auction a join Robot r using(robot_id) WHERE a.start_time BETWEEN CURDATE() - INTERVAL 31 DAY AND CURDATE()  AND r.r_type =";
		//retrieveItems += r_type + " ";
		retrieveItems += "GROUP BY a.a_id ";
		ResultSet items = stmt.executeQuery(retrieveItems);
		int numItems = 5;
		
		System.out.println(retrieveItems);
		%>
	<%
		int count = 0;
		while(items.next() && count < 5){
		String listingName  = items.getString("listing_name");
		//float maxBidAmt = items.getFloat("max_bid_amt");
		//String status = items.getString("status");
		String picURL = items.getString("pic_url");
		int auction_id = items.getInt("a_id");
			if (a_id != auction_id ){
				count ++;
	%>
			<a href=<%="auctionItem.jsp?a_id="+ auction_id %> style="text-decoration: none; color: black;">
				<div class="card-box">
					<h2><%= listingName %></h2>
					<img src=<%=picURL%> alt="Robot image missing." style="max-width: 200px; max-height: 200px;">
				</div> 
				</br>
			</a>
	
	<%
			}	//end inner if 
		} // end while
			%>
	<%
			if (viewerAccountType.equals("A") || viewerAccountType.equals("S")) {

			%>		
				<a href=<%="deleteAuction.jsp?a_id=" + a_id%>>
					<button style="text-align: center; vertical-align: middle" name="deleteAuction" type="button"
						class="width-some feedback card-box-2">
						Delete Auction
					</button>
				</a>
			<%
			}
			con.close();
    } catch(Exception e) {
    	e.printStackTrace();
    }
		%>
</body>
</html>
