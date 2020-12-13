$input = Get-Content input.txt

$buses_array = $input[1].Split(',')
$found_earliest = $false
$interval = 1
$bus_index = 0
$bus_index_previous = 0
$previous_time = 0
$time = 0

while (!$found_earliest){
    $time=$time+$interval
    $bus_id = $buses_array[$bus_index]
    while ($bus_id -eq 'x'){
        $bus_index++
        $bus_id = $buses_array[$bus_index]
    }
    if ($bus_id -ne 'x'){
        #Write-Verbose "$time + $bus_index_previous % $($buses_array[$bus_index_previous]) -eq 0 -and $time + $bus_index % $bus_id -eq 0" -Verbose
        if (($time+$bus_index_previous) % [int]$buses_array[$bus_index_previous] -eq 0 -and ($time+$bus_index) % $bus_id -eq 0){
            if ($previous_time -eq 0){
                $previous_time = $time
            } else {
                $interval = $time - $previous_time
                $previous_time = $time
                #Write-Verbose "Difference: $interval" -Verbose
                $previous_time = 0
                $bus_index_previous = $bus_index
                $bus_index++
            }
            if ($bus_index+1 -eq $buses_array.Count){
                $found_earliest = $true
            }
        }      
    }
}

Write-Output $time

