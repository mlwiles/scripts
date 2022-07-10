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
rem javac JavaTOC.java
rem javac  -deprecation ChatBuddies.java 
rem javac ChatLogin.java
rem javac ChatWindow.java
rem javac Chatable.java
javac MyAIM.java
javac AolIMGW.java
@echo off
