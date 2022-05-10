function New-吴乐川为工具集中的单个工具创建快捷方式 {
    Param (
        [string] $工具源文件之文件名,
        [string] $工具所采用图标之文件名,
        [switch] $目标_图标_均应采用相对路径 # Windows 11 的快捷方式无法采用相对路径。可我记得 Windows XP 可以。其余版本的 Windows 未知。
    )



    BEGIN {
        $WScript = New-Object -ComObject WScript.Shell

        [string] $快捷方式文件之存放文件夹之完整路径 = Resolve-Path "$PWD\快捷方式集"

        if (Test-Path "$快捷方式文件之存放文件夹之完整路径") {
        } else {
            New-Item -Path "$快捷方式文件之存放文件夹之完整路径" -Type 'Directory'
        }

        [string] $工具源文件之存放文件夹之相对路径 = "..\工具集"
        [string] $图标文件之存放文件夹之相对路径 = "..\图标集"

        [string] $工具源文件之存放文件夹之完整路径 = Resolve-Path "$快捷方式文件之存放文件夹之完整路径\${工具源文件之存放文件夹之相对路径}"
        [string] $图标文件之存放文件夹之完整路径 = Resolve-Path "${快捷方式文件之存放文件夹之完整路径}\${图标文件之存放文件夹之相对路径}"

        if (Test-Path "$工具源文件之存放文件夹之完整路径") {
            # Write-Host -F 'Green' "工具源文件之存放文件夹确实存在： `"$工具源文件之存放文件夹之完整路径`""
        } else {
            Write-Error "工具源文件之存放文件夹不存在： `"$工具源文件之存放文件夹之完整路径`""
            Exit 2
        }

        if (Test-Path "$图标文件之存放文件夹之完整路径") {
            # Write-Host -F 'Green' "图标文件之存放文件夹确实存在： `"$图标文件之存放文件夹之完整路径`""
        } else {
            Write-Error "图标文件之存放文件夹不存在： `"$图标文件之存放文件夹之完整路径`""
            Exit 3
        }
    }



    PROCESS {
        [string] $快捷方式文件之完整路径 = "${快捷方式文件之存放文件夹之完整路径}\${工具源文件之文件名}.lnk"

        [string] $工具源文件之相对路径 = "${工具源文件之存放文件夹之相对路径}\${工具源文件之文件名}.bat"
        [string] $工具源文件之完整路径 = "${工具源文件之存放文件夹之完整路径}\${工具源文件之文件名}.bat"

        [string] $图标文件自身之相对路径 = "${图标文件之存放文件夹之相对路径}\${工具所采用图标之文件名}.ico"
        [string] $图标文件自身之完整路径 = "${图标文件之存放文件夹之完整路径}\${工具所采用图标之文件名}.ico"

        if ($目标_图标_均应采用相对路径) {
            [string] $工具源文件之采纳的路径 = "$工具源文件之相对路径"
            [string] $图标文件之采纳的路径 = "$图标文件自身之相对路径"
        } else {
            [string] $工具源文件之采纳的路径 = "$工具源文件之完整路径"
            [string] $图标文件之采纳的路径 = "$图标文件自身之完整路径"
        }

        $快捷方式 = $WScript.CreateShortcut("$快捷方式文件之完整路径")

        # $快捷方式 | Get-Memeber

        if (Test-Path "$工具源文件之完整路径") {
            Write-Host -F 'Green' "工具源文件确实存在： `"${工具源文件之完整路径}`""
            $快捷方式.IconLocation = "$工具源文件之采纳的路径"
        } else {
            Write-Error "工具源文件不存在： `"${工具源文件之完整路径}`""
        }

        if (Test-Path "$图标文件自身之完整路径") {
            Write-Host -F 'Blue' "图标文件确实存在：   `"${图标文件自身之完整路径}`""
            $快捷方式.IconLocation = "$图标文件之采纳的路径"
        } else {
            Write-Error "图标文件不存在： `"${图标文件自身之完整路径}`""
        }



        $快捷方式.TargetPath = "$工具源文件之采纳的路径"
        $快捷方式.Save()

        Write-Host
    }



    END {
        explorer "$快捷方式文件之完整路径"
    }
}
