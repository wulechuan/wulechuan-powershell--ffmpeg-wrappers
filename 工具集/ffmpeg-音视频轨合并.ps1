BEGIN {
    # 关键常量集（故意置顶）
    ${script:产生的文件应置于源文件所在的文件夹内} = $true





    Write-Host
    Write-Host     -F 'DarkGray' '---------------------------------------------------------------------------------------'

    Write-Host                   '本工具之简介'
    Write-Host
    Write-Host                   '将'
    Write-Host
    Write-Host                   '    -   2 个【录像】文件'
    Write-Host                   '    -   或 1 个【录像】文件和 1 个【录音】文件'
    Write-Host
    Write-Host                   '同时拖放至本程序之图标上，本程序即会将'
    Write-Host
    Write-Host                   '    -   其中代表【声音】来源文件的第 1 条【音轨】'
    Write-Host                   '    -   与代表【画面】来源文件的第 1 条【视频轨】（一般仅见 1 条）'
    Write-Host
    Write-Host                   '合并成全新的【录像】文件。'

    Write-Host     -F 'DarkGray' '---------------------------------------------------------------------------------------'
    Write-Host
    Write-Host
    Write-Host





    Write-Host               '工作文件夹：'
    Write-Host -No           "    '"
    Write-Host -No -F 'Blue' (Get-Location)
    Write-Host               "'"
    Write-Host

    [string]$本工具集之存放文件夹之完整路径 = (Get-Location)
    if ((
        -not (Test-Path -PathType 'Container' "$本工具集之存放文件夹之完整路径")
    ) -or (
        -not (Test-Path -PathType 'Container' "$本工具集之存放文件夹之完整路径\通用辅助工具集")
    )) {
        Write-Host
        Write-Error "工作文件夹不是`“存放本工具集之文件夹`”，故而无法定位必要的通用工具。本程序无法如期运行。"
        Write-Host
        Exit 19
    }

    # Write-Host               '存放本工具集之文件夹：'
    # Write-Host -No           "    '"
    # Write-Host -No -F 'Blue' "$本工具集之存放文件夹之完整路径"
    # Write-Host               "'"
    # Write-Host

    Import-Module  "${本工具集之存放文件夹之完整路径}\通用辅助工具集\Get-Windows用户桌面之完整路径.psm1"
    Import-Module  "${本工具集之存放文件夹之完整路径}\通用辅助工具集\Import-吴乐川从批处理命令接受文件路径之列表.psm1"
    Import-Module  "${本工具集之存放文件夹之完整路径}\通用辅助工具集\Edit-吴乐川剥去文本最外层的引号.psm1"
    Import-Module  "${本工具集之存放文件夹之完整路径}\通用辅助工具集\Get-吴乐川求用于安全输出文件的文件路径.psm1"
    Import-Module  "${本工具集之存放文件夹之完整路径}\通用辅助工具集\Read-吴乐川询问是或否.psm1"

    .  "${本工具集之存放文件夹之完整路径}\..\专用于本机之配置.ps1"

    [string]${Windows用户桌面之完整路径} = Get-Windows用户桌面之完整路径
    [string]${script:用于放置产生的文件的默认文件夹完整路径} = "${Windows用户桌面之完整路径}\${global:位于用户桌面的_默认用于存放产生的文件的_文件夹的名称}"





    # 次要常量集
    [string]${script:单级缩进之空白} = '    '
    [int]   ${script:本程序所需输入文件之总个数} = 2

    ${script:文件通途之文本之特征颜色} = @{
        画面 = 'Cyan'
        声音 = 'Magenta'
        产出 = 'Green'
    }





    [string[]]${script:外界给出的文件路径之列表} = Expand-吴乐川从PowerShell的Args参数解析出文件路径列表 "$args"
    [int]${script:外界给出的输入文件路径之个数} = ${script:外界给出的文件路径之列表}.Length

    Write-Host
    Write-Host
    Write-Host
    Write-Host -No               '批处理共传入 '
    Write-Host -No -F 'Red'      ${script:外界给出的输入文件路径之个数}
    Write-Host                   ' 个路径'

    Write-Host     -F 'DarkGray' '---------------------------------------------------------------------------------------'

    if (${script:外界给出的输入文件路径之个数} -gt 0) {
        ${script:外界给出的文件路径之列表}.ForEach({
            [string]$该路径之安全版本 = "$_"
            [string]$该路径之安全版本 = "${该路径之安全版本}" -replace '([\[\]])', '`$1'

            [boolean]$该文件路径有效 = Test-Path "${该路径之安全版本}" -PathType 'Leaf'
            [boolean]$该路径有效但是是文件夹 = (-not $该文件路径有效) -and $(Test-Path "${该路径之安全版本}" -PathType 'Container')

            if ($该文件路径有效) {
                Write-Host -No -F 'Green' '可以访问：'
                Write-Host -No            "'"
                Write-Host -No -F 'Green' "$_"
                Write-Host                "'"
            } else {
                if ($该路径有效但是是文件夹) {
                    Write-Host -No -F 'Magenta' '是文件夹：'
                    Write-Host -No               "'"
                    Write-Host -No -F 'Magenta' "$_"
                    Write-Host
                } else {
                    Write-Host -No -F 'Red'     '不可访问：'
                    Write-Host -No              "'"
                    Write-Host -No -F 'Red'     "$_"
                    Write-Host
                }
            }
        })
    } else {
        Write-Host -F 'DarkGray' '<无>'
        Exit 0
    }





    [string[]]${script:外界给出的有效文件路径之列表} = ${script:外界给出的文件路径之列表}.Where{
        [string]$该路径之安全版本 = "$_"
        [string]$该路径之安全版本 = "${该路径之安全版本}" -replace '([\[\]])', '`$1'

        [boolean]$该文件路径有效 = Test-Path "${该路径之安全版本}" -PathType 'Leaf'
        $该文件路径有效
    }

    [int]${script:外界给出的有效输入文件之个数} = ${script:外界给出的有效文件路径之列表}.Length

    if (${script:外界给出的有效输入文件之个数} -ne ${script:外界给出的输入文件路径之个数}) {
        Write-Host
        Write-Host
        Write-Host
        Write-Host                   '批处理传入的某些路径无效。无效的原因可能是：'
        Write-Host                   '  - 其为文件夹之路径，而非文件之路径；'
        Write-Host                   '  - 其指向的文件不存在；'
        Write-Host                   '  - 其指向的文件虽然存在，但因该文件自身之状态、当前用户权限等因素影响不可访问。'
        Write-Host
        Write-Host -No               '传入的路径中，有效的有 '
        Write-Host -No -F 'Red'      ${script:外界给出的有效输入文件之个数}
        Write-Host                   ' 个'

        Write-Host     -F 'DarkGray' '---------------------------------------------------------------------------------------'

        if (${script:外界给出的有效输入文件之个数} -gt 0) {
            ${script:外界给出的有效文件路径之列表}.ForEach({ "$_" })
        } else {
            Write-Host -F 'DarkGray' '<无>'
            Exit 0
        }
    }





    if (${script:外界给出的有效输入文件之个数} -gt ${script:本程序所需输入文件之总个数}) {
        Write-Host
        Write-Error "输入文件不止 ${script:本程序所需输入文件之总个数} 个，本程序无所适从。"
        Write-Host
        Exit 2
    }





    if (-not ${script:产生的文件应置于源文件所在的文件夹内}) {
        if (-not (Test-Path "${script:用于放置产生的文件的默认文件夹完整路径}" -PathType 'Container')) {
            Write-Host
            Write-Host
            Write-Host
            Write-Host              '现在在桌面上创建“用于放置产生的文件的默认文件夹”，'
            Write-Host -No          '名为 "'
            Write-Host -No -F 'Red' "${global:位于用户桌面的_默认用于存放产生的文件的_文件夹的名称}"
            Write-Host -No          '" 。'
            Write-Host
            New-Item -Path "${script:用于放置产生的文件的默认文件夹完整路径}" -Type 'Directory'
        }
    }
}





