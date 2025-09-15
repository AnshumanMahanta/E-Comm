<%-- 
    Document   : order_confirmation
    Created on : Sep 14, 2025, 11:22:19 PM
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Order Confirmation</title>
    <style>
        /* General page and text styling for a retro look */
        body {
            background-color: #008080; /* Teal background from Windows 95 */
            font-family: 'Courier New', Courier, monospace, sans-serif;
            margin: 0;
            padding: 20px;
            color: #000;
        }

        /* Container styled as a classic window */
        .window {
            background-color: #C0C0C0; /* Standard gray window color */
            border-style: outset;
            border-width: 3px;
            border-color: #FFFFFF #6F6F6F #6F6F6F #FFFFFF;
            box-shadow: 4px 4px #000;
            padding: 4px;
            width: 90%;
            max-width: 500px;
            margin: 20px auto;
            text-align: center; /* Center the content inside */
        }

        /* Title bar for the window */
        .title-bar {
            background-color: #000080; /* Classic blue title bar */
            color: #FFF;
            padding: 5px 8px;
            font-weight: bold;
            font-size: 1.2em;
            text-align: left;
        }

        /* Main content body of the window */
        .window-body {
            padding: 15px;
            background-color: #C0C0C0;
        }
        
        h2 {
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 1.5em;
            text-transform: uppercase;
            text-align: center;
            border-bottom: 2px solid #808080;
            padding-bottom: 5px;
        }

        p {
            margin: 10px 0;
        }
        
        /* Links styled as retro buttons */
        .button-link {
            display: inline-block;
            background-color: #C0C0C0;
            border-style: outset;
            border-width: 2px;
            border-color: #FFF #6F6F6F #6F6F6F #FFF;
            padding: 8px 16px;
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            text-decoration: none;
            color: #000;
            margin: 5px;
            transition: all 0.1s ease-in-out;
        }
        
        .button-link:hover {
            background-color: #D0D0D0;
        }

        .button-link:active {
            border-style: inset;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            transform: translate(1px, 1px);
        }
    </style>
</head>
<body>
    <div class="window">
        <div class="title-bar">
            Order Confirmation
        </div>
        <div class="window-body">
            <h2>Order Confirmed!</h2>
            <p>Thank you for your purchase. Your order has been successfully placed.</p>
            
            <%
                // Retrieve the order ID from the URL parameter
                String orderId = request.getParameter("orderId");
                if (orderId != null) {
            %>
                <p>Your Order ID is: <strong><%= orderId %></strong></p>
            <%
                }
            %>
            
            <p>
                <a href="products.jsp" class="button-link">Continue Shopping</a>
                <a href="logout" class="button-link">Logout</a>
            </p>
        </div>
    </div>
</body>
</html>