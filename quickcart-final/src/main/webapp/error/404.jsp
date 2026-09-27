<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | QuickCart</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

    <!-- Header Navigation -->
    <%@ include file="../includes/header.jsp" %>

    <main class="page-container">
        <div class="empty-state-card" style="max-width: 520px; padding: 60px 24px; margin: 40px auto;">
            <div style="font-size: 64px; margin-bottom: 12px;">🔍</div>
            <h1 style="font-size: 32px; font-weight: 900; color: #0f172a; margin-bottom: 6px;">404 - Page Not Found</h1>
            <p style="font-size: 14px; color: #64748b; line-height: 1.6; margin-bottom: 24px;">
                The grocery item, product or page you are looking for does not exist or has been relocated to another dark store rack.
            </p>
            <div style="display: flex; gap: 12px; justify-content: center;">
                <a href="<%= request.getContextPath() %>/index.jsp" class="btn-primary" style="display: inline-block; width: auto; padding: 12px 24px;">
                    ⚡ Back to Storefront
                </a>
                <a href="<%= request.getContextPath() %>/products" class="btn-action" style="padding: 12px 20px;">
                    Browse Catalog
                </a>
            </div>
        </div>
    </main>

    <!-- Global Footer -->
    <%@ include file="../includes/footer.jsp" %>

</body>
</html>
