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
			String listing_name = "";
			String min_bid_inc  = "";
			String max_bid_amt  = "";
			String min_amt = "";
			String end_time = "";
			String production_year = "";
			String mobility_level = "";
			String pic_url = "";
			String description = "";
			String r_type = "";
			String personality = "";
			String purpose = "";
			String training_level = "";
			String expertise = "";
			String hull_strength = "";
			String tracking_level = "";
			String specialty = "";
			
			listing_name = request.getParameter("listing_name");
			min_amt = request.getParameter("max_bid_amt");
			min_bid_inc = request.getParameter("min_bid_inc");
			max_bid_amt = request.getParameter("max_bid_amt");
			end_time = request.getParameter("end_time");
			production_year = request.getParameter("production_year");
			mobility_level = request.getParameter("mobility_level");
			pic_url = request.getParameter("pic_url");
			description = request.getParameter("description");
			
			r_type = request.getParameter("r_type");
			
			personality = request.getParameter("personality");
			purpose = request.getParameter("purpose");
			
			training_level = request.getParameter("training_level");
			expertise = request.getParameter("expertise");
			
			hull_strength = request.getParameter("hull_strength");
			tracking_level = request.getParameter("tracking_level");
			specialty = request.getParameter("specialty");
			
			
			String user_email = (String) session.getAttribute("email_addr");
			if (user_email == null || user_email == "") {
				%>
				<script>
					alert("You need to login to create a new auction.");
					window.location.href = "index.jsp";
				</script>
				<%
			}
			if (listing_name.equals("") || min_bid_inc.equals("") || production_year.equals("") || mobility_level.equals("") || 
					pic_url.equals("") || r_type.equals("") || end_time.equals("") || max_bid_amt.equals("")) {
				%>
				<script>
					alert("One of the general parameters was missing. Try again.");
					window.location.href = "newAuction.jsp";
				</script>
				<%
				return;
			}
			if (r_type.equals("personal")){
				if (personality.equals("") || purpose.equals("")) {
					System.out.println("One of the personal robot parameters was missing. Enter all information!");
					%>
					<script>
						alert("One of the personal robot parameters was missing. Try again.");
						window.location.href = "newAuction.jsp";
					</script>
					<%
					return;
				}
			}else if(r_type.equals("medical")){
				if (training_level.equals("") || expertise.equals("")) {
					System.out.println("One of the medical robot parameters was missing. Enter all information!");
					%>
					<script>
						alert("One of the medical robot parameters was missing. Try again.");
						window.location.href = "newAuction.jsp";
					</script>
					<%
					return;
				}
			}else{
				if (hull_strength.equals("") || tracking_level.equals("") || specialty.equals("")) {
					System.out.println("One of the military robot parameters was missing. Enter all information!");
					%>
					<script>
						alert("One of the military robot parameters was missing. Try again.");
						window.location.href = "newAuction.jsp";
					</script>
					<%
					return;
				}
			}
			
			java.util.Date dt = new java.util.Date();
			java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String currentTime = sdf.format(dt);
			try{
				sdf.parse(end_time);
				sdf.parse(currentTime);
			}catch(Exception e){
				%>
				<script>
					alert("The datetime entered was not in the correct format. Try again.");
					window.location.href = "newAuction.jsp";
				</script>
				<%
			}
			System.out.println("Times: " + currentTime + " " + end_time);
			if(sdf.parse(currentTime).compareTo(sdf.parse(end_time)) > 0){
				%>
				<script>
					alert("The end time must be in the future. Try again.");
					window.location.href = "newAuction.jsp";
				</script>
				<%
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
			
			String insertStr = "";
			
			if(r_type.equals("personal")){
				insertStr = "INSERT INTO Robot (production_year, mobility_level, pic_url, personality, purpose, r_type, description)"
						+ " VALUES (?, ?, ?, ?, ?, 'personal', ?)";
				ps = con.prepareStatement(insertStr);
				
				ps.setString(1, production_year);
				ps.setString(2, mobility_level);
				ps.setString(3, pic_url);
				ps.setString(4, personality);
				ps.setString(5, purpose);
				ps.setString(6, description);
				
				ps.executeUpdate();
				
			}else if (r_type.equals("medical")){
				insertStr = "INSERT INTO Robot (production_year, mobility_level, pic_url, training_level, expertise, r_type, description)"
						+ " VALUES (?, ?, ?, ?, ?, 'medical', ?)";
				ps = con.prepareStatement(insertStr);
				
				ps.setString(1, production_year);
				ps.setString(2, mobility_level);
				ps.setString(3, pic_url);
				ps.setString(4, training_level);
				ps.setString(5, expertise);
				ps.setString(6, description);
				
				ps.executeUpdate();
				
			}else{
				insertStr = "INSERT INTO Robot (production_year, mobility_level, pic_url, hull_strength, tracking_level, specialty, r_type, description)"
						+ " VALUES (?, ?, ?, ?, ?, ?, 'military', ?)";
				ps = con.prepareStatement(insertStr);
				
				ps.setString(1, production_year);
				ps.setString(2, mobility_level);
				ps.setString(3, pic_url);
				ps.setString(4, hull_strength);
				ps.setString(5, tracking_level);
				ps.setString(6, specialty);
				ps.setString(7, description);
				
				
				ps.executeUpdate();
			}

			//insert in table
			insertStr = "INSERT INTO Auction (u_id, start_time, end_time, listing_name, min_bid_inc, robot_id, max_bid_amt, status, min_amt)"
					+ " VALUES (?, ?, ?, ?, ?, ?, ?, 'open', ?)";
			ps = con.prepareStatement(insertStr);
			
			String robot_id = "";
			String findRobotID = "SELECT max(robot_id) FROM Robot";
			ResultSet robotIDSet = stmt.executeQuery(findRobotID);
			if(robotIDSet.next()){
		    	robot_id  = robotIDSet.getString("max(robot_id)");
		    } else{
		    %>
		    <script>
			   alert("Error in the database. Try again.");
			   window.location.href = "newAuction.jsp";
			</script>
		    <%
		    }
			
			
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
		    
			ps.setString(1, u_id);
			ps.setString(2, currentTime);
			ps.setString(3, end_time);
			ps.setString(4, listing_name);
			ps.setString(5, min_bid_inc);
			ps.setString(6, robot_id);
			ps.setString(7, max_bid_amt);
			ps.setString(8, min_amt);
			

			ps.executeUpdate();
			con.close();
	%>
	<script>
		alert("Auction created.");
		window.location.href = "profile.jsp";
	</script>
	<%
		} catch (Exception e) {
			System.out.println("Creation error" + e);
	%>
	<script>
		alert("Something went wrong. Please try again.");
		window.location.href = "newAuction.jsp";
	</script>
	<%
		return;
		}
	%>
</body>
</html>
