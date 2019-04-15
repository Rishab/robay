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
    <div class="center-text margin-up">
        <h2>
            <em>Create New Auction</em>
        </h2>
    </div>
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
                    <em>Starting Price: </em>
                    <br>
                    <input type="number" style = "border: 1px solid black;" name="max_bid_amt" class="width-most width-capped-avg">
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
                <div class="margin-down-tiny">
					<em>Robot Type:</em> </br>
				    <select name="r_type" class="width-most width-capped-avg">
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
                    <input type="text" name="personality" maxlength="255" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Purpose:</em>
                    <br>
                    <input type="text" name="purpose" maxlength="255" class="width-most width-capped-avg">
                </div>
                
                </br>
                
                <p>Fields only used if it's a medical robot. </p>
                <div class="margin-down-tiny">
                    <em>Training Level:</em>
                    <br>
                    <input type="number" style = "border: 1px solid black;" name="training_level" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Expertise:</em>
                    <br>
                    <input type="text" name="expertise" maxlength="255" class="width-most width-capped-avg">
                </div>
                
                </br>
                
                <p>Fields only used if it's a military robot. </p>
                <div class="margin-down-tiny">
                    <em>Hull Strength:</em>
                    <br>
                    <input type="number" style = "border: 1px solid black;" name="hull_strength" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Tracking Level:</em>
                    <br>
                    <input type="number" style = "border: 1px solid black;" name="tracking_level" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Specialty:</em>
                    <br>
                    <input type="text" name="specialty" maxlength="255" class="width-most width-capped-avg">
                </div>
            </div>
            <div class="center-flex margin-down-tiny">
                <input type="submit" value="Send" class="width-some width-capped-small pointer card-box-2 feedback">
            </div>
        </form>
    </div>
</body>

</html>
