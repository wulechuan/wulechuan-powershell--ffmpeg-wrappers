function Get-Windows用户桌面之完整路径 {
    END {
        "$($(Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders').Desktop)"
    }
}
