function Read-吴乐川询问是或否 {
    Param (
        $问题题干文本_或_用以打印问题题干的函数,

        [PSDefaultValue(Help = 's')]
        [string] $代表_是_之值,

        [string] $代表_是_之界面措辞,

        [PSDefaultValue(Help = 'f')]
        [string] $代表_否_之值,

        [string] $代表_否_之界面措辞,

        [Switch] $默认应取_是,
        [Switch] $不准采用默认值
    )



    BEGIN {
        # [string]$代表_是_之界面措辞2
        # [string]$代表_否_之界面措辞2

        # [string]$代表_是_之值之界面表达
        # [string]$代表_否_之值之界面表达

        [boolean]$默认值为_是 = $false
        [boolean]$默认值为_否 = $false

        if (-not "$代表_是_之值") {
            $代表_是_之值 = 's'
        }

        if (-not "$代表_否_之值") {
            $代表_否_之值 = 'f'
        }

        if (-not "$代表_是_之界面措辞") {
            $代表_是_之界面措辞 = '&是'
        }

        if (-not "$代表_否_之界面措辞") {
            $代表_否_之界面措辞 = '&否'
        }

        if (-not $不准采用默认值) { # 不能用引号括起来！
            if ($默认应取_是) {
                $默认应取_是 = $true
                $默认值为_否 = $false
            } else {
                $默认应取_是 = $false
                $默认值为_否 = $true
            }
        }



        if ($代表_是_之界面措辞) {
            $代表_是_之界面措辞2 = "$代表_是_之界面措辞"
        } else {
            $代表_是_之界面措辞2 = "$代表_是_之值"
        }

        $代表_是_之值之界面表达 = "$代表_是_之值"
        if (-not $不准采用默认值 -and $默认应取_是) {
            $默认值为_是 = $true
            $代表_是_之值之界面表达 = $代表_是_之值之界面表达.ToUpper()
        }



        if ($代表_否_之界面措辞) {
            $代表_否_之界面措辞2 = "$代表_否_之界面措辞"
        } else {
            $代表_否_之界面措辞2 = "$代表_否_之值"
        }

        $代表_否_之值之界面表达 = "$代表_否_之值"
        if (-not $不准采用默认值 -and $默认应取_否) {
            $默认值为_否 = $true
            $代表_否_之值之界面表达 = $代表_否_之值之界面表达.ToUpper()
        }



        function Write-默认的题干打印函数 {
            if ($问题题干文本) {
                Write-Host -F 'White' "$问题题干文本"
            } else {
                Write-Host -F 'White' '请做出选择：'
            }
        }



        # Write-Host '$问题题干文本_或_用以打印问题题干的函数.GetType(): '($问题题干文本_或_用以打印问题题干的函数.GetType())

        if (-not $问题题干文本_或_用以打印问题题干的函数) {

            ${Function:打印问题题干的函数} = ${Function:Write-默认的题干打印函数}

        } elseif ($问题题干文本_或_用以打印问题题干的函数.GetType() -match 'ScriptBlock') {

            ${Function:打印问题题干的函数} = $问题题干文本_或_用以打印问题题干的函数

        } else {

            ${Function:打印问题题干的函数} = ${Function:Write-默认的题干打印函数}

            if ($问题题干文本_或_用以打印问题题干的函数.GetType() -match 'String') {
                [string]$问题题干文本 = "$问题题干文本_或_用以打印问题题干的函数"
            }

        }
    }



    PROCESS {
        function Write-某值之界面表达 {
            param (
                [string]$原始文本,
                [switch]$该文本须整体强调
            )

            [boolean]$这个字需强调 = $false

            ForEach ($字 in ("$原始文本" -split '')) {
                if ($字 -eq '&') {
                    $这个字需强调 = $true
                    continue
                }

                if ($该文本须整体强调) {
                    if ($这个字需强调) {
                        Write-Host -No -F 'Black' -B 'Cyan' $字
                    } else {
                        Write-Host -No -F 'Cyan'            $字
                    }

                } else {
                    if ($这个字需强调) {
                        Write-Host -No -F 'Black' -B 'Gray' $字
                    } else {
                        Write-Host -No -F 'Gray'            $字
                    }
                }

                $这个字需强调 = $false
            }
        }





        [boolean]$问答可以结束 = $false
        [int]    $某次题干出现后连续无效输入之计数 = 0
        [boolean]$因作答不合规累计次数过多应重新给出题干 = $false



        While (-not $问答可以结束) {
            if ($某次题干出现后连续无效输入之计数 -eq 0) {
                Write-Host

                if ($因作答不合规累计次数过多应重新给出题干) {
                    Write-Host
                    Write-Host
                    Write-Host -F 'DarkGray' '因作答不合规累计次数过多，'
                    Write-Host -F 'DarkGray' '现重新给出题干作为提醒。'
                    Write-Host
                }

                Invoke-Command ${Function:打印问题题干的函数}
                Write-Host
            }



            if ($某次题干出现后连续无效输入之计数 -eq 0) {
                Write-Host -No -F 'DarkGray' '    '
            } else {
                Write-Host -No -F 'DarkGray' '['
                Write-Host -No -F 'Red'       "$某次题干出现后连续无效输入之计数"
                Write-Host -No -F 'DarkGray' '] '
            }

            Write-Host -No -F 'DarkGray' '[ '

            if ($默认值为_是) {
                Write-某值之界面表达 -原始文本 "$代表_是_之界面措辞2" -该文本须整体强调

                Write-Host -No -F 'DarkGray' '（'
                Write-Host -No -F 'Cyan'     "$代表_是_之值之界面表达"
                Write-Host -No -F 'DarkGray' '）'
            } else {
                Write-某值之界面表达 -原始文本 "$代表_是_之界面措辞2"
                Write-Host -No -F 'DarkGray' '（'
                Write-Host -No -F 'Gray'     "$代表_是_之值之界面表达"
                Write-Host -No -F 'DarkGray' '）'
            }

            Write-Host -No -F 'DarkGray' '/ ' # 汉语括号的右侧留白较多，所以这里的方括号之前故意省略空格。

            if ($默认值为_否) {
                Write-某值之界面表达 -原始文本 "$代表_否_之界面措辞2" -该文本须整体强调
                Write-Host -No -F 'DarkGray' '（'
                Write-Host -No -F 'Cyan'     "$代表_否_之值之界面表达"
                Write-Host -No -F 'DarkGray' '）'
            } else {
                Write-某值之界面表达 -原始文本 "$代表_否_之界面措辞2"
                Write-Host -No -F 'DarkGray' '（'
                Write-Host -No -F 'Gray'     "$代表_否_之值之界面表达"
                Write-Host -No -F 'DarkGray' '）'
            }

            Write-Host -No -F 'DarkGray' ']' # 汉语括号的右侧留白较多，所以这里的方括号之前故意省略空格。

            [string]$用户给出的值 = Read-Host -prompt ' '

            # Write-Host



            [boolean]$用户给出的值有效 = $false
            [boolean]$用户之意图最终解读为_是 = $false

            if ($用户给出的值) {
                [boolean]$用户明确给出了_是 = $用户给出的值.ToLower() -eq $代表_是_之值.ToLower()
                [boolean]$用户明确给出了_否 = $用户给出的值.ToLower() -eq $代表_否_之值.ToLower()

                if ($用户明确给出了_是 -or $用户明确给出了_否) {
                    $用户给出的值有效 = $true

                    if ($用户明确给出了_是) {
                        $用户之意图最终解读为_是 = $true
                    } else {
                        $用户之意图最终解读为_是 = $false
                    }
                }
            } else {
                if (-not $不准采用默认值) {
                    if ($默认应取_是) {
                        # $用户给出的值 = "$代表_是_之值"
                        $用户之意图最终解读为_是 = $true
                    } else {
                        # $用户给出的值 = "$代表_否_之值"
                        $用户之意图最终解读为_是 = $false
                    }

                    $用户给出的值有效 = $true
                }
            }



            if ($用户给出的值有效) {
                Write-Host

                $问答可以结束 = $true
            } else {
                $某次题干出现后连续无效输入之计数++

                if ($某次题干出现后连续无效输入之计数 -ge 10) {
                    $某次题干出现后连续无效输入之计数 = 0
                    $因作答不合规累计次数过多应重新给出题干 = $true
                }
            }
        }
    }



    END {
        $用户之意图最终解读为_是
    }
}