PROCESS {
    function Measure-统计已给出的输入文件之个数 {
        ${script:外界给出的有效输入文件之个数} = ${script:外界给出的有效文件路径之列表}.Length
        ${script:仍缺少的输入文件之个数} = ${script:本程序所需输入文件之总个数} - ${script:外界给出的有效输入文件之个数}
    }



    function Read-询问单个输入文件之完整路径 {
        function Write-题干头部 {
            Write-Host -No            '本工具要求给出 '
            Write-Host -No -F 'White' ${script:本程序所需输入文件之总个数}
            Write-Host -No            ' 个输入文件。'
            Write-Host

            Write-Host -No            '而目前仅获得 '
            Write-Host -No -F 'Green' ${script:外界给出的有效输入文件之个数}
            Write-Host -No            ' 个输入文件，仍缺少 '
            Write-Host -No -F 'Red'   ${script:仍缺少的输入文件之个数}
            Write-Host -No            ' 个'。
            Write-Host
        }

        function Write-题干核心 {
            Write-Host -No          '请给出第 '
            Write-Host -No -F 'Red' (${script:外界给出的有效输入文件之个数} + 1)
            Write-Host -No          ' 个输入文件的路径：'
            Write-Host
        }

        [boolean]$已获取有效的文件路径 = $false
        [int]    $连续给出无效文件路径的累计次数 = 0
        [boolean]$累计无效输入的次数过多 = $false

        while (-not $已获取有效的文件路径) {

            if ($连续给出无效文件路径的累计次数 -eq 0) {

                Write-Host
                Write-Host
                Write-Host

                if ($累计无效输入的次数过多) {
                    # $累计无效输入的次数过多 = $false

                    Write-Host -F 'DarkGray' '累计的无效输入次数过多，'
                    Write-Host -F 'DarkGray' '故下方重新给出完整题干，作为提醒。'
                    Write-Host
                }

                Write-题干头部
            } else {
                Write-Host -F 'DarkGray' '刚才输入的文件路径无效。'
            }

            Write-Host
            Write-题干核心

            $本次询问获得的文件路径 = Edit-吴乐川剥去文本最外层的引号 $(Read-Host)

            $已获取有效的文件路径 = $false

            if (Test-path "$本次询问获得的文件路径" -PathType 'Leaf') {

                if ($本次询问获得的文件路径 -in ${script:外界给出的有效文件路径之列表}) {

                    Write-Host -F 'Red' "该文件之前已经给出了。不能重复给出。"

                } else {

                    $已获取有效的文件路径 = $true

                    $累计无效输入的次数过多 = $false
                    $连续给出无效文件路径的累计次数 = 0
                }

            } elseif (Test-path "$本次询问获得的文件路径" -PathType 'Container') {

                Write-Host -F 'Red' "给出的是文件夹，而不是文件。文件夹是不行的。"

            }



            if (-not $已获取有效的文件路径) {

                $连续给出无效文件路径的累计次数++

                if ($连续给出无效文件路径的累计次数 -ge 4) {
                    $累计无效输入的次数过多 = $true
                    $连续给出无效文件路径的累计次数 = 0
                } else {
                    $累计无效输入的次数过多 = $false
                }

            }
        }



        if ($已获取有效的文件路径) {
            ${script:外界给出的有效文件路径之列表} += @( $本次询问获得的文件路径 )
            Measure-统计已给出的输入文件之个数
        }
    }



    function Read-按需询问所有输入文件之完整路径 {
        while (${script:仍缺少的输入文件之个数} -gt 0) {
            Read-询问单个输入文件之完整路径
        }
    }



    function Read-询问将产生的文件的文件名 {
        Param (
            [string] $输出文件之默认文件名,
            [string] $推荐采用的输出文件夹之完整路径
        )



        PROCESS {
            Write-Host
            Write-Host -No                                           '如有必要，请填写 '
            Write-Host -No -F ${script:文件通途之文本之特征颜色}['产出'] '输出'
            Write-Host                                               ' 文件的文件名。'
            Write-Host                                               '如果不给出，则默认采用该文件名：'
            Write-Host -No                                           "${script:单级缩进之空白}"
            Write-Host     -F ${script:文件通途之文本之特征颜色}['产出'] "${输出文件之默认文件名}"

            Write-Host
            Write-Host '请输入文件名：'

            [string]${local:给出的输出文件之文件名或文件路径} = Edit-吴乐川剥去文本最外层的引号 $(Read-Host)

            if (-not ${local:给出的输出文件之文件名或文件路径}) {
                [string]${local:输出文件之文件名}             = "${输出文件之默认文件名}"
                [string]${local:存放输出文件之文件夹之完整路径} = "${推荐采用的输出文件夹之完整路径}"
            } else {
                [string]${local:输出文件之文件名} = Split-Path -Leaf -Path "${local:给出的输出文件之文件名或文件路径}"



                [string]${local:输出文件最终采纳的扩展名} = ([io.fileinfo]"${local:给出的输出文件之文件名或文件路径}").Extension
                if (-not "${输出文件最终采纳的扩展名}") {
                    [string]$输出文件最终采纳的扩展名 = ([io.fileinfo]"${输出文件之默认文件名}").Extension
                    ${local:输出文件之文件名} = "${local:输出文件之文件名}${输出文件最终采纳的扩展名}"
                }
                Write-Host
                Write-Host -No            "注意：输出文件的扩展名将为 '"
                Write-Host -No -F 'Green' "${输出文件最终采纳的扩展名}"
                Write-Host                "' 。"



                [string]${local:存放输出文件之文件夹之给出路径} = Split-Path "${local:给出的输出文件之文件名或文件路径}"

                [boolean]$刚才用户给出的是绝对路径 = Split-Path -Path "${local:给出的输出文件之文件名或文件路径}" -IsAbsolute
                if ($刚才用户给出的是绝对路径) {
                    [string]${local:存放输出文件之文件夹之完整路径} =                                           "${local:存放输出文件之文件夹之给出路径}"
                } else {
                    [string]${local:存放输出文件之文件夹之完整路径} = Join-Path "${推荐采用的输出文件夹之完整路径}" "${local:存放输出文件之文件夹之给出路径}"
                }
            }



            [string]${local:输出文件之完整路径} = Join-Path "${local:存放输出文件之文件夹之完整路径}" "${local:输出文件之文件名}"
        }



        END {
            "${local:输出文件之完整路径}"
        }
    }



    function Write-展示两个输入文件的摘要 () {
        Write-Host
        Write-Host                                               '作为画面源的文件：'
        Write-Host -No                                           "${script:单级缩进之空白}"
        Write-Host     -F ${script:文件通途之文本之特征颜色}['画面'] "$作为画面源的文件之完整路径"

        Write-Host
        Write-Host                                               '作为声音源的文件：'
        Write-Host -No                                           "${script:单级缩进之空白}"
        Write-Host     -F ${script:文件通途之文本之特征颜色}['声音'] "$作为声音源的文件之完整路径"
    }



    function Write-展示将产生的新文件的摘要 {
        Write-Host
        Write-Host                                           '将产生的文件：'
        Write-Host -No                                       "${script:单级缩进之空白}"
        Write-Host -F ${script:文件通途之文本之特征颜色}['产出'] "${输出文件之完整路径}"
    }





    Write-Host
    Write-Host
    Write-Host



    Measure-统计已给出的输入文件之个数
    Read-按需询问所有输入文件之完整路径



    [string]$作为画面源的文件之完整路径 = ${script:外界给出的有效文件路径之列表}[0]
    [string]$作为声音源的文件之完整路径 = ${script:外界给出的有效文件路径之列表}[1]



    function Write-题干之是否对调输入文件 {
        Write-Host
        Write-Host
        Write-Host

        Write-展示两个输入文件的摘要

        Write-Host
        Write-Host -F 'White' '是否对调上述两个文件的用途？'
    }

    [boolean]$应对调两个输入源文件之用途 = Read-吴乐川询问是或否 `
        -问题题干文本_或_用以打印问题题干的函数 ${Function:Write-题干之是否对调输入文件} `
        -代表_是_之界面措辞 '是的，&对调二者的用途' `
        -代表_是_之值 'd' `
        -代表_否_之界面措辞 '&不必对调，保持原状' `
        -代表_否_之值 'b'
        # -不准采用默认值

    if ($应对调两个输入源文件之用途) {
        $作为画面源的文件之完整路径 = ${script:外界给出的有效文件路径之列表}[1]
        $作为声音源的文件之完整路径 = ${script:外界给出的有效文件路径之列表}[0]

        Write-展示两个输入文件的摘要
    }





    [string]$作为画面输入文件之文件基本名 = ([io.fileinfo]"$作为画面源的文件之完整路径").BaseName
    [string]$作为画面输入文件之文件扩展名 = ([io.fileinfo]"$作为画面源的文件之完整路径").Extension

    [string]${script:输出文件之默认文件名} = "${作为画面输入文件之文件基本名}-替换了声音${作为画面输入文件之文件扩展名}"

    if (${script:产生的文件应置于源文件所在的文件夹内}) {
        [string]$推荐采用的输出文件夹之完整路径 = Split-Path "$作为画面源的文件之完整路径"
    } else {
        [string]$推荐采用的输出文件夹之完整路径 = "${script:用于放置产生的文件的默认文件夹完整路径}"
    }

    [string]$输出文件之完整路径 = Read-询问将产生的文件的文件名 `
        -输出文件之默认文件名 "${script:输出文件之默认文件名}" `
        -推荐采用的输出文件夹之完整路径 "${推荐采用的输出文件夹之完整路径}"



    $输出文件之完整路径 = Get-吴乐川求用于安全输出文件的文件路径 `
        -期望采用的输出文件之完整路径 "${输出文件之完整路径}" `
        -要求最终采用的输出文件之完整路径不能为该列表中之任一 ${script:外界给出的有效文件路径之列表} # `
        # -同时要求磁盘尚上不存在该文件

    ${存放输出文件之文件夹之完整路径} = Split-Path "${输出文件之完整路径}"

    # Write-展示将产生的新文件的摘要





    function Write-题干甲 {
        Write-Host
        Write-Host
        Write-Host

        Write-展示两个输入文件的摘要
        Write-展示将产生的新文件的摘要

        Write-Host
        Write-Host -F 'White' '以上配置均正确吗？'
    }



    [boolean]$已确认无误可继续 = Read-吴乐川询问是或否 `
        -问题题干文本_或_用以打印问题题干的函数 ${Function:Write-题干甲} `
        -代表_是_之值 's' `
        -代表_否_之值 'f' `
        -默认应取_是
        # -不准采用默认值



    [boolean]$已成功 = $false
    if (-not $已确认无误可继续) {
        Write-Host
        Write-Host -F 'Red' '你刚才未确认（未选“是”）。'
        Write-Host -F 'Red' '程序将退出。'
        Exit 9
    } else {
        Write-Host

        try {
            # * * * * * * * * * * * * * * * * * * * * * * * *
            # * * * * * * * * * * * * * * * * * * * * * * * *
            # * * * * * * * * * * * * * * * * * * * * * * * *

            Write-Host
            Write-Host -F 'DarkGray' '-----------------------------------------------------------------'
            Write-Host               "`"${global:ffmpeg可执行程序的完整路径}`" ``"
            Write-Host               "${script:单级缩进之空白}-i `"${作为画面源的文件之完整路径}`" ``"
            Write-Host               "${script:单级缩进之空白}-i `"${作为声音源的文件之完整路径}`" ``"
            Write-Host               "${script:单级缩进之空白}-map 0:v ``"
            Write-Host               "${script:单级缩进之空白}-map 1:a ``"
            Write-Host               "${script:单级缩进之空白}-codec copy ``"
            Write-Host               "${script:单级缩进之空白}-y `"${输出文件之完整路径}`""
            Write-Host -F 'DarkGray' '-----------------------------------------------------------------'
            Write-Host

            & "${global:ffmpeg可执行程序的完整路径}" `
                -i "${作为画面源的文件之完整路径}" `
                -i "${作为声音源的文件之完整路径}" `
                -map 0:v `
                -map 1:a `
                -codec copy `
                -y "${输出文件之完整路径}"

            # * * * * * * * * * * * * * * * * * * * * * * * *
            # * * * * * * * * * * * * * * * * * * * * * * * *
            # * * * * * * * * * * * * * * * * * * * * * * * *



            if (Test-Path "${输出文件之完整路径}" -PathType 'Leaf') {
                Write-Host
                Write-Host -No -F 'Black' -B 'Green' ' 成功！'
                Write-Host                           ' '
                Write-Host

                Write-Host                           '已产生下述文件：'
                Write-Host -No                       "${script:单级缩进之空白}'"
                Write-Host -No -F 'Green'            "`"${输出文件之完整路径}`""
                Write-Host                           "'"
                Write-Host

                $已成功 = $true
            }
        } catch {
            $ExitCode = $?

            Write-Host
            Write-Host
            Write-Host
            Write-Error "失败！[$ExitCode]"
            Write-Host

            $已成功 = $false

            Exit 4
        }
    }
}





END {
    if ($已成功) {
        if ((
            "${存放输出文件之文件夹之完整路径}" -eq "${script:用于放置产生的文件的默认文件夹完整路径}"
        ) -and (
            "${存放输出文件之文件夹之完整路径}" -ne "${Windows用户桌面之完整路径}"
        )) {
            explorer "${存放输出文件之文件夹之完整路径}"
        }
    }
}
