<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error | QuickCart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/header.jsp" %>

    <main class="page-container">
        <div class="empty-state-card" style="max-width: 520px; padding: 60px 24px; margin: 40px auto;">
            <div style="font-size: 64px; margin-bottom: 12px;">⚠️</div>
            <h1 style="font-size: 28px; font-weight: 900; color: #0f172a; margin-bottom: 6px;">500 - Internal Server Error</h1>
            <p style="font-size: 14px; color: #64748b; line-height: 1.6; margin-bottom: 24px;">
                We encountered an unexpected server or database issue while processing your request. Please ensure MySQL is running and your database password in <code>DBConnection.java</code> is configured.
            </p>
            <div style="display: flex; gap: 12px; justify-content: center;">
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn-primary" style="display: inline-block; width: auto; padding: 12px 24px;">
                    Return to Store
                </a>
            </div>
        </div>
    </main>

    <!-- Global Footer -->
    <%@ include file="../includes/footer.jsp" %>

</body>
</html>
