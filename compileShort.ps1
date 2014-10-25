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
    $strings = quartus_map FullMult -c fm --optimize=area
    $cellCount = 0
    $delayTime = 0
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
    quartus_fit --read_settings_files=on --write_settings_files=off FullMult -c fm | Out-Null
    quartus_asm --read_settings_files=on --write_settings_files=off FullMult -c fm | Out-Null
    $strings = quartus_tan --read_settings_files=on --write_settings_files=off FullMult -c fm --speed=6
    foreach ($str in $strings)
    {
        $matches = $null
        $str -match "cell delay = (?<cnt>\d+.\d+) ns" | Out-Null
        if ($null -ne $matches)
        {
            [float]$delayTime = $matches.cnt
            break
        }
    }
    foreach ($str in $strings)
    {
        $matches = $null
        $str -match "interconnect delay = (?<cnt>\d+.\d+) ns" | Out-Null
        if ($null -ne $matches)
        {
            [float]$delayTime += $matches.cnt
            break
        }
    }
    "$width $(truncCount($width)) $cellCount $delayTime" | Out-File -FilePath out.txt -Append
}