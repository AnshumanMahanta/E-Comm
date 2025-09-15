<%--
    Document   : checkout
    Created on : Sep 14, 2025, 11:21:16 PM
    Author     : ASUS
--%>

<%@ page import="java.sql.*, util.DBConnection, java.util.List, java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Checkout</title>
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
            max-width: 600px;
            margin: 20px auto;
        }

        /* Title bar for the window */
        .title-bar {
            background-color: #000080; /* Classic blue title bar */
            color: #FFF;
            padding: 5px 8px;
            font-weight: bold;
            font-size: 1.2em;
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
            text-align: left;
            border-bottom: 2px solid #808080;
            padding-bottom: 5px;
        }

        h3 {
            font-size: 1.2em;
            text-transform: uppercase;
            border-bottom: 1px solid #808080;
            padding-bottom: 5px;
        }

        .section-container {
            border-style: inset;
            border-width: 2px;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            background-color: #F0F0F0;
            padding: 15px;
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        input[type="text"], select {
            background-color: #FFF;
            border-style: inset;
            border-width: 2px;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            padding: 3px;
            box-sizing: border-box;
            width: 100%;
            margin-bottom: 10px;
        }

        /* Retro button styling */
        button, input[type="submit"], .button-link {
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
            transition: all 0.1s ease-in-out;
            display: inline-block;
            text-align: center;
        }

        button:active, input[type="submit"]:active, .button-link:active {
            border-style: inset;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            transform: translate(1px, 1px);
        }
        
        /* Specific button colors */
        .blue-button {
            background-color: #000080;
            color: #FFF;
        }

        /* Modal styling */
        .modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent overlay */
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }

        .modal.visible {
            opacity: 1;
            visibility: visible;
        }

        .modal-window {
            background-color: #C0C0C0;
            border-style: outset;
            border-width: 3px;
            border-color: #FFFFFF #6F6F6F #6F6F6F #FFFFFF;
            box-shadow: 4px 4px #000;
            padding: 4px;
            width: 90%;
            max-width: 400px;
            text-align: center;
        }
        
        .modal-body {
            padding: 15px;
            background-color: #C0C0C0;
        }
        
        .close-button {
            background-color: #C0C0C0;
            border-style: outset;
            border-width: 2px;
            border-color: #FFF #6F6F6F #6F6F6F #FFF;
            padding: 0;
            width: 25px;
            height: 25px;
            line-height: 25px;
            font-size: 1.2em;
            font-weight: bold;
            text-align: center;
            position: absolute;
            top: 5px;
            right: 5px;
            cursor: pointer;
        }

        /* QR Code section */
        .qr-code-container {
            border-style: inset;
            border-width: 2px;
            border-color: #6F6F6F #FFF #FFF #6F6F6F;
            background-color: #FFF;
            padding: 10px;
            display: inline-block;
        }
        
        .qr-code-placeholder {
            width: 150px;
            height: 150px;
            background-color: #E0E0E0;
            border: 1px solid #808080;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8em;
            text-align: center;
            color: #555;
        }

        /* Simple animation for 'Waiting...' text */
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }

        .pulse-text {
            animation: pulse 1s infinite;
        }
    </style>
