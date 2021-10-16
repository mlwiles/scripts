<# 
.SYNOPSIS 
 
 
.DESCRIPTION 
 
 
.NOTES 
┌─────────────────────────────────────────────────────────────────────────────────────────────┐ 
│ ORIGIN STORY                                                                                │ 
├─────────────────────────────────────────────────────────────────────────────────────────────┤ 
│   DATE        : 2021/02/03
│   AUTHOR      : Michael Wiles (mwiles@us.ibm.com) 
│   DESCRIPTION : Send SMTP messages
└─────────────────────────────────────────────────────────────────────────────────────────────┘
 
#>

set-psdebug -trace 2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Send-MailMessage -SMTPServer adnssdalha1m011.st.dir -Port 587 -UseSsl -To mwiles@us.ibm.com -From adnsdalha1m011@st.dir -Subject "This is a test email" -Body "Hi, this a test email sent via PowerShell"
#Send-MailMessage -SMTPServer adnssdalha1m012.st.dir -Port 587 -UseSsl -To mwiles@us.ibm.com -From adnssdalha1m012@st.dir -Subject "This is a test email" -Body "Hi, this a test email sent via PowerShell" 
