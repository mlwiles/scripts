<HTML>
<HEAD>
	<TITLE>Build a Custom Quote</TITLE>
<!--#include file="header.txt"-->
	<TR>
	<TD VALIGN=TOP ALIGN=LEFT>
	<B><FONT FACE="Verdana, Arial, Helvetica, sans-serif" size=-1><BR>Building a Custom Quote</FONT></B> <BR>
	<HR SIZE=2>
	<TABLE BORDER=0>
	<TR>
		<TD ALIGN=LEFT VALIGN=TOP>

<%
	'This is the initial entry point for a customer to pick which server they want 
	If Request.Querystring("next") = "" then
	Instructions	=	"Please select the server that you wish to use for this quote."
%>
			<FORM ACTION="?next=components" METHOD="post">
			<TABLE BORDER=0 BGCOLOR="#EEEEEE" CELLPADDING=1 CELLSPACING=1>

			<TR BGCOLOR="#EEEEEE">
				<TD COLSPAN=3 VALIGN="middle"><FONT FACE=ARIAL COLOR="#000000">BASIC HARDWARE - </FONT><FONT FACE=ARIAL COLOR="#FF0000">Required</FONT>	</TD>
			</TR>

			<!--#include file="webuser.txt"-->
			<%
			Set rs=Server.CreateObject("adodb.Recordset")
			sqlstmt = "SELECT * from hardware_cases"
			rs.open sqlstmt, connect
			Do while not rs.eof
				ID			=	rs("ID")
				displayname	=	rs("displayname")
				imagename	=	rs("imagename")
				%>
				<TR BGCOLOR="#FFFFFF">
					<TD ALIGN=LEFT><INPUT TYPE=RADIO NAME="server_type" VALUE="<%= ID %>"></TD>
					<TD><FONT FACE=ARIAL COLOR="#000000"><%= displayname %></FONT></TD>
					<TD ALIGN=LEFT VALIGN=TOP><IMG SRC="/images/<%= imagename %>"></TD>
				</TR>
				<%
				rs.MoveNext
			Loop
			
			rs.Close
			Set rs=Nothing
			%>
			</TABLE>
	<BR>
	<BR>
	<INPUT STYLE="color: white;border-color: #FF0000; background-color: #990000;font-weight: 700;" TYPE="submit" VALUE="Continue >>" />
<%
	Else If (request.querystring("next") = "components") then
	server_type	    =	request.form("server_type")
	instructions	=	"On this screen, please select the options you wish to have for your quote.  The options are specific to the hardware that you selected on the previous screen."
