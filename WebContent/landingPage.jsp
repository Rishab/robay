<!DOCTYPE html>
<html>
<head>
<title>roBay</title>
<link rel="stylesheet" href="css/main.css">
</head>
<body>
	<%
		String name = (String) session.getAttribute("name_user");
	%>
	Hi
	<%=name%>, Welcome to Robay!
</body>

</html>
