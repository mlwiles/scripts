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

Function IFTPConnect(user, pwd, domain_name)
	'On Error Resume Next
	Dim RetVal
	set ObjNew = CreateObject("AITPublisher.FTPObj")	'creates the new object
	If err Then
		IFTPconnect = 10
		Exit Function
	End If

	With ObjNew
		.ServerName = domain_name
		.Password = pwd
		.UserName = user
	End With	
		
	RetVal = ObjNew.FTPConnect	'makes the connection to the server
	If (RetVal <> 0) then
		IFTPConnect = RetVal
		'Response.Write "Can not establish connection to the server. Try later."
		'Response.End 
		Exit Function
	end if
	CurrentDir = ""
	IsHome = 1	'initializes the directory to positive number	
End Function

Function IFTPClose()
	ObjNew.FTPClose()	'Closes the connection
	set ObjNew = nothing
End function

Function IFTP (path)
	Dim Objfso, sFldr, sFile, member, FileType, Temp
	Dim RetVal
	set ObjFso = CreateObject("Scripting.FileSystemObject")
	if err then
		IFTP = 20
		Exit Function
	End If

	If (ObjFso.FolderExists(path)= False) then
		Exit Function
	End IF
		
	set sFldr = ObjFso.GetFolder(path)
	set sFile = sFldr.Files
	set SubFldr = sFldr.SubFolders

	If SubFldr.Count <> 0 Then
		For each SubFolder in SubFldr
			IsHome = IsHome + 1			' will increment the file
			CurrentDir = SubFolder.name
			RetVal = ObjNew.FTPCreateDirectory(CurrentDir)
			'Response.Write RetVal
			If (RetVal <> 12003) then	'the error is 12003, it is ftp server error so needs to ignor
				If (RetVal <> 0)  then
				   IFTP = RetVal 
				   Exit Function
				End If
			End If
			IFTP(SubFolder)
		Next
	End If
				
	IsHome = IsHome - 1	' will decrement until it is 0

	If (IsHome = 0) then
		CurrentDir = ""
	End If
		
	If sFile.Count <> 0 Then
		For Each member in sFile
			With ObjNew
				.LocalFile = Path & "\" & member.name
				.RemoteFile = CurrentDir & "/" & member.name
			End With		
			
			Temp = member.name
			FileType = GetFileType(Temp)	'function GateFileType called
			If ((FileType = ".gif") OR (FileType = ".jpg") OR (FileType = ".bmp")) then
				ObjNew.Mode = 1				'binary file type transfer mode of COM object
			End If
				
			RetVal = ObjNew.FTPFile()
			If (RetVal <> 0) then
				IFTP = RetVal
				Exit Function
			End If
		Next
	End if
End function

'The following function will parse the file extension and pass to the caller
Function GetFileType(Temp)					'Temp is file name
	Dim tempName, K, FileExtension 
	tempName = Trim( Temp )
	K = InStrRev(tempName, ".", len(tempName), 0)
	FileExtension = Right( tempName, (len(tempName) - K + 1) )
	GetFileType = FileExtension
End Function

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