%>
			<FORM ACTION="?next=calculate" METHOD="post">
			<INPUT TYPE=HIDDEN NAME="server_type" VALUE="<%= server_type %>">
			<TABLE BORDER="0" BGCOLOR="#EEEEEE" CELLSPACING="1" CELLPADDING="1">
			<TR BGCOLOR="#EEEEEE">
				<TD COLSPAN=2><FONT FACE=ARIAL COLOR="#000000"> OPERATING SYSTEM - </FONT>
				<FONT FACE=ARIAL COLOR="#FF0000">Required</FONT></TD>
			</TR>
	
			<TR BGCOLOR="#FFFFFF">
				<TD COLSPAN=2><SELECT NAME="OS">
				<OPTION SELECTED VALUE="">-- SELECT OS --</OPTION>
			<!--#include file="webuser.txt"-->
			<%
			Set rs=Server.CreateObject("adodb.Recordset")
			sqlstmt = "SELECT * from hardware_os order by displayname"
			rs.open sqlstmt, connect

			Do while not rs.eof
				ID		=	rs("ID")
				displayname	=	rs("displayname")
				%>
				<OPTION VALUE="<%= ID %>"><%= displayname %></OPTION>
				<%
				rs.MoveNext
			Loop

			rs.Close
			Set rs=Nothing
			%>
			</SELECT><BR><BR></TD>
			</TR>

			<TR BGCOLOR="#EEEEEE">
				<TD COLSPAN=2><FONT FACE=ARIAL COLOR="#000000">PROCESSOR SPEED - </FONT><FONT FACE=ARIAL COLOR="#FF0000">Required</FONT></TD>
			</TR>

			<TR BGCOLOR="#FFFFFF">
				<TD COLSPAN=2><FONT SIZE=-1 FACE=ARIAL>This platform supports multiple processors.  Please select matching processors if you require more than one.</FONT><BR>
		          	<SELECT NAME="PROCESSOR">
				<OPTION SELECTED VALUE="">-- SELECT PROCESSOR --</OPTION>
				<!--#include file="webuser.txt"-->
				<%
				Set rs=Server.CreateObject("adodb.Recordset")
				sqlstmt = "SELECT * from hardware_processors"
				rs.open sqlstmt, connect

				Do while not rs.eof
					ID		=	rs("ID")
					displayname	=	rs("displayname")
					%>
					<OPTION VALUE="<%= ID %>"><%= displayname %></OPTION>
					<%
					rs.MoveNext
				Loop

				rs.Close
				Set rs=Nothing
				%>
				</SELECT><BR><BR>
				<INPUT TYPE=checkbox NAME="DUAL" VALUE="Yes"><FONT FACE=ARIAL SIZE=-1>Would you like dual processors?</FONT>
				<BR><BR></TD>
			</TR>

			<TR BGCOLOR="#EEEEEE">
				<TD COLSPAN=2 BGCOLOR="#EEEEEE"><FONT FACE=ARIAL COLOR="#000000">MEMORY - </FONT><FONT FACE=ARIAL COLOR="#FF0000">Required</FONT></TD>
			</TR>
	
			<TR BGCOLOR="#FFFFFF">
		        	<TD COLSPAN=2> <SELECT NAME="RAM">
				<OPTION SELECTED VALUE="">-- SELECT RAM --</OPTION>
				<!--#include file="webuser.txt"-->
				<%
				Set rs=Server.CreateObject("adodb.Recordset")
				sqlstmt = "SELECT * from hardware_ram"
				rs.open sqlstmt, connect

				Do while not rs.eof
					ID		=	rs("ID")
					displayname	=	rs("displayname")
					%>
					<OPTION VALUE="<%= ID %>"><%= displayname %></OPTION>
					<%
					rs.MoveNext
				Loop

				rs.Close
				Set rs=Nothing
				%>
				</SELECT><BR><BR></TD>
			</TR>

			<TR BGCOLOR="#EEEEEE">
				<TD COLSPAN=2 BGCOLOR="#EEEEEE"><FONT FACE=ARIAL COLOR="#000000">HARD DISK DRIVE - </FONT><FONT FACE=ARIAL COLOR="#FF0000">Required</FONT></TD>
			</TR>

			<TR BGCOLOR="#FFFFFF">
				<TD COLSPAN=2><FONT SIZE=-1 FACE=ARIAL>	This platform has multiple drive slots which can be filled if required.  For RAID all hard drives must match and must be SCSI (UWSCSI).	</FONT><BR>
				<SELECT NAME="HDD">
				<OPTION SELECTED VALUE="">-- SELECT HARD DRIVE(S) --</OPTION>
				<!--#include file="webuser.txt"-->
				<%
				Set rs=Server.CreateObject("adodb.Recordset")
				sqlstmt = "SELECT * from hardware_drives"
				rs.open sqlstmt, connect

				Do while not rs.eof
					ID		=	rs("ID")
					displayname	=	rs("displayname")
					%>
					<OPTION VALUE="<%= ID %>"><%= displayname %></OPTION>
					<%
					rs.MoveNext
				Loop

				rs.Close
				Set rs=Nothing
				%>
				</SELECT><BR><BR>
				<FONT FACE=ARIAL SIZE=-1>Number of drives with the type from above:</FONT>
				<SELECT NAME="NUM_HDD">
				<OPTION SELECTED>1
				<OPTION>2
				<OPTION>3
				<OPTION>4
				<OPTION>5
				<OPTION>6
				</SELECT><BR><BR></TD>
			</TR>

			<TR BGCOLOR="#EEEEEE">
				<TD COLSPAN=2><FONT SIZE=-1 FACE=ARIAL>RAID CONTROLLER <BR>This platform has multiple drive slots which can be filled if required.  For RAID all hard drives must match and must be SCSI (UWSCSI).</FONT><BR>	</TD>
			</TR>
	
			<TR BGCOLOR="#FFFFFF">
				<TD COLSPAN=2><INPUT TYPE=checkbox NAME="RAID_CONTROLLER" VALUE="Yes"><FONT FACE=ARIAL SIZE=-1>Yes, I would like a RAID controller.</FONT><BR><BR><BR></TD>
			</TR>

			<TR BGCOLOR="#EEEEEE">
				<TD COLSPAN=2><FONT FACE=ARIAL COLOR="#000000">BANDWIDTH - </FONT><FONT FACE=ARIAL COLOR="#FF0000">Required</FONT></TD>
			</TR>

			<TR BGCOLOR="#FFFFFF">
				<TD COLSPAN=2>
				<SELECT NAME="BANDWIDTH">
				<OPTION SELECTED VALUE="">-- SELECT BANDWIDTH --</OPTION>
				<!--#include file="webuser.txt"-->
				<%
				Set rs=Server.CreateObject("adodb.Recordset")
				sqlstmt = "SELECT * from hardware_bandwidth"
				rs.open sqlstmt, connect

				Do while not rs.eof
					bandID		=	rs("bandID")
					displayname	=	rs("displayname")
					net_type	=	rs("net_type")
					%>
					<OPTION VALUE="<%= ID %>"><%= displayname %> <%= net_type %></OPTION>
					<%
					rs.MoveNext
				Loop

				rs.Close
				Set rs=Nothing
				%>
				</SELECT><BR><BR></TD>
			</TR>

			<TR BGCOLOR="EEEEEE">
				<TD COLSPAN=2><FONT FACE=ARIAL COLOR="#000000">BACK UP HARDWARE</FONT></TD>
			</TR>

			<TR BGCOLOR="#FFFFFF">
		        	<TD COLSPAN=2><SELECT NAME="BACKUP">
				<OPTION SELECTED VALUE="">-- SELECT BACK UP HARDWARE--</OPTION>
				<OPTION>10/20GB IDE Tape Drive
				</SELECT><BR><BR></TD>
			</TR>

			<TR BGCOLOR="#EEEEEE">
				<TD COLSPAN=2><FONT FACE=ARIAL COLOR="#000000">BACK UP SERVICES</FONT></TD>
			</TR>

			<TR BGCOLOR="#FFFFFF">
		        	<TD COLSPAN=2> 	<SELECT NAME="BACKUP_SERVICES">
				<OPTION SELECTED VALUE-"">-- SELECT BACKUP SERVICES --</OPTION>
				<OPTION>Weekly Tape Rotation</OPTION>
				</SELECT><BR>
				<FONT SIZE=-1 FACE=ARIAL>Standard offer includes 1 tape left in the drive, tape rotation is a 5 tape cycle</FONT> 
				<BR><BR><BR></TD>
			</TR>

			<TR BGCOLOR="#EEEEEE">
				<TD COLSPAN=2><FONT FACE=ARIAL SIZE=-1><B>EXTRA</B> IP ADDRESSES</FONT></TD>
			</TR>
	
			<TR BGCOLOR="#FFFFFF">
			        <TD COLSPAN=2> <SELECT NAME="IPS">
				<OPTION SELECTED VALUE=""></OPTION>
				<OPTION>1
				<OPTION>2
				<OPTION>3
				<OPTION>4
				<OPTION>5
				<OPTION>6
				<OPTION>7
				<OPTION>8
				<OPTION>9
				<OPTION>10
				<OPTION>15
				<OPTION>20
				<OPTION>25
				<OPTION>30
				<OPTION>35
				<OPTION>40
				</SELECT><BR><BR><FONT SIZE=-1 FACE=ARIAL>(<B>1 Free IP</B> IS included with every machine.  IPs are purchased at $3 setup and $3 per month.</FONT>) <BR></TD>
			</TR>

			<TR BGCOLOR="#EEEEEE">
				<TD COLSPAN=2><FONT FACE=ARIAL COLOR="#000000">SOFTWARE OPTIONS </FONT></TD>
			</TR>

				<!--#include file="webuser.txt"-->
				<%
				Set rs=Server.CreateObject("adodb.Recordset")
				sqlstmt = "SELECT * from hardware_software"
				rs.open sqlstmt, connect

				Do while not rs.eof
					ID		=	rs("ID")
					displayname	=	rs("displayname")
					%>
					<TR BGCOLOR="#FFFFFF">
						<TD WIDTH=15 VALIGN="top"><INPUT TYPE="checkbox" NAME="SOFTWARE" VALUE="<%= Trim(displayname) %>"></TD>
						<TD><FONT FACE=ARIAL COLOR="#000000"><%= Trim(displayname) %></FONT></TD>
					</TR>
					<%
					rs.MoveNext
				Loop

				rs.Close
				Set rs=Nothing
				%>
			</TABLE>		
	<BR>
	<BR>
	<!--#include file="submit.txt"-->
	</FORM>

