$input = Get-Content input.txt
$memory = @{}
$number_list = $input.split(',')
$target_number = 30000000

# Instantiate with input
$iteration = 1
foreach ($number in $number_list){
    $memory["$number"] = $iteration
    $iteration++
}
$next_number = 0
while ($iteration -lt $target_number){
    #Write-Verbose "$iteration - $next_number - $($memory["$number"])" -Verbose
    if ($memory["$next_number"] -ne $null){
        $number = $next_number
        $next_number = $iteration - $memory["$next_number"]
        $memory["$number"] = $iteration
    } else {
        $memory["$next_number"] = $iteration
        $next_number = 0
    }
    
    $iteration++
    if ($iteration % 30000 -eq 0){
        $percentage = $iteration/$target_number * 100
        Write-Progress -Activity "Calculating" -Status "$percentage%" -PercentComplete $percentage
    }
}

Write-Output $next_number