<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = -1 %>

<%
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Const TristateUseDefault = -2, TristateTrue = -1, TristateFalse = 0

FUNCTION readConfig()
	set objFSO = server.createObject("Scripting.FileSystemObject")
	Dim Filepath, file, workPage

	textfile = Session("txtfile")
	Filepath = Server.MapPath("/wdt/temp/"&Session("domain")&"/"&textfile)

	IF objFSO.FileExists(Filepath) THEN
		Set file = objFSO.OpenTextFile(Filepath, ForReading, False, TristateUseDefault)
		i = 0
		Dim Contents
		'Skip first line b/c it doesn't like the beginning asp code
		file.SkipLine
		readConfig = file.ReadAll
		file.Close
		Set file = nothing
	ELSE
		fileError(Filepath)
	END IF
	
	IF Session("toolflag") <> "publish" THEN
		Set file = objFSO.GetFile(Filepath)
		If objFSO.FileExists(file) Then
			file.Delete
		End If
		Set objFSO = nothing
	END IF
END FUNCTION

FUNCTION copyDefaultPageText(pageArray)
	'This function copies the defaulttext for the page selected to the users directory so they can modify it

	i = 0
	Dim strfileName
	WHILE i <= num
		Set objfso = CreateObject("Scripting.FileSystemObject")

		'Copy the default text file to the user's working directory
		pageArray(i) = Trim(pageArray(i))		

		strPhysicalPath = Server.MapPath(siteType&"/common/defaulttext" & pageArray(i))
		strDestPath = Server.MapPath("temp/"&domain&"/defaulttext" & pageArray(i))

		If Not(objfso.FileExists(strDestPath)) Then
			IF Not(objfso.FileExists(strPhysicalPath)) THEN
				fileError(strPhysicalPath)
			ELSE
				objfso.CopyFile strPhysicalPath, strDestPath
			END IF
		End If
		i = i+1
	WEND
	Set objfso = Nothing
END FUNCTION

