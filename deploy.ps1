# Create symlink to home.
New-Item -Type SymbolicLink -Path ~\_vimrc -Value (Resolve-Path .\vim\_vimrc)
New-Item -Type SymbolicLink -Path ~\_gvimrc -Value (Resolve-Path .\vim\_gvimrc)
New-Item -Type SymbolicLink -Path $PROFILE -Value (Resolve-Path .\powershell\Microsoft.PowerShell_profile.ps1)
