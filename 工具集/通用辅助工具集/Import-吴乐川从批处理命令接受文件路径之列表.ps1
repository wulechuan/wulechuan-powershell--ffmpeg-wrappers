function Expand-吴乐川从PowerShell的Args参数解析出文件路径列表 {

    # PowerShell 的 $args 自动变量会强行将英文逗号 “,” 视为该数组条目之分隔符。
    # 故从 BAT 程序（进程）传入的文件路径，如果某文件名中含有英文逗号，
    # 则在 PoweShell 中无法正确获得这些路径中的一枚或若干枚。
    # 解决的办法是，同时做到以下几点：
    #     1.  在 BAT 命令中，事先将其接收到的文件路径列表用英语冒号衔接成单一字符串。
    #         待之后由 PowerShell 函数（即本函数）进行重新分割整理。
    #
    #         选用英语冒号，是因为除了 Windows 盘符之外，路径的任何地方不允许出现冒号。
    #
    #         管道符也不能出现在文件名中。但不选用管道符是因为在 BAT 中难以处理之。
    #
    #         英语问号也不能出现在文件名中。但不选用英语问号是因为本 PowerShell 函数
    #         的设计思路侧重处理英语冒号，成功后未考虑改用英语问号。
    #
    #     2.  在 BAT 命令中，必须用双引号扩起要传递给本程序之参数。
    #         实验证明，不可采用单引号。因为，如果某文件名包含连续多个空格，
    #         虽然从 BAT 传入 PowerShell 的字符串无误，
    #         但如果传入的字符串系由单引号括起来，则 PowerShell 会将连续空格合并为单一空格。这是不正确的。
    #
    #     3.  用 PowerShell 函数处理传入的 $args 。
    #
    # 参见文件夹内的《示范.bat》和《示范.ps1》。


    PROCESS {
        # Write-Host $args

        [string[]]$外界给出参数分割成的临时列表 = "$args" -split ':' # , 0, "Singleline"

        [string[]]$文件路径之列表 = @()

        [string]  $上一个疑似Windows盘符 = ''
        [string]  $正在处理的文件路径 = ''
        [boolean] $上一个片段可能是Windows盘符 = $false

        ForEach ($本片段 in $外界给出参数分割成的临时列表) {
            # 这是 PowerShell 的特征行为，将输入的 ^ 号全部变为 ^^ 。
            $本片段 = $本片段 -replace '\^\^', '^'



            # Write-Host "片段=`"${本片段}`""



            [boolean]$本片段可能是Windows盘符 = "$本片段" -match '^[a-zA-Z]$'

            if ($本片段可能是Windows盘符) {
                $上一个疑似Windows盘符 = "$本片段"
                $上一个片段可能是Windows盘符 = $true
                continue
            }

            [boolean]$本片段以反斜杠开头 = "$本片段" -match '^\\'

            if ($上一个片段可能是Windows盘符) {
                if ($本片段以反斜杠开头) {
                    if ($正在处理的文件路径) {
                        $文件路径之列表 += $正在处理的文件路径
                    }

                    $正在处理的文件路径 = "${上一个疑似Windows盘符}:${本片段}"
                } else {
                    if ($正在处理的文件路径) {
                        $正在处理的文件路径 = "${正在处理的文件路径},${上一个疑似Windows盘符},${本片段}"
                    } else {
                        $正在处理的文件路径 = "${上一个疑似Windows盘符},${本片段}"
                    }
                }

                $上一个疑似Windows盘符 = ''
            } else {
                if ($正在处理的文件路径) {
                    $正在处理的文件路径 = "${正在处理的文件路径},${本片段}"
                } else {
                    $正在处理的文件路径 = "${本片段}"
                }
            }

            $上一个片段可能是Windows盘符 = $false
        }

        if ($正在处理的文件路径) {
            $文件路径之列表 += $正在处理的文件路径
        }
    }





    END {
        $文件路径之列表
    }
}