FUNCTION addLinks(pageArray)
	'This function adds the links to the default text file to the other pages in the website
	Set objFSO = server.createObject("Scripting.FileSystemObject")
	Filepath = Server.MapPath("temp/"&session("domain"))
	Filepath = Filepath & "/" & Session("txtfile")
	Set tf = objFSO.CreateTextFile(Filepath, ForWriting, False)
	i = 1	
	tf.WriteLine("<%")
	Dim tempPage
	n = 0
	loc = Session("begLinkLoc")
	lineWrittenFlag = 0
	curPageFlag = 0
	'Limit is the amount of lines in the configuration file, read through line by line
	WHILE i <= limit
		'split the line by the = sign 
		line = Split(ContArray(i), " = ", -1, 1)
		IF n <= num THEN
			pageArray(n) = LTrim(pageArray(n))
			'Make sure the line is a designate link -- loc is specified in global.asa	
			IF (StrComp(line(0), "location"&loc&""")") = 0) THEN
				line(0) = "Session("""&line(0)& " = "
				'Check to see if the txtfile is the current page (don't add a link if it is)
				tempFile = "defaulttext" & pageArray(n)
				If Trim(Session("txtfile")) <> Trim(tempFile) Then
					line(1) = """<a href=""""/wdt/tempframe.asp?pageflag=3&page="&pageArray(n)&""""" target='_top'>"""
				Else
					line(1) = """"""
					curPageFlag = 1
				End If
				ContArray(i) = Join(line)
				tf.WriteLine(ContArray(i))
				lineWrittenFlag = 1
			ELSE
				'Check to see if the line is the link description
				If StrComp(line(0), "location"&loc&".1"")") = 0 Then
					If InStr(pageArray(n), ".asp") = 0 Then
						Response.write "pageArray Error -- " & pageArray(n)
						response.end
					End If
					tempPage = Split(pageArray(n), ".asp")
						
					If curPageFlag = 0 Then
						tf.WriteLine("Session(""location"&loc&".1"") = """&tempPage(0)&"</a>""")
					Else
						curPageFlag = 0
						tf.WriteLine("Session(""location"&loc&".1"") = ""<B>"&tempPage(0)&"</B>""")
					End If
					n = n + 1
					linkCheckFlag = 0
					loc = loc + 1
					lineWrittenFlag=1
				Else
					line(0) = "Session("""&line(0)& " = "
					line(1) = ""&line(1)&""
					ContArray(i) = Join(line)
				End IF
			END IF
		ELSE
			line(0) = "Session("""&line(0)& " = "
			line(1) = ""&line(1)&""
			ContArray(i) = Join(line)
		END IF

		IF lineWrittenFlag = 0 THEN
			IF i = limit THEN
				endASP = Split(ContArray(i), "%", -1, 1)
				tf.Write(endASP(0))
			ELSE
				tf.Write(ContArray(i))
			END IF
		ELSE
			lineWrittenFlag = 0
		END IF

		i = i + 1
	WEND
	IF i = limit THEN
		endaspflag = 1
	END IF

	tf.Write "%\>"
	tf.close
	set tf = nothing
	set objFSO = nothing
END FUNCTION

FUNCTION deleteLink()
	Set objFSO = server.createObject("Scripting.FileSystemObject")
	Filepath = Server.MapPath("temp/"&domain)
	Filepath = Filepath&"/" & Session("txtfile")
	Set tf = objFSO.CreateTextFile(Filepath, ForWriting, False)
	i = 1	
	tf.WriteLine("<%")

	linkFlag = 1
	DO WHILE i <= limit
		pagePos = Instr(1, ContArray(i), page, 1)

		'here we need to delete the link and the description from the file
		IF (pagePos <> "0" or linkFlag = 1) THEN
			line = Split(ContArray(i), " = ", -1, 1)
			line(0) = line(0)&" = "

			If linkFlag = 1 Then
				linkFlag = 0
			End If
			
			If pagePos <> "0" Then
				IF IsNumeric(Right(line(0), 1)) = FALSE THEN
					loc = Left(line(0), 9)
				ELSE 
					loc = Left(line(0), 10)
				END IF
				linkFlag = 1
			End If
			
			line(1) = """"""
			ContArray(i) = Join(line)
			ContArray(i) = "Session("""&ContArray(i)
			tf.WriteLine(ContArray(i))
		Else
			ContArray(i) = "Session("""&ContArray(i)

			IF i = limit THEN
				endASP = Split(ContArray(i), "%", -1, 1)
				tf.Write(endASP(0))
			ELSE
				tf.Write(ContArray(i))
			END IF

		END IF
		i = i + 1
	LOOP

	tf.Write "%\>"
	tf.close
	set tf = nothing
	set objFSO = nothing
END FUNCTION

FUNCTION fileError(file)
	Response.Write "<h3><i><font color=red> File " & file & " does not exist</font></i></h3>"
	Response.End
END FUNCTION

FUNCTION flagError(flag)
	Response.Write "Invalid filetype="&flag
	Response.End
END FUNCTION

FUNCTION updateConfig(newData)
	Contents = readConfig()

	Dim ContArray, limit, line, locvar, endaspflag, origloc
	i = 1
	endaspflag = 0
	'Take the string apart for easy handling
	ContArray = Split(Contents, "Session(""", -1, 1)
	limit = UBound(ContArray, 1)
	
	If toolflag="link" Then
		n = Session("begLinkLoc")
		While n <= CInt(Session("templateLimit")) + n
			If loc = n Then
				'Need to check if this was originally a link
				'If it was we need to add the desc to loc.1
				linkIt = "yes"
			End If
			n = n + 1
		Wend
	End If

	locvar = "Session("""&loc&""")"
	origloc = Session("origloc")
	origlocvar = "Session("""&origloc&""")"

	IF toolflag = "link" And linkIt = "yes" THEN
		Dim temp, descloc
		temp = Split(newData, ">", -1, 1)
		newData = temp(0) & ">"
		desc = temp(1)&"</a>"
		descloc = loc&".1"
		descloc = "Session("""&descloc&""")"
	Else
		If toolflag = "link" Then
			newData = newData & "</a>"
		End IF
	END IF

	set objFSO = server.createObject("Scripting.FileSystemObject")
	Filepath = Server.MapPath("temp/"&domain&"/"&txtfile)
	Set file = objFSO.CreateTextFile(Filepath, ForWriting, False)
	file.WriteLine("<%")
	writeLineFlag = 0

	Do While i <= limit
		ContArray(i) = "Session("""&ContArray(i)
		line = Split(ContArray(i), " = ", -1, 1)
		IF toolflag = "move" THEN 'Remove the data from the original location
			IF StrComp(line(0), origlocvar) = 0 THEN
				line(1) = """"""
				writeLineFlag = 1
            End If
		End If

		IF StrComp(line(0), locvar) = 0  THEN
			IF i = limit THEN
				endaspflag = 1
			END IF
	
			line(0) = line(0)& " = "
			line(1) = """"&newData&"""" 
			ContArray(i) = Join(line)
			file.WriteLine(ContArray(i))
	
			IF toolflag = "link" And linkIt = "yes" THEN
				IF i = limit THEN
					endaspflag = 1
				END IF
				line(0) = descloc& " = "
				line(1) = """"&desc&"</a>""" 
				ContArray(i) = Join(line)
				file.WriteLine(ContArray(i))
			END IF

		ELSE
			line(0) = Trim(line(0))& " = "
			ContArray(i) = Join(line)
			If writeLineFlag = 0 Then
				File.Write(ContArray(i))
			Else 
				File.WriteLine(ContArray(i))
			End If
		End IF
		i = i + 1
	LOOP

	'Put the string back together
	IF endaspflag = 1 THEN
		file.Write("%\>")
	END IF
	file.Close

	Set file = nothing
	Set objFSO = nothing
	session("button") = "edit.gif"
END FUNCTION

FUNCTION readHTML(index)
	strTempfile = index
	siteType = Session("siteType")

	set objFSO = server.createObject("Scripting.FileSystemObject")
	Dim Filepath, file, workPage

	Filepath = Server.MapPath("/wdt/" & siteType & "/" & session("index") & "/" & strTempfile)

	IF objFSO.FileExists(Filepath) THEN
		Set file = objFSO.OpenTextFile(Filepath, ForReading, False, TristateUseDefault)
		i = 0
		Dim Contents
		readHTML = file.ReadAll
		file.Close
		Set file = nothing
	ELSE
		fileError(Filepath)
	END IF

END FUNCTION

FUNCTION getPages()
	Set fso = CreateObject("Scripting.FileSystemObject")
	strPhysicalPath = Server.MapPath("/wdt/temp/" & Session("domain"))

	Set objPages = FSO.GetFolder(strPhysicalPath)
	Set objPagesContents = objPages.Files

	j = 0
	For Each objFileItem In objPagesContents
		Redim Preserve Linename(j)
		line = objFileItem.Name
					
		'line = Split(line, "text")
		'tempLine = Split(line(1), ".asp")
					
		Linename(j) = trim(line)
		j = j + 1
	Next
	
	getPages = Linename
	
	Set fso = Nothing
	Set objPages = Nothing
	Set ObjPagesContents = Nothing	
END FUNCTION

Function IFTPConnect(user, pwd, domain_name)
	'On Error Resume Next
	Dim RetVal
	set ObjNew = CreateObject("MyPublisher.FTPObj")	'creates the new object

	if err then
		IFTPconnect = 10
		Exit Function
	end if
	with ObjNew
		.ServerName = domain_name
		.Password = pwd
		.UserName = user
	end with	
	
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
	ObjNew.FTPClose()									'Closes the connection
	set ObjNew = nothing
End function

Function IFTP (path)
	Dim Objfso, sFldr, sFile, member, FileType, Temp
	Dim RetVal
	set ObjFso = CreateObject("Scripting.FileSystemObject")
	if err then
		IFTP = 20
		Exit Function
	end if
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
			txtfile.WriteLine("directory=" & SubFolder.Name)
			RetVal = ObjNew.FTPCreateDirectory(CurrentDir)
			
			'Response.Write RetVal
			If (RetVal <> 12003) then	'the error is 12003, it is ftp server error so needs to ignor
				If (RetVal <> 0)  then
				   IFTP = RetVal 
				   Exit Function
				end if
			end if
			IFTP(SubFolder)
		Next
	end if
				
	IsHome = IsHome - 1			' will decrement until it is 0
	If (IsHome = 0) then
		CurrentDir = ""
	end if
		
	If sFile.Count <> 0 Then
		For each member in sFile
			with ObjNew
				.LocalFile = Path & "\" & member.name
				txtfile.WriteLine(Path & "\" & member.name)
				.RemoteFile = CurrentDir & "/" & member.name
			end with		
			
			Temp = member.name
			FileType = GetFileType(Temp)	'function GateFileType called
			If ((FileType = ".gif") OR (FileType = ".jpg") OR (FileType = ".bmp")) then
				ObjNew.Mode = 1				'binary file type transfer mode of COM object
			end if
				
			RetVal = ObjNew.FTPFile()
			If (RetVal <> 0) then
				IFTP = RetVal
				Exit Function
			end if
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

Function SendFileList(Path, filelist)
	with ObjNew
		.LocalFile = Path & "\" & filelist
		.RemoteFile = "/" & filelist
	end with
	
	RetVal = ObjNew.FTPFile()
End Function
%>