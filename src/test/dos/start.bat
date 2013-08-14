SET ADEVAL_HOME=J:\bin
SET JAVA_HOME=J:\java
cd %ADEVAL_HOME%\adeval
cd J:\pids\src\main\adapl\pidservice
SET JAVA_OPTS=-Denvironment=test -Djavax.net.ssl.trustStore=J:\pids\truststore.jks -Djavax.net.ssl.trustStorePassword=changeit
%JAVA_HOME%\bin\java %JAVA_OPTS% -cp J:\pids\target\pid-1.0.jar org.rijksmuseum.pid.PidRequests --endpoint myUrl --key myKey --file pids.xml >> log.txt