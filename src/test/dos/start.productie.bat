CALL N:\Collectieinformatie\pids\config.bat
SET ADEVAL_HOME=R:\bin
SET JAVA_HOME=N:\Collectieinformatie\java
SET ADAPL_SOURCE=N:\Collectieinformatie\pids\src\main\adapl

%ADEVAL_HOME%\adeval %ADAPL_SOURCE%\pidservice
SET JAVA_OPTS=-Djavax.net.ssl.trustStore=N:\Collectieinformatie\pids\truststore.jks -Djavax.net.ssl.trustStorePassword=changeit -Denvironment=production
rem %JAVA_HOME%\bin\java %JAVA_OPTS% -cp N:\Collectieinformatie\pids\target\pid-1.0.jar org.rijksmuseum.pid.PidRequests --endpoint %ENDPOINT% --key %WSKEY% --file N:\Collectieinformatie\pids\src\test\dos\pids.xml