' this runs the powershell silently in the background
command = "powershell.exe C:\scripts\sdf-mapdrives.ps1"
set shell = CreateObject("WScript.Shell")
shell.Run command,0