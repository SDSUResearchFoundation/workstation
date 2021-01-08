' this runs the powershell silently in the background
command = "powershell.exe -ExecutionPolicy Bypass -file C:\scripts\sdf-mapdrives.ps1"
set shell = CreateObject("WScript.Shell")
shell.Run command,0