# Using using allows us to simplify type usage
using namespace System.IO

# so instead of:
[System.IO.DirectoryInfo]::new('path')

# we can use:
[DirectoryInfo]::new('path')

#Link: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_using?view=powershell-7.3