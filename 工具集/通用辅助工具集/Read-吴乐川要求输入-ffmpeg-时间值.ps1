function Read-吴乐川要求输入FFMPEG时间值 {
    param (
        [Parameter(Mandatory=$True)]
        [string] $欲读取之值之称谓, # 例子 '该视频截取的起始时刻'

        [string] $默认值,
        [Switch] $刚才的交互已有类同功能_此次不妨采用极简界面
    )



	BEGIN {
        if (-not $欲读取之值之称谓) {
            $欲读取之值之称谓 = '某不明时刻'
        }

        if (-not $默认值) {
            $默认值 = ''
        }

        [string]$单级缩进之空白 = '    '
    }



    PROCESS {
        if (-not $刚才的交互已有类同功能_此次不妨采用极简界面) {
            Write-Host
            Write-Host -No               '须为'
            Write-Host -No               '【'
            Write-Host -No -F 'Green'    "${欲读取之值之称谓}"
            Write-Host -No               '】'
            Write-Host -No               '输入符合 ffmpeg 时间格式的值'
            Write-Host

            # ---------------------------------------

            Write-Host

            # ---------------------------------------

            Write-Host -No                       "${单级缩进之空白}第 1 种格式： "

            Write-Host -No -F 'DarkGray'         '['
            Write-Host -No -F 'Red'              '-'
            Write-Host -No -F 'DarkGray'         ']'

            Write-Host -No -F 'DarkGray'         '['
            Write-Host -No -F 'Yellow'           '小时'
            Write-Host -No -F 'Cyan'             ':'
            Write-Host -No -F 'DarkGray'         ']'

            Write-Host -No -F 'DarkGray'         '['
            Write-Host -No -F 'Green'            '分钟'
            Write-Host -No -F 'Cyan'             ':'
            Write-Host -No -F 'DarkGray'         ']'

            Write-Host -No -F 'Black' -B 'Blue'  '秒'
            Write-Host -No -F 'DarkGray'         '['
            Write-Host -No -F 'Magenta'          '.m...'
            Write-Host -No -F 'DarkGray'         ']'
            Write-Host

            # ---------------------------------------

            Write-Host -No                       "${单级缩进之空白}第 2 种格式： "

            Write-Host -No -F 'DarkGray'         '['
            Write-Host -No -F 'Red'              '-'
            Write-Host -No -F 'DarkGray'         ']'

            Write-Host -No -F 'Black' -B 'Blue'  '秒数'

            Write-Host -No -F 'DarkGray'         '['
            Write-Host -No -F 'Magenta'          '.m...'
            Write-Host -No -F 'DarkGray'         ']'

            Write-Host -No -F 'DarkGray'         '['
            Write-Host -No -F 'Blue'             's'
            Write-Host -No -F 'DarkGray'         '|'
            Write-Host -No -F 'Blue'             'ms'
            Write-Host -No -F 'DarkGray'         '|'
            Write-Host -No -F 'Blue'             'us'
            Write-Host -No -F 'DarkGray'         ']'
            Write-Host

            # ---------------------------------------

            Write-Host

            # ---------------------------------------

            Write-Host                   '参阅 ffmpeg 官方文档：'
            Write-Host -No               "${单级缩进之空白}"
            Write-Host     -F 'DarkBlue' 'https://ffmpeg.org/ffmpeg-utils.html#Time-duration'

            Write-Host
            Write-Host -No               '另，'

            Write-Host
            Write-Host -No               "${单级缩进之空白}"
            Write-Host -No               '凡'
            Write-Host -No -F 'Yellow'   '中文冒号'
            Write-Host -No               '（"'
            Write-Host -No -F 'Yellow'   '：'
            Write-Host -No               '"）'

            Write-Host
            Write-Host -No               "${单级缩进之空白}"
            Write-Host -No               '以及'
            Write-Host -No -F 'Red'      '正斜杠号'
            Write-Host -No               '（"'
            Write-Host -No -F 'Red'      '/'
            Write-Host -No               '"）'

            Write-Host
            Write-Host -No               "${单级缩进之空白}"
            Write-Host -No               '均会自动修正为'
            Write-Host -No -F 'Cyan'     '英文冒号'
            Write-Host -No               '（"'
            Write-Host -No -F 'Cyan'     ':'
            Write-Host -No               '"）'
            Write-Host
            Write-Host
        } else {
            Write-Host
        }



        Write-Host -No            '请输入'
        Write-Host -No            '【'
        Write-Host -No -F 'Green' "${欲读取之值之称谓}"
        Write-Host -No            '】'

        $用户给出的值 = Read-Host -prompt ' '

        # Write-Host

        if (-not $用户给出的值) {
            $用户给出的值 = "$默认值"
        }

        $用户给出的值 = [string]"$用户给出的值" -replace "：", ':'
        $用户给出的值 = [string]"$用户给出的值" -replace "/", ':'



        Write-Host     -F 'DarkGray' '--------------------------------------------------------'
        Write-Host -No               '【'
        Write-Host -No -F 'Green'    "${欲读取之值之称谓}"
        Write-Host -No               '】'
        Write-Host -No               '最终采纳的值为 "'
        Write-Host -No -F 'Red'      "$用户给出的值"
        Write-Host -No               '"'
        Write-Host
        Write-Host     -F 'DarkGray' '--------------------------------------------------------'
        Write-Host
    }



    END {
        "$用户给出的值"
    }
}
