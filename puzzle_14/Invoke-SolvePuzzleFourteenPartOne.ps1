$input = Get-Content input.txt
$memory = @{}


foreach ($line in $input){
    if ($line.StartsWith('mask =')){
        $mask = $line.Substring(7)
        continue
    }
    $mem_address = $line.Split('[')[1].Split(']')[0]
    $mem_decimal = $line.Split('=')[1].Substring(1)
    $mem_value = [Convert]::ToString($mem_decimal,2).PadLeft(36,'0')
    $count = 0
    foreach ($character in $mask.ToCharArray()){
        if ($character -eq '1'){
            $mem_value = $mem_value.remove($count,1).insert($count,'1')
        }
        if ($character -eq '0'){
            $mem_value = $mem_value.remove($count,1).insert($count,'0')
        }
        $count++
    }
    Write-Verbose $mask -Verbose
    Write-Verbose $mem_value -Verbose
    $memory["$mem_address"] = [Convert]::ToInt64($mem_value,2)
}

Write-Output ($memory.Values | Measure-Object -Sum).Sum

