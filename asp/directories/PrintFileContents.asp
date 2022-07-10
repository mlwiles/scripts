<%@ Language=VBScript %>
<HTML>
<BODY>
<%
Dim objFileScripting
Dim filename, txtfile, fileone, filetwo
Dim domainName
Dim retval 
domainName = "domain.com"

'get file scripting object
Set objFileScripting = CreateObject("Scripting.FileSystemObject")

'make the destination folder
'objFileScripting.CreateFolder("c:\inetpub\scripts\" & domainName)

'open the file and print out the contents
Set txtfile = objFileScripting.OpenTextFile("c:\inetpub\scripts\test.txt")
Do
	filename = txtfile.ReadLine										  
	'retval = objFileScripting.CopyFile ("c:\inetpub\scripts\fileone.txt", "c:\inetpub\scripts\domain.com\fileone.txt")		
	fileone = "c:\inetpub\scripts\" & filename
	Response.Write fileone & "<BR>"
	filetwo = "c:\inetpub\scripts\" & domainName & "\" & filename  								  
	Response.Write filetwo & "<BR>" 

	retval = objFileScripting.CopyFile (fileone, filetwo)
	'Response.Write "objFileScripting.CopyFile (c:\inetpub\scripts\" & filename &  ", c:\inetpub\scripts\" & domainName & "\" & filename &")<br>"
%>
<%=filename%><BR>
<%
Loop Until txtfile.AtEndOfStream
txtfile.Close
%>
</BODY>
</HTML>