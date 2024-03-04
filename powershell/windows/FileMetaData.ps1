Function GetFileMetaData 
{ 
    <# 
    .SYNOPSIS 
        Get-FileMetaData returns metadata information about a single file. 
    .DESCRIPTION 
        This function will return all metadata information about a specific file. It can be used to access the information stored in the filesystem. 
    .EXAMPLE 
        Get-FileMetaData -File "c:\temp\image.jpg" 
        Get information about an image file. 
    .EXAMPLE 
        Get-FileMetaData -File "c:\temp\image.jpg" | Select Dimensions 
        Show the dimensions of the image. 
    .EXAMPLE 
        Get-ChildItem -Path .\ -Filter *.exe | foreach {Get-FileMetaData -File $_.Name | Select Name,"File version"} 
        Show the file version of all binary files in the current folder. 
    #> 
    param([Parameter(Mandatory=$True)][string]$File = $(throw "Parameter -File is required.")) 
    if(!(Test-Path -Path $File)) 
    { 
        throw "File does not exist: $File" 
        Exit 1 
    } 
 
    $tmp = Get-ChildItem $File 
    $pathname = $tmp.DirectoryName 
    $filename = $tmp.Name 
 
    $hash = @{}
    try{
        $shellobj = New-Object -ComObject Shell.Application 
        $folderobj = $shellobj.namespace($pathname) 
        $fileobj = $folderobj.parsename($filename) 
        
        for($i=0; $i -le 294; $i++) 
        { 
            $name = $folderobj.getDetailsOf($null, $i);
            if($name){
                $value = $folderobj.getDetailsOf($fileobj, $i);
                if($value){
                    $hash[$($name)] = $($value)
                }
            }
        } 
    }finally{
        if($shellobj){
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$shellobj) | out-null
        }
    }
    return New-Object PSObject -Property $hash
}

Function SetFileTitle 
{ 
    <# 
    .SYNOPSIS 
        Get-FileMetaData returns metadata information about a single file. 
    .DESCRIPTION 
        This function will return all metadata information about a specific file. It can be used to access the information stored in the filesystem. 
    .EXAMPLE 
        Get-FileMetaData -File "c:\temp\image.jpg" 
        Get information about an image file. 
    .EXAMPLE 
        Get-FileMetaData -File "c:\temp\image.jpg" | Select Dimensions 
        Show the dimensions of the image. 
    .EXAMPLE 
        Get-ChildItem -Path .\ -Filter *.exe | foreach {Get-FileMetaData -File $_.Name | Select Name,"File version"} 
        Show the file version of all binary files in the current folder. 
    #> 
    param([Parameter(Mandatory=$True)][string]$File, [string]$Title = $(throw "Parameter -File is required.")) 


    try{
        # if (-not (Test-Path -Path $File -PathType Leaf)) {
        #     throw "File does not exist: $File"
        # }
        $shellobj = New-Object -Com Shell.Application
        $folderobj = $shellobj.Namespace((Get-Item $File).DirectoryName)
        $fileobj = $folderobj.ParseName((Get-Item $File).Name)

        #https://github.com/contre/Windows-API-Code-Pack-1.1/blob/main/source%20(original)/Windows%20API%20Code%20Pack%201.1.zip
        Add-Type -Path $PSScriptRoot\Microsoft.WindowsAPICodePack.Shell.dll

        #https://stackoverflow.com/questions/65228096/powershell-changing-mp4-metadata-right-click-properties
        $shellFile = [Microsoft.WindowsAPICodePack.Shell.ShellFile]::FromFilePath($File)
        $propertyWriter = $shellFile.Properties.GetPropertyWriter()
        $titlePropertyKey = [Microsoft.WindowsAPICodePack.Shell.PropertySystem.PropertyKey]::new([Guid]::new("{F29F85E0-4FF9-1068-AB91-08002B27B3D9}"), 2)
        $propertyWriter.WriteProperty($titlePropertyKey, (Get-Item $File).Basename)
        $propertyWriter.Close()
    }finally{
        if($shellobj){
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$shellobj) | out-null
        }
    }
}