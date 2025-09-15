<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>User Login</title>
    <style>
        /* General page and text styling */
        body {
            background-color: #008080; /* Classic Teal desktop background */
            font-family: 'MS Sans Serif', 'Arial', sans-serif;
            font-size: 14px; /* Slightly larger for better readability */
            color: #000;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            box-sizing: border-box;
        }
        
        /* Main window container */
        .window {
            background-color: #C0C0C0;
            border-style: outset;
            border-width: 3px; /* Thicker borders for a more pronounced 3D effect */
            border-color: #FFFFFF #6F6F6F #6F6F6F #FFFFFF;
            box-shadow: 4px 4px #000; /* Larger, more prominent shadow */
            padding: 4px; /* Increased padding */
            width: 350px; /* Slightly wider window */
            max-width: 95%;
            transition: transform 0.2s ease-in-out;
        }

        /* Window title bar */
        .title-bar {
            background-color: #000080;
            color: #FFF;
            padding: 5px 8px; /* Adjusted padding */
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 16px; /* Larger font for the title */
        }

        /* Form content area */
        .form-content {
            padding: 25px; /* Increased padding inside the form */
            background-color: #C0C0C0;
            border: 2px solid #808080; /* A dark gray inset border to define the content area */
            border-top-color: #808080;
            border-left-color: #808080;
            border-right-color: #FFF;
            border-bottom-color: #FFF;
        }

        /* Input fields and labels */
        label {
            display: block;
            margin-bottom: 5px;
            text-align: left;
            font-weight: bold;
            color: #333;
        }

        input[type="email"], input[type="password"] {
            border-style: inset;
            border-width: 2px;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            padding: 5px; /* Increased padding */
            width: 100%;
            box-sizing: border-box;
            background-color: #FFF;
            font-size: 14px;
            margin-bottom: 15px; /* Added margin for spacing */
        }
        
        input[type="email"]:focus, input[type="password"]:focus {
            outline: none;
            border-color: #000 #FFF #FFF #000;
        }

        /* Submit button */
        input[type="submit"] {
            background-color: #C0C0C0;
            border-style: outset;
            border-width: 2px;
            border-color: #FFF #6F6F6F #6F6F6F #FFF;
            padding: 6px 20px; /* Larger padding for a bigger button */
            font-weight: bold;
            cursor: pointer;
            text-transform: uppercase;
            font-size: 14px;
            min-width: 100px;
            margin-top: 15px; /* Added spacing above button */
            transition: all 0.1s ease-in-out;
        }

        input[type="submit"]:hover {
            background-color: #D0D0D0;
        }
        
        input[type="submit"]:active {
            border-style: inset;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            transform: translate(1px, 1px);
        }
    </style>
</head>
<body>
    <div class="window">
        <div class="title-bar">
            <span>User Login</span>
        </div>
        <div class="form-content">
            <form action="login" method="post">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required />
                
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required />
                
                <div style="text-align: right;">
                    <input type="submit" value="Login" />
                </div>
            </form>
        </div>
    </div>
</body>
</html>