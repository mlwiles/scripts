# Michael Wiles - mwiles@us.ibm.com
# 2021/10/19
# Veeam VCDServer - GetID for HostUid - https://helpcenter.veeam.com/docs/backup/em_rest/post_vcloud_orgconfigs.html?ver=110

$User="REDACTED"
$Pass="REDACTED"
$Server="REDACTED"

Write-Host "User"=$User
Write-Host "Pass"=$Pass
Write-Host "Server"=$Server


$veeamPSModule = "C:\Program Files\Veeam\Backup and Replication\Console\Veeam.Backup.PowerShell\Veeam.Backup.PowerShell.psd1"
Import-module -name $veeamPSModule -ErrorAction SilentlyContinue  -WarningAction SilentlyContinue

Connect-VBRServer -Server $Server -User $User -Password $Pass
$managedServers = Get-VBRServer -Type VcdSystem
foreach ($managedServer in $managedServers) {
   #  HostUid is the Id below 
   #Info               : REDACTED.vmware-solutions.cloud.ibm.com (VMware vCloud Director server )
   #ParentId           : 00000000-0000-0000-0000-000000000000
   #Id                 : ffa19eb7-REDACTED-4595-a1d9-e97483f65c10
   #Uid                : ffa19eb7REDACTED4595a1d9e97483f65c10
   #Name               : REDACTED.vmware-solutions.cloud.ibm.com
   #Reference          : 
   #Description        : Created by REDACTED.
   #IsUnavailable      : False
   #Type               : VcdSystem
   #ApiVersion         : Unknown
   #PhysHostId         : 00000000-0000-0000-0000-000000000000
   #ProxyServicesCreds : Veeam.Backup.Common.CCredentials 
   $managedServer
}
Disconnect-VBRServer 
