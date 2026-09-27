# Run QuickCart in VS Code

1. Open this folder in VS Code.
2. Confirm `java -version` shows Java 17+.
3. Confirm `mvn -version` works.
4. Start MySQL and run `database/quickcart.sql`.
5. Configure DB credentials using environment variables if needed.
6. Run:

   mvn clean package

7. Deploy `target/quickcart.war` to Apache Tomcat 10.1+.
8. Start Tomcat.
9. Browse to:

   http://localhost:8080/quickcart/

The application uses Jakarta Servlet APIs, so use Tomcat 10.1+ rather than Tomcat 9.
