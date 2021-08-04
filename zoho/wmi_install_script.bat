@echo off
C:\_software\zoho\ZA_Access.exe /z"-silent -src deployment_tool" -s -f1"C:\_software\zoho\ZohoAssistAgent.iss"
set reg_cmd=reg query "hklm\software\zoho corp\zoho assist unattended agent\1.00.0001" /v "installation_status" /reg:32
for /f "tokens=1-3" %%a in (' %reg_cmd% ') do ( 
if not %%a == HKEY_LOCAL_MACHINE\software\zoho ( 
if %%c == 0x1 exit 1000 
if %%c == 0x2 exit 1001
if %%c == 0x3 exit 1002
if %%c == 0x4 exit 1003
if %%c == 0x5 exit 1004
if %%c == 0x6 exit 1005
if %%c == 0x7 exit 1006 )
)
