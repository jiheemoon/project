<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>
    Home PAGE
</h1>

<P>  The time on the server is ${serverTime}. </P>
    
<a href="${CTX_PATH}/sign">sign</a>
    
</body>
</html>
