<%@ Language=VBScript %>
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
</HEAD>
<BODY>
<P>&nbsp;</P>
<%

Response.Write "<br><br>Session Contents:<br>"

For Each Key In Session.Contents
	Response.Write Key & ": " & Session(Key) & "<br>"
Next

Response.Write "<br><br>Application Contents:<br>"
For Each Key In Application.Contents
	Response.Write Key & ": " & Application(Key) & "<br>"
Next

%>	
</BODY>
</HTML>
