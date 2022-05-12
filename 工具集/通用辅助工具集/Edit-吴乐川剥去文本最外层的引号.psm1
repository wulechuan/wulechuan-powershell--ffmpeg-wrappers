function Edit-吴乐川剥去文本最外层的引号 {
    Param (
        [string] $原始的文本
    )

    if (-not ("$原始的文本".GetType() -match 'String')) {
        "$原始的文本"
        Return
    }

    [string]$剥去最外层引号后的文本 = "$原始的文本"

    if ("$原始的文本" -match '^\".*\"$') {
        $剥去最外层引号后的文本 = "$剥去最外层引号后的文本".Substring(1, "$原始的文本".Length - 2)
    } elseif ("$原始的文本" -match "^\'.*\'$") {
        $剥去最外层引号后的文本 = "$剥去最外层引号后的文本".Substring(1, "$原始的文本".Length - 2)
    }

    "$剥去最外层引号后的文本"
}





Export-ModuleMember -Function *
