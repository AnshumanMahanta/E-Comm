<%-- 
    Document   : admin_dashboard
    Created on : Sep 15, 2025
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page import="java.util.ArrayList, java.util.List, java.util.Map, java.util.HashMap" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: 'Courier New', Courier, monospace;
            margin: 0;
            padding: 0;
            background-color: #2b2b2b;
            color: #00ff00;
        }
        .dashboard-container {
            display: flex;
            min-height: 100vh;
            border: 2px solid #00ff00;
        }
        .sidebar {
            width: 250px;
            background-color: #1a1a1a;
            color: #fff;
            padding: 20px;
            box-shadow: none;
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            overflow-y: auto;
            border-right: 2px solid #00ff00;
        }
        .sidebar h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #00ffff;
            text-shadow: 2px 2px #000;
        }
        .sidebar ul {
            list-style: none;
            padding: 0;
        }
        .sidebar ul li {
            margin-bottom: 10px;
        }
        .sidebar ul li a {
            color: #fff;
            text-decoration: none;
            display: block;
            padding: 12px;
            border: 1px solid #00ff00;
            border-radius: 0;
            transition: background-color 0s, color 0s;
        }
        .sidebar ul li a:hover {
            background-color: #00ff00;
            color: #000;
        }
        .main-content {
            margin-left: 275px;
            padding: 40px;
            flex-grow: 1;
        }
        .header {
            background-color: #1a1a1a;
            padding: 20px;
            border-radius: 0;
            box-shadow: none;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border: 2px solid #00ff00;
        }
        .header h1 {
            margin: 0;
            color: #00ffff;
            text-shadow: 2px 2px #000;
        }
        .logout-btn {
            background-color: #ff0000;
            color: #fff;
            padding: 10px 20px;
            border: 2px solid #ff0000;
            border-radius: 0;
            text-decoration: none;
        }
        .logout-btn:hover {
            background-color: #c00000;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            background-color: #1a1a1a;
            color: #fff;
            border-radius: 0;
            overflow: hidden;
            box-shadow: none;
            border: 2px solid #00ff00;
        }
        .data-table th, .data-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #00ff00;
        }
        .data-table th {
            background-color: #333;
            color: #00ffff;
            text-transform: uppercase;
            font-size: 0.9em;
        }
        .data-table tr:hover {
            background-color: #2b2b2b;
        }
        .action-buttons a {
            margin-right: 10px;
            text-decoration: none;
            color: #00ffff;
            font-weight: bold;
        }
        .action-buttons a.delete {
            color: #ff0000;
        }
        .add-btn {
            background-color: #008000;
            color: #fff;
            padding: 10px 20px;
            border: 2px solid #00ff00;
            border-radius: 0;
            text-decoration: none;
            margin-bottom: 20px;
            display: inline-block;
        }
        .add-btn:hover {
            background-color: #006400;
        }
        .form-container {
            background-color: #1a1a1a;
            padding: 20px;
            border-radius: 0;
            box-shadow: none;
            margin-bottom: 20px;
            border: 2px solid #00ff00;
        }
        .form-container input[type="text"], 
        .form-container input[type="email"], 
        .form-container input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 2px solid #00ff00;
            border-radius: 0;
            box-sizing: border-box;
            background-color: #2b2b2b;
            color: #fff;
        }
        .form-container input[type="submit"] {
            background-color: #00ffff;
            color: #000;
            padding: 12px 20px;
            border: 2px solid #00ffff;
            border-radius: 0;
            cursor: pointer;
        }
        p {
            color: #00ff00;
        }
    </style>
