CALL J:\pids\config.bat
SET ADEVAL_HOME=J:\bin
SET JAVA_HOME=J:\java
SET ADAPL_SOURCE=J:\pids\src\main\adapl

%ADEVAL_HOME%\adeval %ADAPL_SOURCE%\pidserviceFull
REM SET JAVA_OPTS=-Djavax.net.ssl.trustStore=J:\pids\truststore.jks -Djavax.net.ssl.trustStorePassword=changeit -Denvironment=production
REM %JAVA_HOME%\bin\java %JAVA_OPTS% -cp J:\pids\target\pid-1.0.jar org.rijksmuseum.pid.PidRequests --endpoint %ENDPOINT% --key %WSKEY% --file J:\pids\src\test\dos\pids.xml