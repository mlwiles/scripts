@echo off
setlocal
cls

rem -----------------------------------------------------------------
rem Environment setup
rem -----------------------------------------------------------------

rem Check for the INS Home directory
if not defined INS_HOME (goto ins_error)

set insclasspath=%INS_HOME%
set insclasspath=%insclasspath%;%INS_HOME%\bin
set insclasspath=%insclasspath%;%INS_HOME%\lib\ins.jar
set insclasspath=%insclasspath%;%INS_HOME%\lib\insMsgs.jar

set classpath=%insclasspath%;%classpath%

rem -----------------------------------------------------------------
rem Create the SMS delivery channel
rem -----------------------------------------------------------------

@echo on
java com.ibm.pvc.we.ins.util.CreateSmsDeliveryChannel %1 %2 %3 %4
@echo off
goto :end

:ins_error
   echo.
   echo INS_HOME environment variable is not set
   goto :end

:end
   endlocal

