Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
oh-my-posh init pwsh --config ~/OneDrive/Dokumentumok/PowerShell/gradeczki.omp.json | Invoke-Expression

function Enable-Wsl-Bridge {
    param(
        [int]$port = 3000,
        [ipaddress]$wsl_ip
    )

    if(-Not $PSBoundParameters.ContainsKey('wsl_ip')) {
        $ip = wsl hostname -I
        $wsl_ip = [ipaddress]$ip.Trim()
    }

    Write-Host "Using port" $port
    Write-Host "Using ip" $wsl_ip

    if(1 -eq 1) {
        netsh interface portproxy add v4tov4 listenport=$port listenaddress=0.0.0.0 connectport=$port connectaddress=$wsl_ip

        $firewall_name = "WSL2 Open :$port"

        Write-Host "Removing previous Firewall rule"
        Remove-NetFirewallRule -DisplayName $firewall_name
        Write-Host "Creating new Firewall rule"
        New-NetFirewallRule -DisplayName $firewall_name -Direction Inbound -LocalPort $port -Protocol TCP -Profile @('Domain', 'Private') -Action Allow
    }
}

function Setup-Git {
    git config --global user.name "Gergő Radeczki"
    git config --global user.email "g.radeczki@gmail.com"
    git config --global core.editor "~\AppData\Local\Programs\Microsoft VS Code\Code.exe"
    git config --global init.defaultBranch main
    git config --global core.ignorecase true
    git config --global core.autocrlf true
}

