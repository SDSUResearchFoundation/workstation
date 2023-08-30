$printersList = "\\sdf-printers.id.sdsu.edu\4-finccopier","\\sdf-printers.id.sdsu.edu\4-csp4515","\\sdf-printers.id.sdsu.edu\4-app3015-1","\\sdf-printers.id.sdsu.edu\4-app3015-2","\\sdf-printers.id.sdsu.edu\4-faccopier","\\sdf-printers.id.sdsu.edu\4-hrp4515-back"
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