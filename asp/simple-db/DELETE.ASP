<%@ Language=VBScript %>
<%
'Store the variable to name. txtnameadd is the text box in index.htm
'If you study the HTML code of it you will understand
'Request.form function request the value from the form.
name = server.HtmlEncode(request.form("txtnamedel")) 

'Create object. In this case Connection to a database
Set Conn = Server.CreateObject("ADODB.Connection")

'Select provider
Conn.Provider = "Microsoft.Jet.OLEDB.4.0"
'Select data source.
'Server.MapPath function is equivalent to app.path function of VB
'It returns the directory in which the script is present
Conn.ConnectionString = "Data Source=" & Server.MapPath ("data.mdb")
'Open the connection
Conn.Open

'Create recordset
Set Rs = Server.CreateObject("ADODB.Recordset")
'Open recordset with the connection which we have created earlier
'you must be familiar with SELECT statement ,
'If not check my VB tutorial section.
Rs.Open "SELECT * from users", Conn, 1,3

'Loop thru records
do while not rs.EOF 
if Rs("name") = name then Rs.Delete  ' if it's = name then delete
rs.MoveNext ' Movenext
loop

'Deinitialize the Connection and Recordset
set Rs = nothing
set Conn = nothing
%>
<p>User Successfully Deleted</p>
<p><a href="index.htm">Return to Index</a></p>
