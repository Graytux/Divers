#####################################
# Auteur : Brettdah                 #
# Git : https://github.com/Brettdah #
# Script : du -sh mode windows      #
#####################################

Get-Children |
Where-Object { $_.PSIsContainer } |
ForEach-Object {
	$dirlist_size = ($_.Name + " " + "{0:N2} Go" -f ((
		Get-ChildItem $_ -Recurse |
		Measure-Object Length -Sum -ErrorAction SilentlyContinue).Sum /1GB
	)).Trim() -split '\s+'

	New-Object -TypeName PSCustomObject -Properly @{
		Folder = $dirlist_size[0]
		Size = $dirlist_size[1]
		Unit = $dirlist_size[2]
	}

} | Sort-Object Size | Format-Table Folder,Size,Unit