<%
	Else If (request.querystring("next") = "calculate") then
	
	instructions	=	"Please confirm that the options listed here are correct.  Click below to receive your quote for managed and unmanaged services using this hardware and software specifications."
	server_type		=	request.form("server_type")
	OS				=	request.form("OS")
	PROCESSOR		=	request.form("PROCESSOR")
	DUAL			=	request.form("DUAL")
	RAM				=	request.form("RAM")
	HDD				= 	request.form("HDD")
	NUM_HDD			=	request.form("NUM_HDD")
	RAID_CONTROLLER	=	request.form("RAID_CONTROLLER")
	BACKUP			=	request.form("BACKUP")
	BACKUP_SERVICES	=	request.form("BACKUP_SERVICES")
	IPS				=	request.form("IPS")
	BANDWIDTH		=	request.form("BANDWIDTH")
	SOFTWARE		=	request.form("SOFTWARE")
	OTHER_SOFTWARE	=	request.form("OTHER_SOFTWARE")
%>		
		<FORM ACTION="?next=calculate" METHOD="post">
		<INPUT TYPE=HIDDEN NAME=server_type VALUE="<%= server_type %>">
		<INPUT TYPE=HIDDEN NAME=OS VALUE="<%= OS %>">
		<INPUT TYPE=HIDDEN NAME=PROCESSOR VALUE="<%= PROCESSOR %>">
		<INPUT TYPE=HIDDEN NAME=DUAL VALUE="<%= DUAL %>">
		<INPUT TYPE=HIDDEN NAME=RAM VALUE="<%= RAM %>">
		<INPUT TYPE=HIDDEN NAME=HDD VALUE="<%= HDD %>">
		<INPUT TYPE=HIDDEN NAME=NUM_HDD VALUE="<%= NUM_HDD %>">
		<INPUT TYPE=HIDDEN NAME=RAID_CONTROLLER VALUE="<%= RAID_CONTROLLER %>">
		<INPUT TYPE=HIDDEN NAME=BACKUP VALUE="<%= BACKUP %>">
		<INPUT TYPE=HIDDEN NAME=BACKUP_SERVICES VALUE="<%= BACKUP_SERVICES %>">
		<INPUT TYPE=HIDDEN NAME=IPS VALUE="<%= IPS %>">
		<INPUT TYPE=HIDDEN NAME=BANDWIDTH VALUE="<%= BANDWIDTH %>">
		<INPUT TYPE=HIDDEN NAME=SOFTWARE VALUE="<%= SOFTWARE %>">
		<INPUT TYPE=HIDDEN NAME=OTHER_SOFTWARE VALUE="<%= OTHER_SOFTWARE %>">
		<TABLE BORDER="0" BGCOLOR="#EEEEEE" CELLSPACING="1" CELLPADDING="1" WIDTH=100%>

			<TR BGCOLOR="#CCCCCC">
				<TD COLSPAN=2 VALIGN="middle"><FONT FACE=ARIAL COLOR="#000000">You have selected the following options.  Review the options, and proceed for your pricing of this type of server.</FONT></TD>
			</TR>

			<TR BGCOLOR="#FFFFFF">
				<TD ALIGN=RIGHT><B><FONT FACE=ARIAL COLOR="#000000">Basic Server Hardware:</FONT></B></TD>
				<TD ALIGN="CENTER"><FONT FACE=ARIAL COLOR="#FF0000">
				<!--#include file="webuser.txt"-->
				<%
				Set rs=Server.CreateObject("adodb.Recordset")
				sqlstmt = "SELECT * from hardware_cases where ID='" & server_type &"'"
				rs.open sqlstmt, connect
				
				Do while not rs.eof
					displayname	=	rs("displayname")
					%>
					<%= displayname %>
					<%
					rs.MoveNext
				Loop

				rs.Close
				Set rs=Nothing
				%>
				</FONT></TD>
			</TR>

			<TR BGCOLOR="#EEEEEE">
				<TD ALIGN=RIGHT><B><FONT FACE=ARIAL COLOR="#000000">Operating System:</FONT></B></TD>

				<TD ALIGN=CENTER><FONT FACE=ARIAL COLOR="#FF0000">
				<!--#include file="webuser.txt"-->
				<%
				Set rs=Server.CreateObject("adodb.Recordset")
				sqlstmt = "SELECT * from hardware_os where ID='" & OS &"'"
				rs.open sqlstmt, connect

				Do while not rs.eof
					displayname	=	rs("displayname")
					%>
					<%= displayname %>
					<%
					rs.MoveNext
				Loop

				rs.Close
				Set rs=Nothing
				%>
				</FONT></TD>
			</TR>

			<TR BGCOLOR="#FFFFFF">
				<TD ALIGN=RIGHT><B><FONT FACE=ARIAL COLOR="#000000">Processor(s):</FONT></B></TD>

				<TD ALIGN=CENTER><FONT FACE=ARIAL COLOR="#FF0000">
				<% 
				If DUAL="Yes" then 
				%>
					Dual 
				<% 
				End If 
				%>

				<!--#include file="webuser.txt"-->
				<%
				Set rs=Server.CreateObject("adodb.Recordset")
				sqlstmt = "SELECT * from hardware_processors where ID='" & PROCESSOR &"'"
				rs.open sqlstmt, connect

				Do while not rs.eof
					displayname	=	rs("displayname")
					%>
					<%= displayname %>
					<%
					rs.MoveNext
				Loop

				rs.Close
				Set rs=Nothing
				%>
				</FONT></TD>
			</TR>

			<TR BGCOLOR="#EEEEEE">
				<TD ALIGN=RIGHT><B><FONT FACE=ARIAL COLOR="#000000">Amount of RAM:</FONT></B></TD>

				<TD ALIGN=CENTER><FONT FACE=ARIAL COLOR="#FF0000">
				<!--#include file="webuser.txt"-->
				<%
				Set rs=Server.CreateObject("adodb.Recordset")
				sqlstmt = "SELECT * from hardware_ram where ID='" & RAM &"'"
				rs.open sqlstmt, connect

				Do while not rs.eof
					displayname	=	rs("displayname")
					%>
					<%= displayname %>
					<%
					rs.MoveNext
				Loop

				rs.Close
				Set rs=Nothing
				%>
				</FONT></TD>
			</TR>

			<TR BGCOLOR="#FFFFFF">
				<TD ALIGN=RIGHT><B><FONT FACE=ARIAL COLOR="#000000">Number, Type, and Size of Disk Drives:</FONT></B></TD>

				<TD ALIGN=CENTER><FONT FACE=ARIAL COLOR="#000000">
				<%= NUM_HDD %></FONT><FONT FACE=ARIAL COLOR="#FF0000">	&nbsp;-&nbsp;
				<!--#include file="webuser.txt"-->
				<%
				Set rs=Server.CreateObject("adodb.Recordset")
				sqlstmt = "SELECT * from hardware_drives where ID='" & HDD &"'"
				rs.open sqlstmt, connect

				Do while not rs.eof
					displayname	=	rs("displayname")
					%>
					<%= displayname %>
					<%
					rs.MoveNext
				Loop

				rs.Close
				Set rs=Nothing
				%>
				<% 
				If (RAID_CONTROLLER="Yes") Then 
				%>
					with a RAID Controller
				<% 
				End If
				%>
				</FONT></TD>

				</FONT></TD>
			</TR>

			<TR BGCOLOR="#EEEEEE">
				<TD ALIGN=RIGHT><B><FONT FACE=ARIAL COLOR="#000000">Backup Solution:</FONT></B>	</TD>

				<TD VALIGN="middle"><FONT FACE=ARIAL COLOR="#FF0000">	&nbsp;&nbsp;<%= BACKUP %>
				<% If BACKUP_SERVICES="" then %>
				<% 
				Else
				%>
				<BR>&nbsp;&nbsp;&nbsp;&nbsp;</FONT><FONT FACE=ARIAL SIZE=-2>We will provide the Tape backup rotation.
				<%
				End If
				%>
				</FONT>	</TD>
			</TR>

			<TR BGCOLOR="#FFFFFF">
				<TD ALIGN=RIGHT><B><FONT FACE=ARIAL COLOR="#000000">Software needs:</FONT></B></TD>

				<TD VALIGN="middle"><FONT FACE=ARIAL COLOR="#FF0000">
				<% If SOFTWARE="" then %>
				&nbsp;&nbsp;No specific software needs specified
				<% 
				Else
				%>
				&nbsp;&nbsp;<%= SOFTWARE %>
				<%
				End If
				%>
				</FONT></TD>
			</TR>
			</TABLE>
	<BR>
	<BR>
	<!--#include file="submit.txt"-->
