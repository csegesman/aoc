$input = Get-Content input.txt
$start_time = [int]$input[0]
$buses_array = $input[1].Split(',')
$minutes_to_beat = -1
$answer = 0

foreach ($bus_id in $buses_array){
    if ($bus_id -ne 'x'){
        $time = $start_time
        while ($time % [int]$bus_id -ne 0){
            $time++
        }
        $minutes_to_wait = $time - $start_time
        if ($minutes_to_beat -lt 0){
            $minutes_to_beat = $minutes_to_wait
        }elseif ($minutes_to_wait -lt $minutes_to_beat){
            $minutes_to_beat = $minutes_to_wait
            $answer = $minutes_to_beat * [int]$bus_id
        }
    }
}

Write-Output $answer