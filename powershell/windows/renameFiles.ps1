Get-ChildItem "C:\Users\mwiles\" | Rename-Item -NewName { $_.Name -replace '_XYZabc*.','' }
