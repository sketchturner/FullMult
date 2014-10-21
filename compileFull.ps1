"" | Out-File -FilePath outf.txt
for ($width=4; $width -le 32; $width++)
{
    Get-Content fm_part1.txt | Out-File -FilePath fullMult2.vhd -Width 2147483647 -Encoding ascii
    $width | Out-File -FilePath fullMult2.vhd -Append -Encoding ascii
    Get-Content fm_part2.txt | Out-File -FilePath fullMult2.vhd -Width 2147483647 -Append -Encoding ascii
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
    "$width $cellCount" | Out-File -FilePath outf.txt -Append
}