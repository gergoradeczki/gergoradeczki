Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
oh-my-posh --init --shell pwsh --config ~/OneDrive/Dokumentumok/PowerShell/gradeczki.omp.json | Invoke-Expression

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
        Install-Using-Winget -appId "XP9KHM4BK9FZ7Q" -appName "Microsoft Visual Studio Code" -source "msstore"
        Install-Using-Winget -appId "XPDCFJDKLZJLP8" -appName "Visual Studio Community 2022" -source "msstore"
        Install-Using-Winget -appId "JetBrains.Toolbox" -appName "JetBrains Toolbox" -source "winget"
        Install-Using-Winget -appId "9MZ1SNWT0N5D" -appName "PowerShell" -source "msstore"
        Install-Using-Winget -appId "JanDeDobbeleer.OhMyPosh" -appName "Oh My Posh" -source "winget"
        Install-Using-Winget -appId "XP89DCGQ3K6VLD" -appName "PowerToys (Preview)" -source "msstore"
        Install-Using-Winget -appId "OpenJS.NodeJS.LTS" -appName "Node.js" -source "winget"
        Install-Using-Winget -appId "Docker.DockerDesktop" -appName "Docker Desktop" -source "winget"
        
    }

    if($installUtilityTools) {
        Write-Host "Installing utility tools" -ForegroundColor Cyan
        Install-Using-Winget -appId "XPDC2RH70K22MN" -appName "Discord" -source "msstore"
        Install-Using-Winget -appId "9PB2MZ1ZMB1S" -appName "iTunes" -source "msstore"
        Install-Using-Winget -appId "9WZDNCRDK3WP" -appName "Slack" -source "msstore"
        Install-Using-Winget -appId "Mattermost.MattermostDesktop" -appName "Mattermost" -source "winget"
        Install-Using-Winget -appId "7zip.7zip" -appName "7-Zip" -source "winget"
        Install-Using-Winget -appId "VideoLAN.VLC" -appName "VLC media player" -source "winget"
        Install-Using-Winget -appId "9NN77TCQ1NC8" -appName "Mp3tag" -source "msstore"
        Install-Using-Winget -appId "PDFsam.PDFsam" -appName "PDFsam Basic" -source "winget"
        Install-Using-Winget -appId "XPFFH613W8V6LV" -appName "OBS Studio" -source "msstore"
        Install-Using-Winget -appId "Plex.Plex" -appName "Plex" -source "winget"
        Install-Using-Winget -appId "Olivia.VIA" -appName "VIA" -source "winget"
        Install-Using-Winget -appId "qBittorrent.qBittorrent" -appName "qBittorrent" -source "winget"
    }

    if($installCreationTools) {
        Write-Host "Installing creation tools" -ForegroundColor Cyan
        Install-Using-Winget -appId "9PP3C07GTVRH" -appName "Blender" -source "msstore"
        Install-Using-Winget -appId "Figma.Figma" -appName "Figma" -source "winget"
        Install-Using-Winget -appId "9nblggh35lrm" -appName "Affinity Designer" -source "msstore"
        Install-Using-Winget -appId "9nblggh35lxn" -appName "Affinity Photo" -source "msstore"
        Install-Using-Winget -appId "9nblggh35lzr" -appName "Affinity Publisher" -source "msstore"
        Install-Using-Winget -appId "MarkText.MarkText" -appName "Mark Text" -source "winget"
    }

    if($installGameLaunchers) {
        Write-Host "Installing game launchers" -ForegroundColor Cyan
        #Install-Using-Winget -appId "9PGW18NPBZV5" -appName "Minecraft Launcher" -source "msstore"
        Install-Using-Winget -appId "Valve.Steam" -appName "Steam" -source "winget"
        Install-Using-Winget -appId "ElectronicArts.EADesktop" -appName "EA app" -source "winget"
        Install-Using-Winget -appId "Ubisoft.Connect" -appName "Ubisoft Connect" -source "winget"
        Install-Using-Winget -appId "EpicGames.EpicGamesLauncher" -appName "Epic Games Launcher" -source "winget"
        Install-Using-Winget -appId "GOG.Galaxy" -appName "GOG GALAXY" -source "winget"
        #Install-Using-Winget -appId "" -appName "" -source "winget"
    }

    Write-Host "Affinity Designer: " -NoNewline -ForegroundColor Red
    Write-Host "ms-windows-store://pdp/?ProductId=9nblggh35lrm" -ForegroundColor Blue
    Write-Host "Affinity Photo: " -NoNewline -ForegroundColor Red
    Write-Host "ms-windows-store://pdp/?ProductId=9nblggh35lxn" -ForegroundColor Blue
    Write-Host "Affinity Publisher: " -NoNewline -ForegroundColor Red
    Write-Host "ms-windows-store://pdp/?ProductId=9nblggh35lzr" -ForegroundColor Blue
    Write-Host "DaVinci Resolve 17: " -NoNewline -ForegroundColor Red
    Write-Host "https://www.blackmagicdesign.com/products/davinciresolve/" -ForegroundColor Blue
    Write-Host "Office 365: " -NoNewline -ForegroundColor Red
    Write-Host "https://portal.office.com/" -ForegroundColor Blue
    Write-Host "Battle.net Desktop App: " -NoNewline -ForegroundColor Red
    Write-Host "https://www.blizzard.com/en-us/apps/battle.net/desktop" -ForegroundColor Blue
    Write-Host "MinGit: " -NoNewline -ForegroundColor Red
    Write-Host "https://github.com/git-for-windows/git/releases" -ForegroundColor Blue
    Write-Host "youtube-dl: " -NoNewline -ForegroundColor Red
    Write-Host "https://github.com/ytdl-org/youtube-dl" -ForegroundColor Blue

}

function Setup-Git {
    git config --global user.name "Gergő Radeczki"
    git config --global user.email "g.radeczki@gmail.com"
    git config --global core.editor "~\AppData\Local\Programs\Microsoft VS Code\Code.exe"
    git config --global init.defaultBranch main
    git config --global core.ignorecase false
}
