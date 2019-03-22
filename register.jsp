<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>roBay: Sign Up</title>
    <link rel="stylesheet" href="css/main.css">
</head>
<body>
    <div class="center-text margin-up">
        <h2>
            <em>Sign up for roBay</em>
        </h2>
    </div>
    <div class="height-tiny"></div>

    <div class="center width-most width-capped-decent card-box">
        <form action="createUser.jsp" method =  "post" class="">
            <div class="margin-up-tiny margin-down-tiny margin-left-small">
                <div class="margin-down-tiny">
                    <em>Name:</em>
                    <br>
                    <input type="text" name="name" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>State your email address</em>
                    <br>
                    <input type="email" name="email" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Choose a password</em>
                    <br>
                    <input type="password" name="password" class="width-most width-capped-avg">
                </div>
                <div class="margin-down-tiny">
                    <em>Confirm your password</em>
                    <br>
                    <input type="password" name="password_confirm" class="width-most width-capped-avg">
                </div>
            </div>
            <div class="center-flex margin-down-tiny">
                <input type="submit" value="Register" class="width-some width-capped-small pointer card-box-2">
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
