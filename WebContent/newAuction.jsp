<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>roBay: Create New Auction</title>
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
        <h2>
            <em>Create New Auction</em>
        </h2>
    </div>
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
	%>
    <div class="height-tiny"></div>

    <div class="center width-most width-capped-decent card-box">
        <form action="createAuction.jsp" method = "post" id="createForm">
            <div class="margin-up-tiny margin-down-tiny margin-left-small">
                <div class="margin-down-tiny">
                    <em>Listing Name:</em>
                    <br>
                    <input type="text" name="listing_name" maxlength="50" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Minimum Bid Increment: </em>
                    <br>
                    <input type="number" style = "border: 1px solid black;" name="min_bid_inc" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Minimum Selling Price (Secret): </em>
                    <br>
                    <input type="number" style = "border: 1px solid black;" name="min_amt" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Auction End Date & Time: "yyyy-MM-dd HH:mm:ss" </em>
                    <br>
                    <input type="text" style = "border: 1px solid black;" name="end_time" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Production Year: </em>
                    <br>
                    <input type="number" style = "border: 1px solid black;" name="production_year" class="width-most width-capped-avg">
                </div>
                 <div class="margin-down-tiny">
                    <em>Mobility Level: </em>
                    <br>
                    <input type="number" style = "border: 1px solid black;" name="mobility_level" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Url Of Image:</em>
                    <br>
                    <input type="url" name="pic_url" maxlength="500" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Description of Item:</em>
                    <br>
                    <textarea name="description" id="description" cols="40" rows="5" maxlength="500" form = "createForm" class="width-most width-capped-avg"></textarea>
                </div>
                <div onclick="checkRobots()" class="margin-down-tiny" >
					<em>Robot Type:</em> </br>
				    <select id="r_type" name="r_type" class="pointer width-most width-capped-avg">
				      <option value = "personal">Personal</option>
				      <option value = "medical">Medical</option>
				      <option value = "military">Military</option>
				    </select>
			    </div>
			    </br>
                <p>Fields only used if it's a personal robot. </p>
                <div class="margin-down-tiny">
                    <em>Personality:</em>
                    <br>
                    <input id="1_per" type="text" name="personality" maxlength="255" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Purpose:</em>
                    <br>
                    <input id="2_per" type="text" name="purpose" maxlength="255" class="width-most width-capped-avg">
                </div>
                
                </br>
                
                <p>Fields only used if it's a medical robot. </p>
                <div class="margin-down-tiny">
                    <em>Training Level:</em>
                    <br>
                    <input id="1_med" type="number" style = "border: 1px solid black;" name="training_level" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Expertise:</em>
                    <br>
                    <input id="2_med" type="text" name="expertise" maxlength="255" class="width-most width-capped-avg">
                </div>
                
                </br>
                
                <p>Fields only used if it's a military robot. </p>
                <div class="margin-down-tiny">
                    <em>Hull Strength:</em>
                    <br>
                    <input id="1_mil" type="number" style = "border: 1px solid black;" name="hull_strength" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Tracking Level:</em>
                    <br>
                    <input id="2_mil" type="number" style = "border: 1px solid black;" name="tracking_level" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Specialty:</em>
                    <br>
                    <input id="3_mil" type="text" name="specialty" maxlength="255" class="width-most width-capped-avg">
                </div>
                
                <script>
				    function checkRobots() {
				    	var robot_type = document.getElementById('r_type').value;
				    	
				    	if (robot_type == "personal") {
				    		document.getElementById('1_per').disabled = false;
				    		document.getElementById('2_per').disabled = false;
				    		
				    		document.getElementById('1_med').disabled = true;
				    		document.getElementById('2_med').disabled = true;
				    		
				    		document.getElementById('1_mil').disabled = true;
				    		document.getElementById('2_mil').disabled = true;
				    		document.getElementById('3_mil').disabled = true;
				        } else if (robot_type == "medical"){
				    		document.getElementById('1_per').disabled = true;
				    		document.getElementById('2_per').disabled = true;
				    		
				    		document.getElementById('1_med').disabled = false;
				    		document.getElementById('2_med').disabled = false;
				    		
				    		document.getElementById('1_mil').disabled = true;
				    		document.getElementById('2_mil').disabled = true;
				    		document.getElementById('3_mil').disabled = true;
				    	} else if (robot_type == "military") {
				    		document.getElementById('1_per').disabled = true;
				    		document.getElementById('2_per').disabled = true;
				    		
				    		document.getElementById('1_med').disabled = true;
				    		document.getElementById('2_med').disabled = true;
				    		
				    		document.getElementById('1_mil').disabled = false;
				    		document.getElementById('2_mil').disabled = false;
				    		document.getElementById('3_mil').disabled = false;
				    	} else {
				    		document.getElementById('1_per').disabled = true;
				    		document.getElementById('2_per').disabled = true;
				    		
				    		document.getElementById('1_med').disabled = true;
				    		document.getElementById('2_med').disabled = true;
				    		
				    		document.getElementById('1_mil').disabled = true;
				    		document.getElementById('2_mil').disabled = true;
				    		document.getElementById('3_mil').disabled = true;
				    	}
					}
				    
				    checkRobots();
				</script>
            </div>
            <div class="center-flex margin-down-tiny">
                <input type="submit" value="Send" class="width-some width-capped-small pointer card-box-2 feedback">
            </div>
        </form>
    </div>
</body>

</html>
