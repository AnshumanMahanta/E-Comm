<%--
    Document    : products
    Created on  : Sep 14, 2025, 11:19:11 PM
    Author      : ASUS
--%>

<%@ page import="java.sql.*, util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Product Catalog</title>
    <style>
        /* General page and text styling for a retro look */
        body {
            background-color: #A0A0A0; /* A warmer gray for the background */
            font-family: 'Courier New', Courier, monospace, sans-serif;
            margin: 0;
            padding: 0;
            color: #000;
        }

        /* Navbar styled as a classic menu bar */
        .navbar {
            background-color: #C0C0C0;
            border-bottom: 2px solid #000000;
            border-right: 2px solid #000000;
            border-top: 2px solid #FFFFFF;
            border-left: 2px solid #FFFFFF;
            box-shadow: 2px 2px #000;
            padding: 5px;
            font-size: 14px;
            display: flex;
            justify-content: flex-end;
            align-items: center;
        }

        .navbar a {
            color: #000;
            text-decoration: none;
            padding: 8px 12px;
            border: 2px solid transparent;
            margin: 0 5px;
            transition: all 0.1s ease-in-out;
            text-transform: uppercase;
        }

        .navbar a:hover {
            background-color: #FFA500; /* Orange hover color */
            color: #FFFFFF;
        }
        
        .navbar a:active {
            border-style: inset;
            border-color: #D37D00 #FFF #FFF #D37D00; /* Darker orange for active state */
            background-color: #E0A040;
            transform: translate(1px, 1px);
        }

        /* Main content area, no longer centered */
        .product-list {
            background-color: #C0C0C0;
            border-style: outset;
            border-width: 3px;
            border-color: #FFFFFF #6F6F6F #6F6F6F #FFFFFF;
            box-shadow: 4px 4px #000;
            margin: 20px; /* Adjust to remove auto centering */
            padding: 10px;
            text-align: center;
        }
        
        /* Heading style */
        .product-list h2 {
            background-color: #FF8C00; /* Darker orange title bar */
            color: #FFFFFF;
            padding: 5px;
            text-align: left;
            font-size: 1.5em;
            margin: -10px -10px 10px -10px; /* Adjust to sit right at the top of the window */
            font-weight: bold;
        }

        /* Individual product item as a "file" or "icon" */
        .product-item {
            border: 2px solid #808080;
            border-top-color: #C0C0C0;
            border-left-color: #C0C0C0;
            border-right-color: #FFFFFF;
            border-bottom-color: #FFFFFF;
            padding: 15px;
            margin: 15px;
            display: inline-block;
            width: 250px;
            background-color: #C0C0C0;
            text-align: center;
            transition: all 0.1s ease-in-out;
            box-shadow: none;
        }

        .product-item:hover {
            background-color: #B0B0B0;
            border: 2px solid #FF8C00; /* Orange border on hover */
            color: #000000;
        }
        
        .product-item:hover h3,
        .product-item:hover p {
            color: #000000;
        }
        .product-item img {
            max-width: 100%;
            height: auto;
            border: 2px solid #808080;
            border-top-color: #C0C0C0;
            border-left-color: #C0C0C0;
            border-right-color: #FFFFFF;
            border-bottom-color: #FFFFFF;
            margin-bottom: 10px;
        }
        
        .product-item h3 {
            margin: 10px 0;
            font-size: 1.2em;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .product-item p {
            font-size: 1.1em;
            color: #333;
        }
        
        .product-item form {
            margin-top: 10px;
        }
        
        .product-item input[type="number"] {
            border-style: inset;
            border-width: 2px;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            padding: 3px;
            width: 50px;
            background-color: #FFF;
        }

        /* "Add to Cart" button styling */
        .product-item input[type="submit"] {
            background-color: #C0C0C0;
            border-style: outset;
            border-width: 2px;
            border-color: #FFF #6F6F6F #6F6F6F #FFF;
            padding: 8px 16px;
            color: #000;
            text-align: center;
            font-size: 14px;
            font-weight: bold;
            margin: 4px 2px;
            cursor: pointer;
            transition: all 0.1s ease-in-out;
        }

        .product-item input[type="submit"]:hover {
            background-color: #D0D0D0;
        }
        
        .product-item input[type="submit"]:active {
            border-style: inset;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            transform: translate(1px, 1px);
        }
        
        /* Search and filter box styling */
        .search-filter-box {
            background-color: #C0C0C0; 
            padding: 10px; 
            border-style: inset; 
            border-width: 2px; 
            border-color: #6F6F6F #FFF #FFF #6F6F6F; 
            margin-bottom: 20px; 
            text-align: left;
        }
        
        .search-filter-box label,
        .search-filter-box input[type="text"],
        .search-filter-box select {
            font-family: 'Courier New', Courier, monospace;
        }
        
        .search-filter-box input[type="text"],
        .search-filter-box select {
            border-style: inset; 
            border-width: 2px; 
            border-color: #6F6F6F #FFF #FFF #6F6F6F; 
            padding: 3px; 
            background-color: #FFF;
        }
        
        .search-filter-box input[type="submit"] {
            background-color: #C0C0C0; 
            border-style: outset; 
            border-width: 2px; 
            border-color: #FFF #6F6F6F #6F6F6F #FFF; 
            padding: 5px 10px; 
            font-weight: bold; 
            cursor: pointer;
        }

        .search-filter-box input[type="submit"]:active {
            border-style: inset;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            transform: translate(1px, 1px);
        }
        
        .no-results-message {
            font-size: 1.2em;
            color: #555;
            margin-top: 20px;
        }
    </style>
    <script>
        // Function to show a pop-up message when an item is added
        function showAddedToCartAlert(event) {
            // Prevent the form from submitting immediately so the alert can show
            event.preventDefault(); 
            alert('Item added to cart!'); 
            
            // Wait for the alert to be closed, then submit the form
            event.target.submit();
        }
    </script>
</head>
<body>
    <%
        // Get the current session
        HttpSession currentSession = request.getSession(false);
        
        // Check if the user_id attribute exists in the session
        if (currentSession == null || currentSession.getAttribute("user_id") == null) {
            // If not logged in, redirect to the login page
            response.sendRedirect("login.jsp");
            return; // Stop further execution of the JSP
        }
    %>
    
    <div class="navbar">
        <a href="cart.jsp">My Cart</a>
        <a href="user-profile.jsp">Profile</a>
        <a href="logout">Logout</a>
    </div>

    <div class="product-list">
        <h2>Product Catalog</h2>
        
        <div class="search-filter-box">
            <form action="products.jsp" method="get">
                <label for="search">Search Products:</label>
                <input type="text" id="search" name="search" placeholder="e.g., retro keyboard" value="<%= (request.getParameter("search") != null) ? request.getParameter("search") : "" %>">
                
                <label for="filter">Price Filter:</label>
                <select id="filter" name="filter">
                    <option value="" <%= (request.getParameter("filter") == null || request.getParameter("filter").isEmpty()) ? "selected" : "" %>>All Prices</option>
                    <option value="low" <%= "low".equals(request.getParameter("filter")) ? "selected" : "" %>>Low to High</option>
                    <option value="high" <%= "high".equals(request.getParameter("filter")) ? "selected" : "" %>>High to Low</option>
                </select>
                
                <input type="submit" value="Apply">
            </form>
        </div>
        
        <div style="background-color: #C0C0C0; padding: 20px; border: 2px solid #808080; border-top-color: #808080; border-left-color: #808080; border-right-color: #FFF; border-bottom-color: #FFF;">
        <%
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            // Retrieve search and filter parameters from the URL
            String searchTerm = request.getParameter("search");
            String filterOption = request.getParameter("filter");

            try {
                conn = DBConnection.getConnection();
                
                // Start building the base SQL query
                StringBuilder sql = new StringBuilder("SELECT p.id, p.name, p.price, pi.image_url FROM products p JOIN product_images pi ON p.id = pi.product_id");

                // Add a WHERE clause for search functionality
                if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                    sql.append(" WHERE p.name LIKE ?");
                }

                // Add an ORDER BY clause for price filtering
                if ("low".equals(filterOption)) {
                    sql.append(" ORDER BY p.price ASC");
                } else if ("high".equals(filterOption)) {
                    sql.append(" ORDER BY p.price DESC");
                }
                
                stmt = conn.prepareStatement(sql.toString());

                // Set the parameter for the search term if it exists
                if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                    stmt.setString(1, "%" + searchTerm + "%");
                }
                
                rs = stmt.executeQuery();

                boolean hasResults = false;
                while (rs.next()) {
                    hasResults = true;
        %>
            <div class="product-item">
                <h3><%= rs.getString("name") %></h3>
                <img src="<%= rs.getString("image_url") %>" alt="<%= rs.getString("name") %>" />
                <p>Price: **$<%= String.format("%.2f", rs.getDouble("price")) %>**</p>
                <form action="cart" method="post" onsubmit="showAddedToCartAlert(event)">
                    <input type="hidden" name="action" value="add" />
                    <input type="hidden" name="product_id" value="<%= rs.getInt("id") %>" />
                    <input type="number" name="quantity" value="1" min="1" />
                    <input type="submit" value="Add to Cart" />
                </form>
            </div>
        <%
                }
                
                if (!hasResults) {
                    out.println("<div class='no-results-message'>No products found matching your criteria.</div>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("Database error: " + e.getMessage());
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                if (conn != null) try { conn.close(); } catch (SQLException e) {}
            }
        %>
        </div>
    </div>
</body>
</html>