$input = Get-Content input.txt
$memory = @{}
$number_list = $input.split(',')
$target_number = 2020

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
    
}

Write-Output $next_number