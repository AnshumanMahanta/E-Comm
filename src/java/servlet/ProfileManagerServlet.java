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

@WebServlet("/profile-manager")
public class ProfileManagerServlet extends HttpServlet {

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

            if ("update-name".equals(action)) {
                String name = request.getParameter("name");
                if (name != null && !name.trim().isEmpty()) {
                    String updateSql = "UPDATE users SET name = ? WHERE id = ?";
                    stmt = conn.prepareStatement(updateSql);
                    stmt.setString(1, name);
                    stmt.setInt(2, userId);
                    stmt.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle error
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
        
        response.sendRedirect("user-profile.jsp");
    }
}