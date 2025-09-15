package servlet;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Do not create a new session if one doesn't exist
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("login.jsp");
    }
}