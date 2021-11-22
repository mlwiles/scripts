<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WFSSDevOps.WebForm1" %>

<!DOCTYPE html>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
   <title>WebForm</title>
   <script language="javascript" type="text/javascript">
      function disable()
      {
         document.getElementById("executeBtn").value="Report Executing...";
         document.getElementById("executeBtn").disabled=true;
         document.body.style.cursor = 'wait';
      }
      function doHourglass()
      {
         document.body.style.cursor = 'wait';
      }
   </script>
</head>
<body onbeforeunload="doHourglass();" onunload="doHourglass();">
   <form id="form1" method="post" runat="server">
      <div>
      <div><h1 align="center">WebForm</h1></div>
      <input type="hidden" name="powershellHdn" id="powershellHdn" runat="server" value="C:\inetpub\wwwroot\next\next.ps1"/> 
      <input type="hidden" name="redirectHdn" id="redirectHdn" runat="server" value="/next/next.aspx"/> 
      <input type="hidden" name="payloadHdn" id="payloadHdn" runat="server" value="{a:1,b:2}"/> 
      <asp:Button id="executeBtn" runat="server" text="Regenerate Report" onclick="Execute"  onclientclick="disable();" usesubmitbehavior="false" />
   </form>
</body>
</html>