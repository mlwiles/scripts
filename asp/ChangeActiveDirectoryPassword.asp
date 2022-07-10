<%@ LANGUAGE=VBScript %>
<!--#include FILE = "header.inc"-->

<%
    'On Error Resume Next
    Dim sSearchFilter
    Dim com, rs
    Dim oConnect
    Dim oCommand
    Dim oRecordset
    Dim RootDSEPath
    Dim MyDSEObj
    Dim ADsUserObj
    submit = Request("submit")
    If (NOT submit=1) Then 
%>
    <Script Language="JavaScript">
    function ValidName(tmpName)
    {
        var tempChar;
        var illegalChar = "~`!#^*()+=|\"\';<>,?{}[]";
        tmpName = tmpName.toLowerCase();
        for (var i = 0; i < tmpName .length; i++) {
            tempChar = tmpName.charAt(i)
            if (illegalChar.indexOf(tempChar) != -1)
                return false;
            }

        return true;
    }
    
    function SpaceInName(tmpName)
    {
        for (var i = 0; i < tmpName .length; i++) {
            if (tmpName.charAt(i) ==' ')
                return false;
            }
        return true;
    }

    function pswCheck() 
    {
        if (ValidName(document.passwordfrm.password.value) == false)
        {
            alert("Name Invalid, try again.");
            document.passwordfrm.password.value = "";
            document.passwordfrm.password2.value = "";
            document.passwordfrm.password.focus();                
            return false;
        }
        if (SpaceInName(document.passwordfrm.password.value) == false)
        {
            alert("No spaces allowed.");
            document.passwordfrm.password.value = "";
            document.passwordfrm.password2.value = "";
            document.passwordfrm.password.focus();                
            return false;
        }
        if (document.passwordfrm.password.value.length == 0) {
            alert ("Passowrd cannot be empty.");
            document.passwordfrm.password.value = "";
            document.passwordfrm.password2.value = "";
            document.passwordfrm.password.focus();
            return false;
        }
        if ((document.passwordfrm.password.value) != (document.passwordfrm.password2.value)) {
            alert ("Passwords do not match.");
            document.passwordfrm.password.value = "";
            document.passwordfrm.password2.value = "";
            document.passwordfrm.password.focus();
            return false;
        }
        return true;
    }
    </Script>
    <form name="passwordfrm" action=default.asp?submit=1 method="post">
        New Password <INPUT type="password" name=password> 
        Confirm Password <INPUT type="password" name=password2> 
        <INPUT type="submit" value="Log In" onClick="return pswCheck();"> 
    </form>
<%
    Else
        username = Request.ServerVariables("AUTH_USER")
        username = Replace(username,"DOMAIN\","") 
        password = Trim(Request("password"))
            
        RootDSEPath = ""
        Set MyDSEObj = GetObject("LDAP://RootDSE")
        RootDSEPath = MyDSEObj.Get("defaultNamingContext")
        Set oConnect = CreateObject("ADODB.Connection")
        oConnect.Provider = "ADsDSOObject"
        oConnect.Open "DS Query"
        
        Set oCommand = CreateObject("ADODB.Command")
        Set oCommand.ActiveConnection = oConnect
        oCommand.CommandText = "SELECT * FROM 'LDAP://"&RootDSEPath&"' WHERE sAMAccountName='"&username&"'"
        Set oRecordset = oCommand.Execute
        
        Set ADsUserObj = GetObject(oRecordSet("ADsPath"))
        ADsUserObj.SetPassword  password

        If (err.number <> 0) Then
            Response.write "Failed To Update Password"
        Else
            Response.Write "Success Updating password"
        End if

    End If 
%>
<!--#include FILE = "footer.inc"-->