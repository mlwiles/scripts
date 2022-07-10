   
<%@ Language=VBScript %>
<HTML>
<BODY>
<%
Dim objFileScripting, objFolder
Dim filename, filecollection, strDirectoryPath, strUrlPath 
Dim line, txtfile
	strDirectoryPath="c:\inetpub\scripts\"
	strUrlPath="\scripts\"
	
	'get file scripting object
	Set objFileScripting = CreateObject("Scripting.FileSystemObject")

	'Return folder object
	Set objFolder = objFileScripting.GetFolder("c:\inetpub\scripts\")
	
	'return file collection In folder
	Set filecollection = objFolder.Files
	
	'create the links
	'For Each filename In filecollection
	'	Filename=right(Filename,len(Filename)-InStrRev(Filename, "\"))
	'	Response.Write "<A HREF=""" & strUrlPath & filename & """>" & filename & "</A><BR>"
	'Next

	Set txtfile = objFileScripting.OpenTextFile("c:\inetpub\scripts\test.txt")
	Do
		line = txtfile.ReadLine
%>
	<%=line%><br>
<%
	Loop Until txtfile.AtEndOfStream
	txtfile.Close
%>
</BODY>
</HTML>