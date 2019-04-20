<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*, java.text.*,java.sql.*"%>
<%@ page
	import=" java.security.MessageDigest, java.security.NoSuchAlgorithmException"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>roBay: Delete Bid</title>
</head>
<body>
	<%
		String currentUser = (String) session.getAttribute("name_user");
	
		if (currentUser == null || currentUser.equals("")) {
		%>
			<script>
				alert("You need to delete your account");
				window.location.href = "index.jsp";
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
			
			String a_idStr = (String) request.getParameter("a_id");
			System.out.println("String: " + a_idStr);
			if (a_idStr == null) {
				%>
				<script>
					alert("Invalid bid or auction selected. Redirecting you to search");
					window.location.href = "landingPage.jsp";
				</script>
				<%
			}
			int a_id = Integer.parseInt(a_idStr);
			System.out.println(a_id);
			String currentUserEmail = (String) session.getAttribute("email_addr");
			String deleteAuctionQuery = 
					"DELETE "
					+ "FROM Auction "
					+ "WHERE a_id="
					+ a_id;
			System.out.println(deleteAuctionQuery);
			stmt.executeUpdate(deleteAuctionQuery);
			%>
			<script>
				alert("Successfully deleted the auction. Redirecting you back to the auction.");
				window.location.href = "browsing.jsp";
			</script>
			<%
		} catch (Exception e) {
			e.printStackTrace();
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
   
	