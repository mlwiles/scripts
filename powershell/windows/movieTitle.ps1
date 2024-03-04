. "$PSScriptRoot\FileMetaData.ps1"
# Get the list of files in a specific directory
$directoryPath = "C:\temp\"
$fileList = Get-ChildItem $directoryPath

# Iterate through each file and set the title to the filename
foreach ($file in $fileList) {
    $fileTitle = $file.BaseName  # Get the filename without extension
    Write-Host $fileTitle
    $fileFullname = $file.FullName
    Write-Host $fileFullname
    #GetFileMetaData -File $fileFullname
    SetFileTitle -File $fileFullname "$fileTitle"
}

# Display a message indicating the completion of the process
Write-Host "File titles updated successfully."