</head>
<body>
    <%
        // Security check: If the user is not an admin, redirect them.
        if (session.getAttribute("isAdmin") == null || !(boolean) session.getAttribute("isAdmin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        String table = request.getParameter("table");
        if (table == null || table.isEmpty()) {
            table = "dashboard";
        }
    %>

    <div class="dashboard-container">
        <div class="sidebar">
            <h2>Admin Panel</h2>
            <ul>
                <li><a href="admin_dashboard.jsp?table=dashboard">Dashboard</a></li>
                <li><a href="admin_dashboard.jsp?table=users">Users</a></li>
                <li><a href="admin_dashboard.jsp?table=products">Products</a></li>
                <li><a href="admin_dashboard.jsp?table=categories">Categories</a></li>
                <li><a href="admin_dashboard.jsp?table=orders">Orders</a></li>
                <li><a href="admin_dashboard.jsp?table=reviews">Reviews</a></li>
                <li><a href="admin_dashboard.jsp?table=audit_logs">Audit Logs</a></li>
                <li><a href="admin_dashboard.jsp?table=coupons">Coupons</a></li>
                <li><a href="admin_dashboard.jsp?table=addresses">Addresses</a></li>
            </ul>
        </div>

        <div class="main-content">
            <div class="header">
                <h1><%= table.substring(0, 1).toUpperCase() + table.substring(1).replace("_", " ") %> Management</h1>
                <a href="logout" class="logout-btn">Logout</a>
            </div>

            <%
                if ("dashboard".equals(table)) {
                    // Display dashboard overview (hardcoded for now)
            %>
                <div class="form-container">
                    <h3>Welcome to the Admin Dashboard</h3>
                    <p>Use the sidebar to manage different parts of the store.</p>
                </div>
            <%
                } else {
                    // This section will handle displaying the table data
                    List<Map<String, Object>> dataList = null;
                    try (Connection conn = DBConnection.getConnection();
                         PreparedStatement stmt = conn.prepareStatement("SELECT * FROM " + table)) {
                        
                        try (ResultSet rs = stmt.executeQuery()) {
                            ResultSetMetaData rsmd = rs.getMetaData();
                            int columnCount = rsmd.getColumnCount();
                            
                            dataList = new ArrayList<>();
                            while (rs.next()) {
                                Map<String, Object> row = new HashMap<>();
                                for (int i = 1; i <= columnCount; i++) {
                                    row.put(rsmd.getColumnName(i), rs.getObject(i));
                                }
                                dataList.add(row);
                            }
                        }
                    } catch (SQLException e) {
                        out.println("<p style='color: #ff0000;'>Database error: " + e.getMessage() + "</p>");
                    }
                    
                    if (dataList != null && !dataList.isEmpty()) {
            %>
                <a href="AdminControllerServlet?command=add&table=<%= table %>" class="add-btn">Add New <%= table.substring(0, 1).toUpperCase() + table.substring(1).replace("_", " ") %></a>
                <table class="data-table">
                    <thead>
                        <tr>
                            <% 
                                for (String column : dataList.get(0).keySet()) {
                                    out.println("<th>" + column.toUpperCase().replace("_", " ") + "</th>");
                                }
                                out.println("<th>Actions</th>");
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Map<String, Object> row : dataList) {
                                out.println("<tr>");
                                for (Object value : row.values()) {
                                    out.println("<td>" + (value != null ? value.toString() : "N/A") + "</td>");
                                }
                                out.println("<td class='action-buttons'>");
                                out.println("<a href='AdminControllerServlet?command=edit&table=" + table + "&id=" + row.get("id") + "'>Edit</a>");
                                out.println("<a href='AdminControllerServlet?command=delete&table=" + table + "&id=" + row.get("id") + "' class='delete' onclick='return confirm(\"Are you sure you want to delete this record?\")'>Delete</a>");
                                out.println("</td>");
                                out.println("</tr>");
                            }
                        %>
                    </tbody>
                </table>
            <%
                    } else if (dataList != null && dataList.isEmpty()) {
                        out.println("<p style='color: #00ff00;'>No records found in the " + table.replace("_", " ") + " table.</p>");
                        out.println("<a href='AdminControllerServlet?command=add&table=" + table + "' class='add-btn'>Add First " + (table.substring(0, 1).toUpperCase() + table.substring(1).replace("_", " ")) + "</a>");
                    }
                }
            %>
        </div>
    </div>
</body>
</html>