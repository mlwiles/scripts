<%@ Language=VBScript %>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
</HEAD>
<BODY>

<%
	Sub GetFileAndFolderNames(directoryName)
		Dim fileSys, folderName, folderNames, fileNames, fileObj, folderObj
		'create a fileSystemObject
		Set fileSys = CreateObject("Scripting.FileSystemObject")
		'Get the folder name of the folder that was passed in
		Set folderName = fileSys.GetFolder(directoryName)
		'Make a list of all the files in the folder
		Set fileNames = folderName.Files
		'Make a list of all the subfolders in the folder
		Set folderNames = folderName.SubFolders
		
		'Loop thought all the subfolders and display them
		'and also call the GetFileAndFolderNames() to begin recurrsion
		For Each folderObj in folderNames
			GetFileAndFolderNames(directoryName & "\" & folderObj.Name)
			%>
			<%=directoryName%>\<%=folderObj.Name%><br>
			<%
		Next
		
		'Loop through all the files and display them
		For Each fileobj in fileNames
			%>
			<%=directoryName%>\<%=fileObj.Name%><br>
			<%
		Next
	End Sub
%>

<%
	'Begins the recurrsive search of folder and all subfolders
	GetFileAndFolderNames("c:\inetpub")
%>

<P>&nbsp;</P>
</BODY>
</HTML>