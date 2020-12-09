$input = Get-Content input.txt

$number_preamble = New-Object System.Collections.ArrayList($null)
$preamble_size = 25
$target_number = 0

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

# Get target number
foreach ($line in $input){
    if ($number_preamble.Count -ge $preamble_size){
        if (-not (Invoke-CheckNumber $number_preamble ([int]$line))){
            $target_number = [int]$line
            break
        }
        $number_preamble.RemoveAt(0) | Out-Null
    }
    $number_preamble.Add([int]$line) | Out-Null
}

# Find contiguous list
$number_list = New-Object System.Collections.ArrayList($null)
$ErrorActionPreference = "Stop"
foreach ($line in $input){
    $number_list.Add([int]$line) | Out-Null
    $measured_sum = $number_list | Measure -Sum
    While ($measured_sum.Sum -gt $target_number){
        $number_list.RemoveAt(0) | Out-Null
        # redo sum
        $measured_sum = $number_list | Measure -Sum
    }
    if ($measured_sum.Sum -eq $target_number){
        $measured_number = $number_list | Measure -Maximum -Minimum 
        $answer = $measured_number.Minimum + $measured_number.Maximum
        Write-Output $answer
        break
    }
}
