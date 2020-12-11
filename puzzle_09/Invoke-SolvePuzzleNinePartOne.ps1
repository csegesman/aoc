$input = Get-Content input.txt

$number_preamble = New-Object System.Collections.ArrayList($null)
$preamble_size = 25

function Invoke-CheckNumber {
    param (
        $preamble,
        $number_to_check
    )
    foreach ($number in $preamble){
        $difference = $number_to_check - $number
        if ($number -ne $difference){
            if ($preamble -contains $difference){
                # Valid
                return $true
            }
        }
    }
    # Invalid
    return $false
}

# build preamble
foreach ($line in $input){
    if ($number_preamble.Count -ge $preamble_size){
        if (-not (Invoke-CheckNumber $number_preamble ([int]$line))){
            Write-Output $line
            break
        }
        $number_preamble.RemoveAt(0) | Out-Null
    }
    $number_preamble.Add([int]$line) | Out-Null
}