<%
	Else
%>
		<TABLE BORDER="0" BGCOLOR="#000000" CELLSPACING="1" CELLPADDING="1">

			<TR BGCOLOR="#CCCCCC">
				<TD COLSPAN=2 VALIGN="middle">
				<FONT FACE=ARIAL COLOR="#000000">It appears that you have called an interface on this quote system that does not exist.  Please click the button below to return to your previous location.</FONT></TD>
			</TR>

			<TR BGCOLOR="#FFFFFF">
				<TD COLSPAN=2>
				<BR>
				<CENTER><INPUT TYPE=BUTTON onclick="history.back()"STYLE="color: white;border-color: #000000; background-color: #C40000;font-weight: 700;" TYPE="BUTTON" VALUE=" Back " />&nbsp;&nbsp;</CENTER>
				<BR>
				</TD>
			</TR>
			</TABLE>
	<BR>
	<BR>
<%
	End If  'for first if statement (if they go to the page)
	End If  'for the if next=components
	End If	'for the if next=calculate
%>
		</TD>
		<TD ALIGN=RIGHT VALIGN=TOP><IMG SRC="/images/dedicated.jpg">
		<BR>
		<BR><BLOCKQUOTE><FONT FACE=ARIAL SIZE=-1><%= instructions %></FONT></BLOCKQUOTE>
		</TD>
		</TR>
		</TABLE>
</TD>
</TR>
<!--#include file="footer.txt"-->