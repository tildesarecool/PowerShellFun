# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/get-psdrive?view=powershell-6
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-psdrive?view=powershell-6

# inspiration source and/or answer
# https://superuser.com/questions/1105292/backup-mapped-drive-paths

# I thought I could come up with a similar but but different solution to this 
# but as it is I think I'll probably just use this sample
# although i'm not sure if this works on win 7 so that might be a deal breaker

# Define array to hold identified mapped drives.
$mappedDrives = @()

# Get a list of the drives on the system, including only FileSystem type drives.
$drives = Get-PSDrive -PSProvider FileSystem

# Iterate the drive list
foreach ($drive in $drives) {
    # If the current drive has a DisplayRoot property, then it's a mapped drive.
    if ($drive.DisplayRoot) {
        # Exctract the drive's Name (the letter) and its DisplayRoot (the UNC path), and add then to the array.
        $mappedDrives += Select-Object Name,DisplayRoot -InputObject $drive
    }
}

# Take array of mapped drives and export it to a CSV file.
$mappedDrives | Export-Csv mappedDrives.csv

######################################################################################
# Import drive list.
$mappedDrives = Import-Csv mappedDrives.csv

# Iterate over the drives in the list.
foreach ($drive in $mappedDrives) {
    # Create a new mapped drive for this entry.
    New-PSDrive -Name $drive.Name -PSProvider "FileSystem" -Root $drive.DisplayRoot -Persist -ErrorAction Continue 
}