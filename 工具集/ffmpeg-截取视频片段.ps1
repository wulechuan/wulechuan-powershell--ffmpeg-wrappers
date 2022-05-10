BEGIN {
    # 关键常量集（故意置顶）
    ${script:产生的文件应置于源文件所在的文件夹内} = $true





    Write-Host
    Write-Host     -F 'DarkGray' '---------------------------------------------------------------------------------------'
    Write-Host                   '本工具之简介'
    Write-Host
    Write-Host                   '将一个或若干个【录音】或【录像】文件拖动至本程序之图标上，'
    Write-Host                   '对于给出的每一个文件，本程序都会询问【起】、【迄】两个时刻，'
    Write-Host                   '并据此从该文件中截取一个片段保存成全新的【录音】或【录像】文件。'
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

    .  "${本工具集之存放文件夹之完整路径}\通用辅助工具集\Get-Windows用户桌面之完整路径.ps1"
    .  "${本工具集之存放文件夹之完整路径}\通用辅助工具集\Import-吴乐川从批处理命令接受文件路径之列表.ps1"
    .  "${本工具集之存放文件夹之完整路径}\通用辅助工具集\Edit-吴乐川求安全的文件路径用于输出.ps1"
    .  "${本工具集之存放文件夹之完整路径}\通用辅助工具集\Read-吴乐川要求输入-ffmpeg-时间值.ps1"
    .  "${本工具集之存放文件夹之完整路径}\通用辅助工具集\Read-吴乐川询问是或否.ps1"
    .  "${本工具集之存放文件夹之完整路径}\..\专用于本机之配置.ps1"

    [string]${script:用于放置产生的文件的默认文件夹完整路径} = "$(Get-Windows用户桌面之完整路径)\${global:位于用户桌面的_默认用于存放产生的文件的_文件夹的名称}"





    # 次要常量集
    [string]${script:单级缩进之空白} = '    '





    [string[]]${script:外界给出的文件路径之列表} = Expand-吴乐川从PowerShell的Args参数解析出文件路径列表 "$args"
    [int]${script:外界给出的输入文件路径之个数} = ${script:外界给出的文件路径之列表}.Length

    Write-Host
    Write-Host
    Write-Host
    Write-Host -No               'BAT 共传入 '
    Write-Host -No -F 'Red'      ${script:外界给出的输入文件路径之个数}
    Write-Host                   ' 个文件路径'

    Write-Host     -F 'DarkGray' '---------------------------------------------------------------------------------------'

    if (${script:外界给出的输入文件路径之个数} -gt 0) {
        ${script:外界给出的文件路径之列表}.ForEach({
            $该文件路径有效 = Test-Path "$_" -PathType 'Leaf'
            if ($该文件路径有效) {
                Write-Host -F 'Green' "有效： '$_'"
            } else {
                Write-Host -F 'Red'   "无效： '$_'"
            }
        })
    } else {
        Write-Host -F 'DarkGray' '<无>'
        Exit 0
    }





    [string[]]${script:外界给出的有效文件路径之列表} = ${script:外界给出的文件路径之列表}.Where{ Test-Path "$_" -PathType 'Leaf' }
    [int]${script:外界给出的有效输入文件之个数} = ${script:外界给出的有效文件路径之列表}.Length

    if (${script:外界给出的有效输入文件之个数} -ne ${script:外界给出的输入文件路径之个数}) {
        Write-Host
        Write-Host                   'BAT 传入的某些文件路径无效，其对应的文件不存在或不可访问。'
        Write-Host -No               '其中有效的文件路径有 '
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
        [string]$输入文件之文件扩展名 = ([io.fileinfo]"$输入文件之完整路径").Extension

        [string]$输出文件之文件名 = "${输入文件之文件基本名}-截取${输入文件之文件扩展名}"

        [string]$存放输出文件之文件夹之完整路径 = "${script:用于放置产生的文件的默认文件夹完整路径}"
        if (${script:产生的文件应置于源文件所在的文件夹内}) {
            $存放输出文件之文件夹之完整路径 = "${存放输入文件之文件夹之完整路径}"
        }

        [string]$输出文件之完整路径 = Join-Path "${存放输出文件之文件夹之完整路径}" "${输出文件之文件名}"

        $输出文件之完整路径 = Edit-吴乐川求安全的文件路径用于输出 `
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
            Write-Host                   ' 个录像或录音的源文件：'

            Write-Host -No               "${script:单级缩进之空白}"
            Write-Host     -F 'Cyan'     "${输入文件之完整路径}"

            Write-Host

            Write-Host                   '将产生下述文件：'
            Write-Host -No               "${script:单级缩进之空白}"
            Write-Host     -F 'Green'    "${输出文件之完整路径}"

            Write-Host     -F 'DarkGray' '---------------------------------------------------------------------------------------'
            Write-Host

            $起始时刻 = Read-吴乐川要求输入FFMPEG时间值 -欲读取之值之称谓 '截取的“起始”时刻' -默认值 '0:00:00'
            $结束时刻 = Read-吴乐川要求输入FFMPEG时间值 -欲读取之值之称谓 '截取的“结束”时刻' -默认值 '' -刚才的交互已有类同功能_此次不妨采用极简界面

            if (-not "$起始时刻" -and -not "$结束时刻") {
                Clear-Host

                Write-Host -F 'Red' '刚才既没有给出截取“起始时刻”，也没有给出“结束时刻”。'
                Write-Host -F 'Red' '接下来程序将重新处理刚才的文件。'

                $可继续处理下一个输入文件 = $false

                continue
            }





            function Write-题干甲 {
                Write-Host
                Write-Host                  '录像或录音的源文件：'
                Write-Host -No              "${script:单级缩进之空白}"
                Write-Host     -F 'Green'   "${输入文件之完整路径}"

                # ----------------------------------

                Write-Host
                Write-Host                  '准备截取该片段'
                Write-Host -No              "${script:单级缩进之空白}"

                if ("$起始时刻") {
                    Write-Host -No -F 'Red' "${起始时刻}"
                } else {
                    Write-Host -No -F 'Red' '0:00:00'
                }

                Write-Host -No              ' ~ '

                if ("$结束时刻") {
                    Write-Host -No -F 'Red' "${结束时刻}"
                } else {
                    Write-Host -No -F 'Red' '自动'
                }
                Write-Host

                # ----------------------------------

                Write-Host
                Write-Host                  '并保存为该文件：'
                Write-Host -No              "${script:单级缩进之空白}"
                Write-Host     -F 'Magenta' "${输出文件之完整路径}"
                Write-Host

                # ----------------------------------

                Write-Host -F 'White' '以上配置均正确吗？'
            }



            [boolean]$已确认无误可继续 = Read-吴乐川询问是或否 `
                -问题题干_或_打印问题题干的函数 ${Function:Write-题干甲} `
                -代表_是_之值 's' `
                -代表_否_之值 'f' `
                -默认应取_是
                # -不准采用默认值



            if (-not $已确认无误可继续) {
                Write-Host
                Write-Host -F 'Red' '你刚才未确认（未选“是”）。'
                Write-Host -F 'Red' '接下来程序将重新处理刚才的文件。'
            } else {
                Write-Host

                try {
                    # if (Test-Path "${输出文件之完整路径}" -PathType 'Leaf') {
                    #     Remove-Item "${输出文件之完整路径}"
                    # }



                    # * * * * * * * * * * * * * * * * * * * * * * * *
                    # * * * * * * * * * * * * * * * * * * * * * * * *
                    # * * * * * * * * * * * * * * * * * * * * * * * *

                    if (-not "${结束时刻}") {

                        Write-Host
                        Write-Host -F 'DarkGray' '-----------------------------------------------------------------'
                        Write-Host               "`"${global:ffmpeg可执行程序的完整路径}`" ``"
                        Write-Host               "${script:单级缩进之空白}-ss `"${起始时刻}`" ``"
                        Write-Host               "${script:单级缩进之空白}-i `"${输入文件之完整路径}`" ``"
                        Write-Host               "${script:单级缩进之空白}-codec copy ``"
                        Write-Host               "${script:单级缩进之空白}-y `"${输出文件之完整路径}`""
                        Write-Host -F 'DarkGray' '-----------------------------------------------------------------'
                        Write-Host

                        & "${global:ffmpeg可执行程序的完整路径}" `
                            -ss "${起始时刻}" `
                            -i "${输入文件之完整路径}" `
                            -codec copy `
                            -y "${输出文件之完整路径}"

                        if (-not $?) {
                            Write-Host
                            throw
                        }
                    } else {

                        Write-Host
                        Write-Host -F 'DarkGray' '-----------------------------------------------------------------'
                        Write-Host               "`"${global:ffmpeg可执行程序的完整路径}`" ``"
                        Write-Host               "${script:单级缩进之空白}-ss `"${起始时刻}`" ``"
                        Write-Host               "${script:单级缩进之空白}-to `"${结束时刻}`" ``"
                        Write-Host               "${script:单级缩进之空白}-i `"${输入文件之完整路径}`" ``"
                        Write-Host               "${script:单级缩进之空白}-codec copy ``"
                        Write-Host               "${script:单级缩进之空白}-y `"${输出文件之完整路径}`""
                        Write-Host -F 'DarkGray' '-----------------------------------------------------------------'
                        Write-Host

                        & "${global:ffmpeg可执行程序的完整路径}" `
                            -ss "${起始时刻}" `
                            -to "${结束时刻}" `
                            -i "${输入文件之完整路径}" `
                            -codec copy `
                            -y "${输出文件之完整路径}"

                        if (-not $?) {
                            Write-Host
                            throw
                        }
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
                        -问题题干_或_打印问题题干的函数 ${Function:Write-题干乙} `
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
