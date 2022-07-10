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
Dim txtfile
	
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
		'open textfile to create a list of files to be copied
		Set txtfile = objFileScripting.OpenTextFile("/wdt/temp/" & folder.Name & ".ftpfilelist")
		'Response.Write List("username") & "<br>"
		'Response.Write List("password") & "<br>"

		strDomainFolder = Server.MapPath("/wdt/temp/" & folder.Name)

		retVal = IFTPConnect(List("username"), List("password"), List("ftpdomain"))
		retVal = IFTP(strDomainFolder)
		'close the textfiles
		txtfile.Close
		'ftp the textfile to the domain folder
		SendFileList("/wdt/temp/" & folder.Name, ".ftpfilelist")
	
		'If fso.FolderExists(strDomainFolder) Then
		'	fso.DeleteFolder(strDomainFolder)
		'End If
		'Response.Write "FTP & Delete: " & folder.Name & "<br>"
	End If
Next
	
Set subFolders = Nothing
Set rootFolder = Nothing
Set fso = Nothing
%>