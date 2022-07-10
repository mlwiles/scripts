<%@ Language=VBScript %> 
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0"> 
</HEAD> 
<BODY> 

<% 
Sub GetFileAndFolderNames(directoryName) 
Dim fileSys, folderName 
Dim folderNames, fileNames 
Dim fileObj, folderObj 

'create a fileSystemObject 
Set fileSys = CreateObject("Scripting.FileSystemObject") 

'Get the folder name of the folder that was passed in 
Set folderName = fileSys.GetFolder(directoryName)

'Make a list of all the files in the folder 
Set fileNames = folderName.Files 

'Make a list of all the subfolders in the folder 
Set folderNames = folderName.SubFolders

'Loop thought all the subfolders and display them
'and also call the GetFileAndFolderNames()to begin recurrsion 

For Each folderObj in folderNames 
	txtfile.WriteLine(directoryName & "\" & folderObj.Name) 
	%><%=directoryName%>\<%=folderObj.Name%><BR><% 
	GetFileAndFolderNames(directoryName & "\" & folderObj.Name) 
Next 

'Loop through all the files and display them
	For Each fileobj in fileNames 
		txtfile.WriteLine(fileObj.Name) 
		%><%=directoryName%>\<%=fileObj.Name%><BR><% 
	Next 
End Sub 
%>

<%
Dim fileSys, txtfile 

Set fileSys = CreateObject("Scripting.FileSystemObject") 
Set txtfile = fileSys.CreateTextFile("c:\temp\.filelist")

'Begins the recurrsive search of folder and all subfolders 
GetFileAndFolderNames("c:\inetpub") 
txtfile.Close 
%> 
</BODY> 
</HTML>
