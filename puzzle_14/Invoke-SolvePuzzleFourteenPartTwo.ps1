$input = Get-Content input.txt
$memory = @{}


function Get-MemoryAddresses {
    param (
        $memory_value
    )
    $address_array = @()
    # Count number of X's
    $x_count = ($memory_value.ToCharArray() | Where-Object {$_ -eq 'X'} | Measure-Object).Count
    $x_loop = [Math]::Pow(2,$x_count)-1
    
    while ($x_loop -ge 0){
        $x_values = [Convert]::ToString($x_loop,2).PadLeft($x_count,'0')
        $memory_address = $memory_value
        foreach ($x in $x_values.ToCharArray()){
            $replacement = '${1}'+$x+'${2}'
            $memory_address = $memory_address -replace '(.*?)X(.*)', $replacement
        }
        $address_array += $memory_address
        $x_loop--
    }
    return $address_array
}

foreach ($line in $input){
    if ($line.StartsWith('mask =')){
        $mask = $line.Substring(7)
        continue
    }
    $mem_address = $line.Split('[')[1].Split(']')[0]
    $mem_decimal = $line.Split('=')[1].Substring(1)
    $mem_value = [Convert]::ToString($mem_address,2).PadLeft(36,'0')
    $count = 0
    foreach ($character in $mask.ToCharArray()){
        if ($character -eq '1'){
            $mem_value = $mem_value.remove($count,1).insert($count,'1')
        }
        
        $count++
    }
    $count = 0
    foreach ($character in $mask.ToCharArray()){
        if ($character -eq 'X'){
            $mem_value = $mem_value.remove($count,1).insert($count,'X')
            $mem_addresses = Get-MemoryAddresses $mem_value
            foreach ($address in $mem_addresses){
                $memory["$address"] = $mem_decimal
            }
        }
        $count++
    }
}

Write-Output ($memory.Values | Measure-Object -Sum).Sum