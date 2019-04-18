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
    <div class="center-text margin-up">
        <h2>
            <em>Place a Bid</em>
        </h2>
    </div>
    <div class="height-tiny"></div>
    <%
    String name_user = (String) session.getAttribute("name_user");
    System.out.println(name_user);
    
		if (name_user == null || name_user == "") {
			%>
			<script>
				alert("You need to login to bid.");
				window.location.href = "index.jsp";
			</script>
			<%
		}
    String a_id = request.getParameter("a_id");

	if (a_id == null || a_id == "") {
		%>
		<script>
			alert("Must place a bid on a real item.");
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
		
	String findAuction = "SELECT max_bid_amt, min_bid_inc FROM Auction WHERE a_id = '";
	findAuction += a_id;
    findAuction += "';";
	
    ResultSet findAuctionSet = stmt.executeQuery(findAuction);
    
    String max_bid_amt = "";
    String min_bid_inc = "";
    
    if(findAuctionSet.next()){
    	max_bid_amt  = findAuctionSet.getString("max_bid_amt");
    	min_bid_inc  = findAuctionSet.getString("min_bid_inc");
    } else{
    %>
    <script>
	   alert("This bid is not valid. Try again.");
	   window.location.href = "browsing.jsp";
	</script>
    <%
    }
    float minBidAllowed = Float.parseFloat(max_bid_amt) + Float.parseFloat(min_bid_inc);
    System.out.println("Max bid amount" + max_bid_amt);
    System.out.println("Minimum bid increment" + min_bid_inc);
    System.out.println("Minimum  bid allowed" + minBidAllowed);
    
    %>

    <div class="center width-most width-capped-decent card-box">
        <form action="createBid.jsp" method =  "post" class="">
            <div class="margin-up-tiny margin-down-tiny margin-left-small">
                <div class="margin-down-tiny">
                    <em>Bid Amount: </em>
                    <br>
                    <input type="number" min= <%=minBidAllowed%> style = "border: 1px solid black;" name="bid_amt" step = 0.01 class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                	<input type="checkbox" name="secret_bid" value="true">
                	<em>This is a secret bid. (The lowest possible bid will be made under the secret bid amount.)</em>
                </div>
                <div>
                	<input type="text" name="a_id" value=<%=a_id%> style = "visibility: hidden;">
                </div>
                <div>
                	<input type="text" name="min_bid_inc" value=<%=min_bid_inc%> style = "visibility: hidden;">
                </div>
                <div>
                	<input type="text" name="min_bid_allowed" value=<%=minBidAllowed%> style = "visibility: hidden;">
                </div>
            </div>
            <div class="center-flex margin-down-tiny">
                <input type="submit" value="Send" class="width-some width-capped-small pointer card-box-2 feedback">
            </div>
        </form>
    </div>
    
    <%
		} catch (Exception e) {
			System.out.println("Creation error");
	%>
	<script>
		alert("Something went wrong. Please try again.");
		window.location.href = "index.jsp";
	</script>
	<%
		return;
		}
	%>
	
</body>

</html>
