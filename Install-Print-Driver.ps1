#this is just a way to stage and add a printer driver; package with the driver in a win32 app to distribute with intune or point to the .inf file on a network share and it should work either way
$infFile = '<INF FILE PATH HERE>' # INF file path here - example path for WIN32 packaged app and Kyocera driver: ".\KX_Universal_Printer_Driver\Kx84_UPD_8.4.1716_en_RC5_WHQL\64bit\OEMSETUP.INF"
$driverName = '<DRIVER NAME FROM INF FILE HERE>' #exact driver name you wish to install from within the list found in the specified inf file; example "KX DRIVER for Universal Printing" 
pnputil /add-driver 
Add-PrinterDriver -Name -verbose

#uncomment to check
#Get-PrinterDriver