function Install-My-Programs {
    param (
        [switch]$devTools = $false,
        [switch]$utilityTools = $false,
        [switch]$creationTools = $false,
        [switch]$gameLaunchers = $false
    )

    function Install-Using-Winget {
        param (
            [string]$appId,
            [string]$appName,
            [string]$source
        )

        # check if app is already installed
        if( "$(winget list --name $appName --exact)".Contains("--") ) {
            Write-Host "$appName is already installed!" -ForegroundColor Yellow
        } else {
            Write-Host "Attempting to download $appName..." -ForegroundColor Green
            $appIdTemp = $appId
            if($source -eq "msstore") {
                $appIdTemp = $appId.ToUpper()
            }
            winget install --id $appIdTemp --source $source --exact --silent --accept-package-agreements --accept-source-agreements
        }
    }

    if($installDevTools) {
        Write-Host "Installing dev tools" -ForegroundColor Cyan
        Install-Using-Winget -appId "Microsoft.VisualStudioCode" -appName "Microsoft Visual Studio Code" -source "winget"
        Install-Using-Winget -appId "JetBrains.Toolbox" -appName "JetBrains Toolbox" -source "winget"
        Install-Using-Winget -appId "Microsoft.PowerShell" -appName "PowerShell" -source "winget"
        Install-Using-Winget -appId "JanDeDobbeleer.OhMyPosh" -appName "Oh My Posh" -source "winget"
        Install-Using-Winget -appId "Microsoft.PowerToys" -appName "PowerToys (Preview)" -source "winget"
        Install-Using-Winget -appId "Docker.DockerDesktop" -appName "Docker Desktop" -source "winget"
        Install-Using-Winget -appId "Schniz.fnm" -appName "Fast Node Manager" -source "winget"
    }

    if($installUtilityTools) {
        Write-Host "Installing utility tools" -ForegroundColor Cyan
        Install-Using-Winget -appId "Discord.Discord" -appName "Discord.Discord" -source "winget"
        Install-Using-Winget -appId "Apple.iTunes" -appName "iTunes" -source "winget"
        Install-Using-Winget -appId "SlackTechnologies.Slack" -appName "Slack" -source "winget"
        Install-Using-Winget -appId "Mattermost.MattermostDesktop" -appName "Mattermost" -source "winget"
        Install-Using-Winget -appId "7zip.7zip" -appName "7-Zip" -source "winget"
        Install-Using-Winget -appId "VideoLAN.VLC" -appName "VLC media player" -source "winget"
        Install-Using-Winget -appId "Mp3tag.Mp3tag" -appName "Mp3tag" -source "winget"
        Install-Using-Winget -appId "PDFsam.PDFsam" -appName "PDFsam Basic" -source "winget"
        Install-Using-Winget -appId "OBSProject.OBSStudio" -appName "OBS Studio" -source "winget"
        Install-Using-Winget -appId "Plex.Plex" -appName "Plex" -source "winget"
        Install-Using-Winget -appId "Olivia.VIA" -appName "VIA" -source "winget"
        Install-Using-Winget -appId "qBittorrent.qBittorrent" -appName "qBittorrent" -source "winget"
    }

    if($installCreationTools) {
        Write-Host "Installing creation tools" -ForegroundColor Cyan
        Install-Using-Winget -appId "BlenderFoundation.Blender" -appName "Blender" -source "winget"
        Install-Using-Winget -appId "Figma.Figma" -appName "Figma" -source "winget"
        Install-Using-Winget -appId "9N2D0P16C80H" -appName "Affinity Designer 2" -source "msstore"
        Install-Using-Winget -appId "9P8DVF1XW02V" -appName "Affinity Photo 2" -source "msstore"
        Install-Using-Winget -appId "9NTV2DZ11KD9" -appName "Affinity Publisher 2" -source "msstore"
        Install-Using-Winget -appId "MarkText.MarkText" -appName "Mark Text" -source "winget"
    }

    if($installGameLaunchers) {
        Write-Host "Installing game launchers" -ForegroundColor Cyan
        Install-Using-Winget -appId "Mojang.MinecraftLauncher" -appName "Minecraft Launcher" -source "winget"
        Install-Using-Winget -appId "Valve.Steam" -appName "Steam" -source "winget"
        Install-Using-Winget -appId "ElectronicArts.EADesktop" -appName "EA app" -source "winget"
        Install-Using-Winget -appId "Ubisoft.Connect" -appName "Ubisoft Connect" -source "winget"
        Install-Using-Winget -appId "EpicGames.EpicGamesLauncher" -appName "Epic Games Launcher" -source "winget"
        Install-Using-Winget -appId "GOG.Galaxy" -appName "GOG GALAXY" -source "winget"
        Install-Using-Winget -appId "Blizzard.BattleNet" -appName "Battle.net" -source "winget"
        #Install-Using-Winget -appId "" -appName "" -source "winget"
    }

    Write-Host "Affinity Designer 2: " -NoNewline -ForegroundColor Red
    Write-Host "ms-windows-store://pdp/?ProductId=9N2D0P16C80H" -ForegroundColor Blue
    Write-Host "Affinity Photo 2: " -NoNewline -ForegroundColor Red
    Write-Host "ms-windows-store://pdp/?ProductId=9P8DVF1XW02V" -ForegroundColor Blue
    Write-Host "Affinity Publisher 2: " -NoNewline -ForegroundColor Red
    Write-Host "ms-windows-store://pdp/?ProductId=9NTV2DZ11KD9" -ForegroundColor Blue
    Write-Host "DaVinci Resolve: " -NoNewline -ForegroundColor Red
    Write-Host "https://www.blackmagicdesign.com/products/davinciresolve/" -ForegroundColor Blue
    Write-Host "Office 365: " -NoNewline -ForegroundColor Red
    Write-Host "https://portal.office.com/" -ForegroundColor Blue
    Write-Host "Rockstar Games Launcher: " -NoNewline -ForegroundColor Red
    Write-Host "https://socialclub.rockstargames.com/rockstar-games-launcher" -ForegroundColor Blue
    Write-Host "MinGit: " -NoNewline -ForegroundColor Red
    Write-Host "https://github.com/git-for-windows/git/releases" -ForegroundColor Blue
    Write-Host "yt-dlp: " -NoNewline -ForegroundColor Red
    Write-Host "https://github.com/yt-dlp/yt-dlp" -ForegroundColor Blue
}
