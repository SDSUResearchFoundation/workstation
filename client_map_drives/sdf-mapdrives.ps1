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
    echo "Log path absent. Directory $log_path created." >>$log_file
}

Del *.*
# Rotate the log if needed
if (((Get-ChildItem $log_file).Length/1KB) -ge $log_rotate_threshold_in_kb){
    echo "File bigger than $log_rotate_threshold_in_kb KB - Rotating log" >>$log_file
    $datetime = Get-Date -uformat "%Y-%m-%d-%H%M"
    $newname = "$((Get-ChildItem $log_file).BaseName)-${datetime}.log_old"
    Rename-Item $log_file $newname
    echo "Rotated file name is $log_path\$newname" >>$log_file
}

# Yay we're starting!  (it's for the log)
echo "=== Script begin $(get-date) ===" >>$log_file

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
    echo "S Drive Exists" >>$log_file
}
elseif ($SDrive_Path_Exist) {
    # If it does not exist, check if the path exists and then map it
    echo "S Drive absent. Mapping..." >>$log_file
    New-PSDrive -Name "S" -Root $Scans_Path -Persist -PSProvider "FileSystem" -Scope Global -Verbose >>$log_file
    $shell = New-Object -ComObject Shell.Application
    $shell.NameSpace("S:").Self.Name = "Scans"
    
}

# Check if the drive exists
if ($LDrive_Exist){
    # If it exists, move to the next command
    echo "L Drive Exists" >>$log_file
}
elseif ($LDrive_Path_Exist){
    # If it does not exist, check if the path exists and then map it
    echo "L Drive absent. Mapping..." >>$log_file
    New-PSDrive -Name "L" -Root $PL1_Path -Persist -PSProvider "FileSystem" -Scope Global -Verbose >>$log_file
    $shell = New-Object -ComObject Shell.Application
    $shell.NameSpace("L:").Self.Name = "PL1"
}

# Finito. (for the log)
echo "=== Script end $(get-date) ===" >>$log_file
echo "*******************************" >>$log_file

