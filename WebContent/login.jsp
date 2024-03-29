<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>roBay: Login</title>
    <link rel="stylesheet" href="css/main.css">
</head>
<body>
<header>
	<div class="left-float">
		<b><em>roBay</em></b>, by Group 18
	</div>
	<div class="right-text">
		<a href="index.jsp" class="capitalize padding-right-tiny decoration-hover visited-navy color-navy">Home</a>
		
		<%
			String acc_type = (String) session.getAttribute("acc_type");
			boolean admin = false;
			boolean staff = false;
			
			if (acc_type != null) {
				%>
					<script>
						alert("You must log out before logging into a new account");
						location.href='logOut.jsp';
					</script>
					<a href="register.jsp" class="capitalize padding-right-tiny decoration-hover visited-navy color-navy">Register</a>
				<%
			} else {
				%>
					<a href="register.jsp" class="capitalize padding-right-tiny decoration-hover visited-navy color-navy">Register</a>
				<%
			}
			
		%>
	</div>
	<hr>
</header>
    <div class="center-text margin-up">
        <h2>
            <em>Login to roBay</em>
        </h2>
    </div>
    <div class="height-tiny"></div>

    <div class="center width-most width-capped-decent card-box">
        <form action="validateLogin.jsp" class="">
            <div class="margin-up-tiny margin-down-tiny margin-left-small">
                <div class="margin-down-tiny">
                    <em>Email Address</em>
                    <br>
                    <input type="email" name="email" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Password</em>
                    <br>
                    <input type="password" name="password" class="width-most width-capped-avg">
                </div>
            </div>
            <div class="center-flex margin-down-tiny">
                <input type="submit" value="Login" class="width-some width-capped-small pointer card-box-2 feedback">
            </div>
        </form>
    </div>

    <div class="height-tiny"></div>
    <div class="center-text">
        <a href="index.jsp"><em>Return home</em></a>
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
