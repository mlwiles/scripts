<%@ Language=VBScript %>
<!--#include FILE="basics.inc" -->

<%
Dim fso
Set fso = Server.CreateObject("Scripting.FileSystemObject")
Dim rootFolder
Set rootFolder = fso.GetFolder(Server.MapPath("/wdt/temp/"))
Dim folder, subFolders
Set subFolders = rootFolder.SubFolders
Dim DBObj
Set DBObj = Session("dbobject")
Dim List
Dim retVal
Dim ObjNew
Dim txtfile, fileSys, strDomainFolder, strDomainName, tmpFolderName

'###########################################################################################
'									MakeFTPList()
'###########################################################################################
Sub MakeFTPList(directoryName) 
	Dim folderName 
	Dim folderNames, fileNames 
	Dim fileObj, folderObj 
	Dim tempName, location

	'Get the folder name of the folder that was passed in 
	Set folderName = fileSys.GetFolder(directoryName)
	'Make a list of all the files in the folder 
	Set fileNames = folderName.Files 
	
	'Loop through all the files and display them
	For Each fileobj in fileNames 
		txtfile.WriteLine(fileObj.Name) 
	Next 
	txtfile.WriteLine("/images")
		
	'Get the folder name of the folder that was passed in 
	Set folderName = fileSys.GetFolder(directoryName & "\images")
	
	'Make a list of all the files in the folder 
	Set fileNames = folderName.Files 
	
	'Loop through all the files and display them
	For Each fileobj in fileNames 
		txtfile.WriteLine(fileObj.Name) 
	Next	
End Sub

'###########################################################################################
'									PutFTP()
'###########################################################################################

Function PutFTP (path)
	Dim Objfso, sFldr, sFile, member, FileType, Temp
	Dim RetVal
	set ObjFso = CreateObject("Scripting.FileSystemObject")
	If Err Then
		PutFTP = 20
		Exit Function
	End If

	If (ObjFso.FolderExists(path)= False) then
		Exit Function
	End IF
			
	set sFldr = ObjFso.GetFolder(path)
	set sFile = sFldr.Files

	'Create the .saved directory for FTP
	Retval = ObjNew.FTPCreateDirectory("/.saved")

	If sFile.Count <> 0 Then
		For each member in sFile
			With ObjNew
				.LocalFile = path & "\" & member.name
				.RemoteFile = "/.saved/" & member.name
			End With		
			
			Temp = member.name
			FileType = GetFileType(Temp)	'function GateFileType called

			If ((FileType = ".gif") OR (FileType = ".jpg") OR (FileType = ".bmp")) then
				ObjNew.Mode = 1				'binary file type transfer mode of COM object
			End If
				
			RetVal = ObjNew.FTPFile()
		Next
	End if
	
	set sFldr = Objfso.GetFolder(Path & "\images")
	set sFile = sFldr.Files
	
	RetVal = ObjNew.FTPCreateDirectory("/.saved/images")
	
	If sFile.Count <> 0 Then
		For each member in sFile
			With ObjNew
				.LocalFile = Path & "\images\" & member.name
				.RemoteFile = "/.saved/images/" & member.name
			End With		
			
			Temp = member.name
			FileType = GetFileType(Temp)	'function GateFileType called

			If ((FileType = ".gif") OR (FileType = ".jpg") OR (FileType = ".bmp")) then
				ObjNew.Mode = 1				'binary file type transfer mode of COM object
			End If
				
			RetVal = ObjNew.FTPFile()
		Next
	End if
	
	'Response.Write RetVal
	If (RetVal <> 12003) then	'the error is 12003, it is ftp server error so needs to ignor
		If (RetVal <> 0)  then
			PutFTP = RetVal 
			Exit Function
		End If
	End If	
End function

'###########################################################################################
'									Main
'###########################################################################################

'Traverse the list of existing temp directories

'Response.Write "<br><br>Folders:<br>"
For Each folder in subFolders
	'Chenck to see if the Application Variable exists
	'if it does not, the get the information from the 
'	If (Application(folder.Name) = "active") Then
'		Response.Write folder.Name & "<br>"
'	Else

	strQuery = "Select username, password, ftpdomain from siteInfo Where ftpdomain = '" & folder.Name & "'"
	Set List = DBObj.Execute(strQuery)

	'open textfile to create a list of files to be copied				
	strDomainName = Server.MapPath("/wdt/temp/" & folder.Name)
	tmpFolderName = "c:\temp"
	
	Set fileSys = CreateObject("Scripting.FileSystemObject")		

	Set txtfile = fileSys.CreateTextFile(tmpFolderName & "\" & folder.Name & ".filelist")
	txtfile.WriteLine("domain=" & folder.Name)
	Response.Write folder.Name & "<BR>"
	
	MakeFTPList(strDomainName)
	txtfile.Close
		
	If (folder.Name = "gatekeeper.org") Then
		retVal = IFTPConnect(List("username"), List("password"), List("ftpdomain"))
		'Response.Write List("username") & "," & List("password") & "," & List("ftpdomain") & "<BR>"
		If retval <> 0 Then
			Response.Write "Error Connecting"
			Response.End
		End If
		
		retVal = PutFTP(strDomainName)
		If retval <> 0 Then
			Response.Write "Error Ftping"
			Response.End
		End If
		
		with ObjNew
			.LocalFile = "c:\temp\" & "gatekeeper.org" & ".filelist"
			.RemoteFile = "/.filelist"
		end with		
		ObjNew.FTPFile()
		
		retVal = IFTPClose()
		'Response.Write "Testing Gatekeeper.org"
		'Response.End
	End If
										
	'If fso.FolderExists(strDomainFolder) Then
	'	fso.DeleteFolder(strDomainFolder)
	'End If
	'Response.Write "FTP & Delete: " & folder.Name & "<br>"
'	End If
Next
        
Set subFolders = Nothing
Set rootFolder = Nothing
Set fso = Nothing
%>