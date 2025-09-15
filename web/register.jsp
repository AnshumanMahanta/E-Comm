<%-- 
    Document   : register
    Created on : Sep 14, 2025, 11:12:25 PM
    Author     : ASUS
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>User Registration</title>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
            background-color: #e0e0e0; /* A light gray, common in early 2000s themes */
            color: #333;
            text-align: center;
            padding: 50px;
        }

        /* Container styled to look like a pop-up or a bordered window */
        .container {
            width: 350px;
            margin: 0 auto;
            background-color: #fff;
            border: 1px solid #999;
            box-shadow: 5px 5px 15px rgba(0,0,0,0.2);
            padding: 20px 40px;
            border-radius: 8px;
        }

        h2 {
            font-size: 24px;
            color: #0066cc; /* A bright blue, very popular at the time */
            text-shadow: 1px 1px 1px #ccc;
            border-bottom: 2px solid #ccc;
            padding-bottom: 10px;
        }

        label {
            display: block;
            text-align: left;
            margin-bottom: 5px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box; /* Ensures padding doesn't affect total width */
            background-color: #f9f9f9;
        }

        input[type="submit"] {
            background-color: #009933; /* A vibrant green, common for "Go" or "Submit" buttons */
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            box-shadow: 2px 2px 5px rgba(0,0,0,0.3);
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #00802b;
        }
        
        /* A classic 2000s banner/header style */
        .header-banner {
            background-color: #ff9900; /* Bright orange */
            color: #fff;
            padding: 15px;
            margin-bottom: 20px;
            font-size: 2em;
            font-weight: bold;
            text-shadow: 2px 2px 2px #000;
        }

        /* Subtle gradients were everywhere */
        .gradient-bg {
            background: linear-gradient(to bottom, #eeeeee, #cccccc);
        }
    </style>
</head>
<body class="gradient-bg">
    <div class="header-banner">
        Welcome!
    </div>
    
    <div class="container">
        <h2>User Registration</h2>
        <form action="register" method="post">
            <label>Full Name:</label>
            <input type="text" name="name" required />
            
            <label>Email:</label>
            <input type="email" name="email" required />
            
            <label>Phone Number:</label>
            <input type="text" name="phone" required />
            
            <label>Password:</label>
            <input type="password" name="password" required />
            
            <input type="submit" value="Register" />
        </form>
    </div>
</body>
</html>