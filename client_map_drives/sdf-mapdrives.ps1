# Assign the Log File Name and Path
$log_path = "C:\scripts\logs"
$log_file_name = "scripts-mappeddrives.log"

# Combine to full path
$log_file = "$log_path\$log_file_name"

# Log Rotate Threshold in KB
$log_rotate_threshold_in_kb = 2500

# Set the user and scans dir variables
$user=((gwmi win32_computersystem).username).split('\')[1]
$scansdir=(Get-ChildItem "\\sdf-docserv.id.sdsu.edu\scans$" -Directory|Select-Object -First 1).Name

$Scans_Path = "\\sdf-docserv.id.sdsu.edu\scans`$\$($scansdir)\$($user)"
$PL1_Path = "\\sdf-docserv.id.sdsu.edu\PL1"


# Create the log directory if it doesn't exist
[boolean]$log_path_exists = $False
$log_path_exists = Test-Path $log_path
if (!$log_path_exists){
    new-item -itemtype "directory" -path $log_path
    write-output "Log path absent. Directory $log_path created." | out-file $log_file -Append
}


# Rotate the log if needed
if (((Get-ChildItem $log_file).Length/1KB) -ge $log_rotate_threshold_in_kb){
    write-output "File bigger than $log_rotate_threshold_in_kb KB - Rotating log" | out-file $log_file -Append
    $datetime = Get-Date -uformat "%Y-%m-%d-%H%M"
    $newname = "$((Get-ChildItem $log_file).BaseName)-${datetime}.log_old"
    Rename-Item $log_file $newname
    write-output "Rotated file name is $log_path\$newname" | out-file $log_file -Append
}

# Yay we're starting!  (it's for the log)
write-output "=== Script begin $(get-date) ===" | out-file $log_file -Append

# Instantiate the variables (no undefined plz)
[boolean]$SDrive_Exist = $False
[boolean]$LDrive_Exist = $False
[boolean]$SDrive_Path_Exist = $False
[boolean]$LDrive_Path_Exist = $False




# Check if the drives and paths exist
$SDrive_Exist = Test-Path S:\
$LDrive_Exist = Test-Path L:\
$SDrive_Path_Exist = Test-Path $Scans_Path
$LDrive_Path_Exist = Test-Path $PL1_Path

# Check if the drive exists
if ($SDrive_Exist){
    # If it exists, move to the next command
    write-output "S Drive Exists" | out-file $log_file -Append
}
elseif ($SDrive_Path_Exist) {
    # If it does not exist, check if the path exists and then map it
    write-output "S Drive absent. Mapping..." | out-file $log_file -Append
    New-PSDrive -Name "S" -Root $Scans_Path -Persist -PSProvider "FileSystem" -Scope Global -Verbose | out-file $log_file -Append
    $shell = New-Object -ComObject Shell.Application
    $shell.NameSpace("S:").Self.Name = "Scans"
    
}

# Check if the drive exists
if ($LDrive_Exist){
    # If it exists, move to the next command
    write-output "L Drive Exists" | out-file $log_file -Append
}
elseif ($LDrive_Path_Exist){
    # If it does not exist, check if the path exists and then map it
    write-output "L Drive absent. Mapping..." | out-file $log_file -Append
    New-PSDrive -Name "L" -Root $PL1_Path -Persist -PSProvider "FileSystem" -Scope Global -Verbose | out-file $log_file -Append
    $shell = New-Object -ComObject Shell.Application
    $shell.NameSpace("L:").Self.Name = "PL1"
}

# Finito. (for the log)
write-output "=== Script end $(get-date) ===" | out-file $log_file -Append
write-output "*******************************" | out-file $log_file -Append

