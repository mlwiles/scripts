$rundll = Join-Path -Path ($env:windir) -ChildPath "System32\rundll32.exe"
& ($rundll) powrprof.dll,SetSuspendState 0,1,0