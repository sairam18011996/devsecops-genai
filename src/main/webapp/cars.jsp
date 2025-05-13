<%@ page import="java.util.List" %>
<%@ page import="com.example.carrental.Car" %>
<%
    List<Car> cars = (List<Car>) request.getAttribute("cars");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Car List</title>
</head>
<body>
    <h2>Available Cars</h2>
    <ul>
        <% for(Car car : cars) { %>
            <li><%= car.getYear() %> <%= car.getModel() %> - <%= car.getType() %></li>
        <% } %>
    </ul>
</body>
</html>
