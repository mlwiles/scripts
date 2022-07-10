<%
' EXAMPLE 1: GET METHOD

' SET THE FLAG VALUE IF NOT IN THE QUERYSTRING
flag = Request.QueryString("flag")
If flag = "" Then
	flag = 1
End If

' EITHER DISPLAY THE FORM TO GIVE INPUT (CASE 1)
' OR VIEW THE FIELDS PASSED (CASE 2)
Select Case flag
Case 1 %>
<form name='myForm' action='form.asp' method='get'>
	<input type='text' name='car' size='35' value='Fiat'>
	<input type='text' name='car' size='35' value='Porche'>
	<input type='hidden' name='flag' value='2'>
	<input type='submit' value='Submit'>
</form>

<% Case 2
' LOOP THROUGH EACH VALUE AND DISPLAY IT
For each inputField in Request.QueryString
	For each inputValue in Request.QueryString(inputField)
		response.write inputField  & " = " & inputValue & "<br>"
	Next
Next
End Select
%>

<%
' EXAMPLE 2: POST METHOD

flag = Request.Form("flag")
If flag = "" Then
	flag = 1
End If

Select Case flag
Case 1 %>
	<form name='myForm' action='forms.asp' method='post'>
	<input type='text' name='car' size='35' value='Fiat'>
	<input type='text' name='car' size='35' value='Porche'>
	<input type='hidden' name='flag' value='2'>
	<input type='submit' value='Submit'>
</form>

<% Case 2
' LOOP THROUGH EACH VALUE AND DISPLAY IT
For each inputField in Request.Form
	For each inputValue in Request.Form(inputField)
		response.write inputField  & " = " & inputValue & "<br>"
	Next
Next
End Select
%>
