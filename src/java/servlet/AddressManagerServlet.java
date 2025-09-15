package servlet;

import util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/address-manager")
public class AddressManagerServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user_id") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("user_id");
        String action = request.getParameter("action");
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBConnection.getConnection();

            switch (action) {
                case "add":
                    String addSql = "INSERT INTO addresses (user_id, street_address, city, postal_code) VALUES (?, ?, ?, ?)";
                    stmt = conn.prepareStatement(addSql);
                    stmt.setInt(1, userId);
                    stmt.setString(2, request.getParameter("street_address"));
                    stmt.setString(3, request.getParameter("city"));
                    stmt.setString(4, request.getParameter("postal_code"));
                    stmt.executeUpdate();
                    break;
                case "update":
                    String updateSql = "UPDATE addresses SET street_address = ?, city = ?, postal_code = ? WHERE id = ? AND user_id = ?";
                    stmt = conn.prepareStatement(updateSql);
                    stmt.setString(1, request.getParameter("street_address"));
                    stmt.setString(2, request.getParameter("city"));
                    stmt.setString(3, request.getParameter("postal_code"));
                    stmt.setInt(4, Integer.parseInt(request.getParameter("address_id")));
                    stmt.setInt(5, userId);
                    stmt.executeUpdate();
                    break;
                case "delete":
                    String deleteSql = "DELETE FROM addresses WHERE id = ? AND user_id = ?";
                    stmt = conn.prepareStatement(deleteSql);
                    stmt.setInt(1, Integer.parseInt(request.getParameter("address_id")));
                    stmt.setInt(2, userId);
                    stmt.executeUpdate();
                    break;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
        
        response.sendRedirect("user-profile.jsp");
    }
}