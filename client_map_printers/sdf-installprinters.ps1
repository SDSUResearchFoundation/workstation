$printersList = "\\sdf-printers.id.sdsu.edu\3526D-Copier","\\sdf-printers.id.sdsu.edu\3519-M603","\\sdf-printers.id.sdsu.edu\3501-Copier"
$printersMapped = Get-Printer
foreach ($printer in $printersList)
{
       if ($printer -in $printersMapped.Name) {
            Write-host "$printer already mapped!"
        }
                else {
            Write-Verbose -Message "Mapping printer $printer"
            Add-Printer -ConnectionName $printer
        }

}