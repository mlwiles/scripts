<%@ Language=VBScript %>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
</HEAD>
<BODY>

<%
    Dim fileSys, drv, f1, s, rootdir, rootfiles, fileObj, drivelet
    drivelet = "c:"
    Set fileSys = CreateObject("Scripting.FileSystemObject")
    'Get the drive object based on the drive letter
    Set drv = fileSys.GetDrive(drivelet)
    'Get the drives root folder
    Set rootdir = drv.RootFolder
    'Get the files in the root folder
    Set rootfiles = rootdir.Files
    'Loop through all the files and display them
    For Each fileobj in rootfiles
%>
<%=fileobj.Name%>
<p>
<%
    Next
%>

<P>&nbsp;</P>
</BODY>
</HTML>