</head>
<body>
    <div class="window">
        <div class="title-bar">
            Checkout
        </div>
        <div class="window-body">
            <h2>Complete Your Purchase</h2>
            
            <%
                if (session.getAttribute("user_id") == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                Integer userId = (Integer) session.getAttribute("user_id");
                double totalAmount = 0.0;
                List<String> userAddresses = new ArrayList<>();

                try (Connection conn = DBConnection.getConnection()) {
                    // Calculate total price from the cart
                    String sqlTotal = "SELECT SUM(p.price * ci.quantity) AS total " +
                                      "FROM cart_items ci " +
                                      "JOIN products p ON ci.product_id = p.id " +
                                      "JOIN carts c ON ci.cart_id = c.id " +
                                      "WHERE c.user_id = ?";
                    PreparedStatement stmtTotal = conn.prepareStatement(sqlTotal);
                    stmtTotal.setInt(1, userId);
                    ResultSet rsTotal = stmtTotal.executeQuery();
                    
                    if (rsTotal.next()) {
                        totalAmount = rsTotal.getDouble("total");
                    }

                    // Retrieve user's saved addresses from the 'addresses' table
                    String sqlAddresses = "SELECT DISTINCT street_address, city, postal_code FROM addresses WHERE user_id = ?";
                    PreparedStatement stmtAddresses = conn.prepareStatement(sqlAddresses);
                    stmtAddresses.setInt(1, userId);
                    ResultSet rsAddresses = stmtAddresses.executeQuery();
                    while (rsAddresses.next()) {
                        String address = rsAddresses.getString("street_address") + ", " + 
                                         rsAddresses.getString("city") + ", " + 
                                         rsAddresses.getString("postal_code");
                        userAddresses.add(address);
                    }
            %>
            
            <div class="section-container">
                <h3>Order Summary</h3>
                <p>Total Amount: <strong>$<%= String.format("%.2f", totalAmount) %></strong></p>
            </div>

            <div class="section-container">
                <h3>Shipping Address</h3>
                <form action="checkout" method="post">
                    <label for="address-select">Select a saved address:</label>
                    <select id="address-select" name="address-select">
                        <option value="new">-- Use a new address --</option>
                        <% for (String address : userAddresses) { %>
                            <option value="<%= address %>"><%= address %></option>
                        <% } %>
                    </select>

                    <div id="new-address-fields">
                        <label>Street Address:</label>
                        <input type="text" name="street" id="street" required />
                        
                        <label>City:</label>
                        <input type="text" name="city" id="city" required />
                        
                        <label>Postal Code:</label>
                        <input type="text" name="postalCode" id="postalCode" required />
                    </div>
                    
                    <input type="hidden" name="total_amount" value="<%= totalAmount %>" />
                    <input type="submit" id="place-order-btn" value="Place Order" />
                </form>
            </div>
            
            <%
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("Database error: " + e.getMessage());
                }
            %>
        </div>
    </div>

    <div id="payment-modal" class="modal">
        <div class="modal-window">
            <div class="title-bar">
                Payment
                <button id="close-modal" class="close-button">X</button>
            </div>
            <div class="modal-body">
                <div id="payment-stage-1" class="payment-stage">
                    <h3>Select Payment Method</h3>
                    <button id="qr-pay-btn" class="button-link blue-button">QR Scan Pay</button>
                </div>

                <div id="payment-stage-2" class="payment-stage hidden">
                    <h3>Scan to Pay</h3>
                    <p>Please scan the QR code with your payment app.</p>
                    <div class="qr-code-container">
                        <div class="qr-code-placeholder">
                            QR Code<br/>Placeholder
                        </div>
                    </div>
                    <p class="pulse-text" style="margin-top: 10px;">Waiting for payment...</p>
                </div>

                <div id="payment-stage-3" class="payment-stage hidden">
                    <h3>Verifying Payment</h3>
                    <p>Please wait while we confirm your transaction.</p>
                    <p class="pulse-text">...Verifying...</p>
                </div>
                
                <div id="payment-stage-4" class="payment-stage hidden">
                    <h3>Order Successful!</h3>
                    <p>Your order has been placed and confirmed.</p>
                    <a href="HomePage.html" class="button-link">Back to Home</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // JavaScript to show/hide address fields based on selection
        const addressSelect = document.getElementById('address-select');
        const newAddressFields = document.getElementById('new-address-fields');
        const streetInput = document.getElementById('street');
        const cityInput = document.getElementById('city');
        const postalCodeInput = document.getElementById('postalCode');

        addressSelect.addEventListener('change', function() {
            if (this.value === 'new') {
                newAddressFields.style.display = 'block';
                streetInput.required = true;
                cityInput.required = true;
                postalCodeInput.required = true;
            } else {
                newAddressFields.style.display = 'none';
                streetInput.required = false;
                cityInput.required = false;
                postalCodeInput.required = false;
            }
        });

        // The modal logic from the original prompt is also included here
        const placeOrderBtn = document.getElementById('place-order-btn');
        const paymentModal = document.getElementById('payment-modal');
        const closeModalBtn = document.getElementById('close-modal');
        const qrPayBtn = document.getElementById('qr-pay-btn');
        const form = document.querySelector('form');
        
        const paymentStages = {
            1: document.getElementById('payment-stage-1'),
            2: document.getElementById('payment-stage-2'),
            3: document.getElementById('payment-stage-3'),
            4: document.getElementById('payment-stage-4')
        };
        
        function showPaymentModal() {
            paymentModal.classList.add('visible');
            showStage(1);
        }

        function hidePaymentModal() {
            paymentModal.classList.remove('visible');
            showStage(1);
        }

        function showStage(stageNumber) {
            Object.values(paymentStages).forEach(stage => stage.classList.add('hidden'));
            paymentStages[stageNumber].classList.remove('hidden');
        }

        // Intercept form submission to show the modal instead
        form.addEventListener('submit', function(event) {
            event.preventDefault(); // Prevent the default form submission
            showPaymentModal();
        });

        closeModalBtn.addEventListener('click', hidePaymentModal);
        
        qrPayBtn.addEventListener('click', function() {
            showStage(2);
            // Simulate the payment flow
            setTimeout(() => {
                showStage(3);
                setTimeout(() => {
                    // This is where you would process the order via AJAX
                    // For this example, we'll just show the success page
                    window.location.href = 'order_confirmation.jsp?orderId=12345'; // Example dynamic orderId
                }, 3200); // 3.2-second delay for verification
            }, 15000); // 15-second delay for QR scan simulation
        });
    </script>
</body>
</html>