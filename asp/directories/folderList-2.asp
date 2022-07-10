<HTML>
<HEAD>
<SCRIPT>
<!--//hide from old browsers

var howLong = 10000;
t = null;
function closeMe(){
	//t = setTimeout("self.close()",howLong);
	t = window.setTimeout("close()",10000);
}

//-->
</SCRIPT>
</HEAD>
<BODY onload="closeMe()">
</BODY>
</HTML>

<%@ Language=VBScript %>
<!--#include FILE="basics.inc" -->
<%
Dim fso
Set fso = Server.CreateObject("Scripting.FileSystemObject")
Dim rootFolder
Set rootFolder = fso.GetFolder(Server.MapPath("temp/"))
Dim subFolders
Set subFolders = rootFolder.SubFolders
Dim DBObj
Set DBObj = Session("dbobject")
Dim List
Dim retVal
Dim ObjNew
	
'Traverse the list of existing temp directories

'Response.Write "<br><br>Folders:<br>"
For Each folder in subFolders
	'Chenck to see if the Application Variable exists
	'if it does not, the get the information from the 
	If (Application(folder.Name) = "active") Then
		'Response.Write folder.Name & "<br>"
	Else
		strQuery = "Select username, password, ftpdomain from siteInfo Where ftpdomain = '" & folder.Name & "'"
		Set List = DBObj.Execute(strQuery)
		'Response.Write List("username") & "<br>"
		'Response.Write List("password") & "<br>"

		strDomainFolder = Server.MapPath("/wdt/temp/" & folder.Name)

		retVal = IFTPConnect(List("username"), List("password"), List("ftpdomain"))
		retVal = IFTP(strDomainFolder)
		retVal = IFTPClose()
								
		If fso.FolderExists(strDomainFolder) Then
			fso.DeleteFolder(strDomainFolder)
		End If
		'Response.Write "FTP & Delete: " & folder.Name & "<br>"
	End If
Next
   
Set subFolders = Nothing
Set rootFolder = Nothing
Set fso = Nothing

'Response.Write "<br><br>Session Contents:<br>"

'For Each Key In Session.Contents
'	Response.Write Key & ": " & Session(Key) & "<br>"
'Next

'Response.Write "<br><br>Application Contents:<br>"
'For Each Key In Application.Contents
'	Response.Write Key & ": " & Application(Key) & "<br>"
'Next
%>      