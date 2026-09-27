# QuickCart — JSP + Servlet + JDBC

Clean Option 1 implementation of QuickCart based on the uploaded Google AI Studio project.

## Stack
- Java 17
- JSP
- Jakarta Servlets 6
- JDBC
- MySQL 8+
- Apache Tomcat 10.1+
- Maven

## Architecture
Browser → JSP → Servlet → DAO → JDBC → MySQL

## Demo accounts
- Admin: admin@quickcart.com / admin123
- Customer: lalesh@gmail.com / user123

## Setup
1. Install JDK 17, Maven, MySQL 8+, and Tomcat 10.1+.
2. Create the database by running `database/quickcart.sql` in MySQL.
3. Set optional environment variables if your MySQL credentials differ:
   - QUICKCART_DB_HOST
   - QUICKCART_DB_PORT
   - QUICKCART_DB_NAME
   - QUICKCART_DB_USER
   - QUICKCART_DB_PASSWORD
4. From the project root run `mvn clean package`.
5. Copy `target/quickcart.war` into Tomcat's `webapps` directory.
6. Start Tomcat and open `http://localhost:8080/quickcart/`.

## VS Code
Open the project root (the folder containing `pom.xml`) in VS Code. Use the Maven extension or the integrated terminal.

## Notes
The project keeps the JSP/Servlet/JDBC architecture and reuses the product imagery shipped in the uploaded AI Studio project. React, Vite, Express, and Spring Boot source are intentionally excluded.
