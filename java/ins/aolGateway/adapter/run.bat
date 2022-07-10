@echo off
setlocal
cls

set PATH=c:\progra~1\IBM\Java131\jre\bin;c:\progra~1\IBM\Java131\bin;%PATH%
set JAVA_HOME=C:\Progra~1\IBM\Java131\
set myclasspath=%JAVA_HOME%\lib\dt.jar
set myclasspath=%myclasspath%;.
set myclasspath=%myclasspath%;D:\_notes\INS\r22-Source\lib\ins.jar
set myclasspath=%myclasspath%;%JAVA_HOME%\lib\tools.jar
set myclasspath=%myclasspath%;%JAVA_HOME%\jre\lib\rt.jar
set classpath=%myclasspath%;%classpath%

@echo on
java MyAIM chezlovr hombre mikelwiles test
rem java AolIMGW
@echo off
