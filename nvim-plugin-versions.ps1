
function nvim-plugin-versions {

    $pluginPath = "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start"
    $now = Get-Date

    Get-ChildItem $pluginPath -Directory | ForEach-Object {
        $name = $_.Name

        # Get current commit and date
        $currentCommit = git -C $_.FullName rev-parse HEAD
        $currentDateRaw = git -C $_.FullName show -s --format="%ci" HEAD
        $currentDate = [datetime]::Parse($currentDateRaw)
        $currentAgo = (New-TimeSpan -Start $currentDate -End $now)

        # Fetch latest info
        git -C $_.FullName fetch origin > $null 2>&1

        # Get latest commit and date
        $latestCommit = git -C $_.FullName rev-parse origin/HEAD
        $latestDateRaw = git -C $_.FullName show -s --format="%ci" origin/HEAD
        $latestDate = [datetime]::Parse($latestDateRaw)
        $latestAgo = (New-TimeSpan -Start $latestDate -End $now)

        # Friendly time formatting
        function Format-Ago ($ts) {
            if ($ts.TotalDays -lt 31) {
                return "{0:N0} days ago" -f $ts.TotalDays
            } else {
                return "{0:N0} months ago" -f ($ts.TotalDays / 30)
            }
        }

        $isUpToDate = if ($currentCommit -eq $latestCommit) { "Yes" } else { "No" }

        [PSCustomObject]@{
            Plugin         = $name
            CurrentCommit  = $currentCommit
            CurrentAge     = Format-Ago $currentAgo
            LatestCommit   = $latestCommit
            LatestAge      = Format-Ago $latestAgo
            UpToDate       = $isUpToDate
        }
    } | Format-Table
}

nvim-plugin-versions > plugin.commits.txt
