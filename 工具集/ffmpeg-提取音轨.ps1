BEGIN {
    # 关键常量集（故意置顶）
    ${script:产生的文件应置于源文件所在的文件夹内} = $true
    ${script:欲从输入文件中抓取的音轨之编号} = 1 # 暂时之支持第 1 条。因为来不及细究 ffmpeg 的输入参数细则。
    ${script:输出的录音文件的音量倍增率} = 2
    ${script:输出文件之扩展名_含英文句点} = '.wma'
    ${script:输出的录音文件采用的码率_单位为千比特每秒} = 256





    Write-Host
    Write-Host     -F 'DarkGray' '-----------------------------------------------------------------'

    Write-Host                   '本工具之简介'
    Write-Host
    Write-Host                   '将一个或若干各【录像】文件拖动至本程序之图标上，'

    Write-Host                   '本程序即逐一处理这些【录像】，'

    Write-Host -No               '将其'
    Write-Host -No -F 'Red'      "第 ${script:欲从输入文件中抓取的音轨之编号} 条【音轨】"
    Write-Host -No               '提取成一个 '
    Write-Host -No -F 'Yellow'   "${script:输出文件之扩展名_含英文句点}"
    Write-Host                   ' 文件。'

    Write-Host     -F 'DarkGray' '-----------------------------------------------------------------'
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
    Import-Module  "${本工具集之存放文件夹之完整路径}\通用辅助工具集\Get-吴乐川求用于安全输出文件的文件路径.psm1"
    Import-Module  "${本工具集之存放文件夹之完整路径}\通用辅助工具集\Read-吴乐川询问是或否.psm1"

    .  "${本工具集之存放文件夹之完整路径}\..\专用于本机之配置.ps1"

    [string]${script:用于放置产生的文件的默认文件夹完整路径} = "$(Get-Windows用户桌面之完整路径)\${global:位于用户桌面的_默认用于存放产生的文件的_文件夹的名称}"





    # 次要常量集
    [string]${script:单级缩进之空白} = '    '





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
    Write-Host
    Write-Host
    Write-Host



    [int]$正在处理的输入文件之计数 = 0

    ForEach ($输入文件之完整路径 in ${script:外界给出的有效文件路径之列表}) {
        $正在处理的输入文件之计数++



        [string]$存放输入文件之文件夹之完整路径 = Split-Path ([io.fileinfo]"$输入文件之完整路径")
        [string]$输入文件之文件基本名 = ([io.fileinfo]"$输入文件之完整路径").BaseName
        # [string]$输入文件之文件扩展名 = ([io.fileinfo]"$输入文件之完整路径").Extension

        [string]$输出文件之文件名 = "${输入文件之文件基本名}-音轨${script:欲从输入文件中抓取的音轨之编号}${script:输出文件之扩展名_含英文句点}"

        [string]$存放输出文件之文件夹之完整路径 = "${script:用于放置产生的文件的默认文件夹完整路径}"
        if (${script:产生的文件应置于源文件所在的文件夹内}) {
            $存放输出文件之文件夹之完整路径 = "${存放输入文件之文件夹之完整路径}"
        }

        [string]$输出文件之完整路径 = Join-Path "${存放输出文件之文件夹之完整路径}" "${输出文件之文件名}"

        $输出文件之完整路径 = Get-吴乐川求用于安全输出文件的文件路径 `
            -期望采用的输出文件之完整路径 "$输出文件之完整路径" `
            -要求最终采用的输出文件之完整路径不能为该列表中之任一 ${script:外界给出的有效文件路径之列表} # `
            # -同时要求磁盘尚上不存在该文件



        [boolean]$可继续处理下一个输入文件 = $false

        While (-not $可继续处理下一个输入文件) {
            Write-Host
            Write-Host
            Write-Host
            Write-Host     -F 'DarkGray' '---------------------------------------------------------------------------------------'

            Write-Host -No               '现在开始处理第 '
            Write-Host -No -F 'Cyan'     ${正在处理的输入文件之计数}
            Write-Host -No               ' / '
            Write-Host -No -F 'White'    ${script:外界给出的有效输入文件之个数}
            Write-Host                   ' 个录像源文件：'

            Write-Host -No               "${script:单级缩进之空白}"
            Write-Host     -F 'Cyan'     "${输入文件之完整路径}"

            Write-Host                   '将产生该文件：'

            Write-Host -No               "${script:单级缩进之空白}"
            Write-Host     -F 'Green'    "${输出文件之完整路径}"

            Write-Host     -F 'DarkGray' '---------------------------------------------------------------------------------------'
            Write-Host





            [boolean]$已确认无误可继续 = $true

            if (-not $已确认无误可继续) {
                # Write-Host -F 'Red' '接下来程序将重新处理刚才的文件。'
            } else {
                Write-Host

                try {
                    # if (Test-Path "${输出文件之完整路径}" -PathType 'Leaf') {
                    #     Remove-Item "${输出文件之完整路径}"
                    # }



                    # * * * * * * * * * * * * * * * * * * * * * * * *
                    # * * * * * * * * * * * * * * * * * * * * * * * *
                    # * * * * * * * * * * * * * * * * * * * * * * * *

                    Write-Host
                    Write-Host -F 'DarkGray' '-----------------------------------------------------------------'
                    Write-Host               "`"${global:ffmpeg可执行程序的完整路径}`" ``"
                    Write-Host               "${script:单级缩进之空白}-i `"${输入文件之完整路径}`" ``"
                    Write-Host               "${script:单级缩进之空白}-map 0:a ``"
                    Write-Host               "${script:单级缩进之空白}-af `"volume=${script:输出的录音文件的音量倍增率}`" ``"
                    Write-Host               "${script:单级缩进之空白}-b:a `"$(${script:输出的录音文件采用的码率_单位为千比特每秒})k`" ``"
                    Write-Host               "${script:单级缩进之空白}-y `"${输出文件之完整路径}`""
                    Write-Host -F 'DarkGray' '-----------------------------------------------------------------'
                    Write-Host

                    & "${global:ffmpeg可执行程序的完整路径}" `
                        -i "${输入文件之完整路径}" `
                        -map 0:a `
                        -af "volume=${script:输出的录音文件的音量倍增率}" `
                        -b:a "$(${script:输出的录音文件采用的码率_单位为千比特每秒})k" `
                        -y "${输出文件之完整路径}"

                    if (-not $?) {
                        Write-Host
                        throw
                    }

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
                    }



                    $可继续处理下一个输入文件 = $true
                } catch {
                    $ExitCode = $?



                    function Write-题干乙 {
                        Write-Host     -F 'Red'    '处理该源文件'
                        Write-Host -No             "${script:单级缩进之空白}"
                        Write-Host     -F 'Yellow' "${输入文件之完整路径}"
                        Write-Host     -F 'Red'    "失败！[$ExitCode]"

                        Write-Host     -F 'White'  '要跳过该文件处理后续文件吗？'
                    }



                    [boolean]$跳过该文件并继续后续处理 = Read-吴乐川询问是或否 `
                        -问题题干文本_或_用以打印问题题干的函数 ${Function:Write-题干乙} `
                        -代表_是_之界面措辞 '是的，&跳过它' `
                        -代表_是_之值 't' `
                        -代表_否_之界面措辞 '不跳过，&再试一次' `
                        -代表_否_之值 'z' `
                        -不准采用默认值



                    $可继续处理下一个输入文件 = $跳过该文件并继续后续处理
                }
            }
        } # While 结束
    } # ForEach 结束
}





END {
    if (-not ${script:产生的文件应置于源文件所在的文件夹内}) {
        explorer "${script:用于放置产生的文件的默认文件夹完整路径}"
    }
}
