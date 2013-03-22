SET ADEVAL_HOME=J:\bin
SET JAVA_HOME=J:\java

%ADEVAL_HOME%\adeval J:\pids\src\main\adapl\pidservice
%JAVA_HOME%\bin\java -Denvironment=test -cp J:\pids\target\pid-1.0.jar org.rijksmuseum.pid.PidRequests --endpoint myUrl --key myKey --file pids.xml >> log.txt