function Get-吴乐川求用于安全输出文件的文件路径 {
    Param (
        [string]  $期望采用的输出文件之完整路径,
        [string[]]$要求最终采用的输出文件之完整路径不能为该列表中之任一,
        [string]  $要求避讳的文件路径列表的描述性名称 = '本程序之输入文件',
        [switch]  $同时要求磁盘尚上不存在该文件
    )



    PROCESS {
        [string]$存放输出文件之文件夹之完整路径 = Split-Path ([io.fileinfo]"$期望采用的输出文件之完整路径")

        [string]$输出文件之文件基本名 = ([io.fileinfo]"$期望采用的输出文件之完整路径").BaseName
        [string]$输出文件之文件扩展名 = ([io.fileinfo]"$期望采用的输出文件之完整路径").Extension

        [string]$输出文件之完整路径 = Join-Path "${存放输出文件之文件夹之完整路径}" "${输出文件之文件基本名}${输出文件之文件扩展名}"
        [string]$单级缩进之空白 = '    '

        [boolean]$期望的文件路径不合规 = $false

        if ("${输出文件之完整路径}" -in $要求最终采用的输出文件之完整路径不能为该列表中之任一) {

            $期望的文件路径不合规 = $true

            Write-Host
            Write-Host -No -F 'Yellow' '下列文件已经在 “'
            Write-Host -No -F 'Red'    "${要求避讳的文件路径列表的描述性名称}"
            Write-Host     -F 'Yellow' '” 之列：'
            Write-Host -No             "${单级缩进之空白}"
            Write-Host     -F 'Red'    "${输出文件之完整路径}"
            Write-Host     -F 'Yellow' '故其不应被当作输出文件，否则相关文件将被改动或覆盖！'

        } elseif ($同时要求磁盘尚上不存在该文件 -and $(Test-Path "${输出文件之完整路径}" -PathType 'Leaf')) {

            $期望的文件路径不合规 = $true

            Write-Host
            Write-Host     -F 'Yellow' '下列文件已经被存在于磁盘上（或目标位置）:'
            Write-Host -No             "${单级缩进之空白}"
            Write-Host     -F 'Red'    "${输出文件之完整路径}"
            Write-Host     -F 'Yellow' '故不应被当作输出文件，否则该已有文件将被改动或覆盖！'

        }



        if ($期望的文件路径不合规) {
            [int]$文件后缀编号 = 0

            [boolean]$求得的输出文件路径尚不靠谱 = $true

            while ($求得的输出文件路径尚不靠谱) {
                $文件后缀编号++

                [string]$输出文件拟采用之文件名 = "${输出文件之文件基本名}_(${文件后缀编号})${输出文件之文件扩展名}"
                $输出文件之完整路径 = Join-Path "${存放输出文件之文件夹之完整路径}" "${输出文件拟采用之文件名}"

                $求得的输出文件路径尚不靠谱 = (
                    "${输出文件之完整路径}" -in $要求最终采用的输出文件之完整路径不能为该列表中之任一
                ) -or (
                    $同时要求磁盘尚上不存在该文件 -and $(Test-Path "${输出文件之完整路径}" -PathType 'Leaf')
                )
            }

            Write-Host     -F 'White' '程序已自动求出一个安全的文件路径，如下：'
            Write-Host -No            "${script:单级缩进之空白}"
            Write-Host     -F 'Green' "${输出文件之完整路径}"
            Write-Host
        }
    }



    END {
        "${输出文件之完整路径}"
    }
}





Export-ModuleMember -Function *
