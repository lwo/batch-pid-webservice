CALL N:\Collectieinformatie\_Applicatiebeheer\pids\config.bat
SET ADEVAL_HOME=R:\bin
SET JAVA_HOME=N:\Collectieinformatie\_Applicatiebeheer\java
SET ADAPL_SOURCE=N:\Collectieinformatie\_Applicatiebeheer\pids\src\main\adapl

%ADEVAL_HOME%\adeval %ADAPL_SOURCE%\pidserviceIncr
REM SET JAVA_OPTS=-Djavax.net.ssl.trustStore=N:\Collectieinformatie\_Applicatiebeheer\pids\truststore.jks -Djavax.net.ssl.trustStorePassword=changeit -Denvironment=production
REM %JAVA_HOME%\bin\java %JAVA_OPTS% -cp N:\Collectieinformatie\_Applicatiebeheer\pids\target\pid-1.0.jar org.rijksmuseum.pid.PidRequests --endpoint %ENDPOINT% --key %WSKEY% --file N:\Collectieinformatie\_Applicatiebeheer\pids\src\test\dos\pidsincr.xml