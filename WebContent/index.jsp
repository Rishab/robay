<!DOCTYPE html>
<html>
<head>
    <title>roBay</title>
    <link rel="stylesheet" href="css/main.css">
</head>
<body>
<header>
	<div class="left-float">
		<b><em>roBay</em></b>, by Group 18
	</div>
	<div class="right-text">
		<a href="register.jsp" class="capitalize padding-right-tiny decoration-hover visited-navy color-navy">Sign up</a>
		
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
        <h1>
            roBay
        </h1>
        <h2>
            <em>By Group 18: Rishab Chawla, Amber Rawson, Jason Scot, Roshni Shah</em>
        </h2>
        <%
        session.invalidate();
        %>
    </div>
    <div class="height-tiny"></div>

    <div class="center-flex">
        <button onclick="location.href='register.jsp';" class="width-some feedback card-box-2">
            <h3 class="capitalize">Sign Up</h3>
        </button>
        <div class="width-tiny"></div>
        <button onclick="location.href='login.jsp';" class="width-some feedback card-box-2">
            <h3 class="capitalize">Login</h3>
        </button>
    </div>

    <div class="height-some"></div>
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
