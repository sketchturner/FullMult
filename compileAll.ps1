function truncCount($w)
{
    $t = 0
    for ($i=$w-1; $i -ge 1; $i--)
    {
        if ([Math]::Pow(2, $i)*($i-1)+1 -lt [Math]::Pow(2, $w))
        {
            $t = $i
            break
        }
    }
    return $t;
}
"" | Out-File -FilePath out.txt
for ($width=4; $width -le 32; $width++)
{
    Get-Content sm_part1.txt | Out-File -FilePath shortMult2.vhd -Width 2147483647 -Encoding ascii
    $width | Out-File -FilePath shortMult2.vhd -Append -Encoding ascii
    Get-Content sm_part2.txt | Out-File -FilePath shortMult2.vhd -Width 2147483647 -Append -Encoding ascii
    truncCount($width) | Out-File -FilePath shortMult2.vhd -Append -Encoding ascii
    Get-Content sm_part3.txt | Out-File -FilePath shortMult2.vhd -Width 2147483647 -Append -Encoding ascii
    $strings = quartus_map FullMult -c fm
    $cellCount = 0
    foreach ($str in $strings)
    {
        $matches = $null
        $str -match "Implemented\s(?<cnt>\d+)\slogic cells" | Out-Null
        if ($null -ne $matches)
        {
            $cellCount = $matches.cnt
            break
        }
    }
    "$width $(truncCount($width)) $cellCount" | Out-File -FilePath out.txt -Append
}