Set-PSReadlineOption -EditMode Emacs
Import-Module posh-git
$GitPromptSettings.DefaultPromptSuffix = $('`n> ' * ($nestedPromptLevel + 1))
function prompt {
    # Your non-prompt logic here
    $prompt = Write-Prompt "PS:"
    $prompt += Write-Prompt "[$(Get-Date -f 'yyyy-MM-ddTHH:mm:ss%K')] " -ForegroundColor ([ConsoleColor]::White)
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
