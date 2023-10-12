Set-PSReadlineOption -EditMode Emacs
Import-Module posh-git
$GitPromptSettings.DefaultPromptSuffix = $('`n> ' * ($nestedPromptLevel + 1))
function prompt {
    # Detect current platform powershell running on and user role, because of show these.
    $currentPlatformRunningOn = '';
    $currentUserRole = '[]';
    if ($PSVersionTable.Platform -eq 'UNIX') {
        $currentPlatformRunningOn = '[UNIX]';
    } else {
        $currentPlatformRunningOn = '[WIN]';

        $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
        $principal = [Security.Principal.WindowsPrincipal] $identity
        $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

        if($principal.IsInRole($adminRole)) {
            $currentUserRole = '[ADMIN]'
        }
    }

    # Your non-prompt logic here
    $prompt = $currentPlatformRunningOn + $currentUserRole
    $prompt += Write-Prompt "PS:"
    $prompt += "[$(Get-Date -f 'yyyy-MM-ddTHH:mm:ss%K')] "
    $prompt += & $GitPromptScriptBlock
    if ($prompt) { "$prompt" } else { " " }
}


# DateTime wise shortcuts.
function Get-DateISO8601ForFilename {
    (Get-Date -f yyyy-MM-ddTHH.mm.ss%K) -replace ':',''
}

function Get-DateYMD {
    Get-Date -f yyyy-MM-dd
}

function Get-HoursMinutesSeconds {
    Get-Date -f "HH:mm:ss.fff%K"
}

Set-Alias datef -Value Get-DateISO8601ForFilename
Set-Alias dateymd -Value Get-DateYMD
Set-Alias time -Value Get-HoursMinutesSeconds

# https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete#powershell
# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
        dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}
