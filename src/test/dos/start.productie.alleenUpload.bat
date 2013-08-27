CALL N:\Collectieinformatie\_Applicatiebeheer\pids\config.bat
REM SET ADEVAL_HOME=R:\bin
SET JAVA_HOME=N:\Collectieinformatie\_Applicatiebeheer\java
REM SET ADAPL_SOURCE=N:\Collectieinformatie\_Applicatiebeheer\pids\src\main\adapl

REM %ADEVAL_HOME%\adeval %ADAPL_SOURCE%\pidserviceFull
SET JAVA_OPTS=-Djavax.net.ssl.trustStore=N:\Collectieinformatie\_Applicatiebeheer\pids\truststore.jks -Djavax.net.ssl.trustStorePassword=changeit -Denvironment=production
%JAVA_HOME%\bin\java %JAVA_OPTS% -cp N:\Collectieinformatie\_Applicatiebeheer\pids\target\pid-1.0.jar org.rijksmuseum.pid.PidRequests --endpoint %ENDPOINT% --key %WSKEY% --file N:\Collectieinformatie\_Applicatiebeheer\pids\src\test\dos\pidsincr.xml