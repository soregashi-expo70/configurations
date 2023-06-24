Set-PSReadlineOption -EditMode Emacs
Import-Module posh-git
$GitPromptSettings.DefaultPromptSuffix = $('`n> ' * ($nestedPromptLevel + 1))
function prompt {
    # Detect current platform powershell running on and user role, because of show these.
    $currentPlatformRunningOn = '';
    $currentUserRole = '';
    if ($PSVersionTable.Platform = 'UNIX') {
        $currentPlatformRunningOn = '[UNIX]';
    } else {
        $currentPlatformRunningOn = '[WIN]';

        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = [Security.Principal.WindowsPrincipal] $identity
        $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

        $currentUserRole = if($principal.Equals($adminRole)) { '[ADMIN]' } else { '[]' }
    }

    # Your non-prompt logic here
    $prompt = $currentPlatformRunningOn + $currentUserRole
    $prompt += Write-Prompt "PS:"
    $prompt += "[$(Get-Date -f 'yyyy-MM-ddTHH:mm:ss%K')] "
    $prompt += & $GitPromptScriptBlock
    if ($prompt) { "$prompt" } else { " " }
}


function Get-DateISO8601ForFilename {
    (Get-Date -f yyyy-MM-ddTHH.mm.ss%K) -replace ':',''
}
function Get-DateYMD {
    Get-Date -f yyyy-MM-dd
}


Set-Alias datef -Value Get-DateISO8601ForFilename
Set-Alias dateymd -Value Get-DateYMD
