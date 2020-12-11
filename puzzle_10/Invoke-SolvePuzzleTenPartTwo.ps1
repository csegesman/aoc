$input = Get-Content input.txt

$jolt_array = @(0)
$jolt_diff_one_accumulator = 0
$jolt_diff_three_accumulator = 1 # Starting at one because the built-in adapter is always a difference of 3

function Get-Fibonacci {
    param (
        $number
    )
    $current = $previous = $count = 1;
    while ($count -lt $number){
        $current,$previous = ($current + $previous),$current
        $count++
    }
    #Write-Host "Fib: $number,$current"
    return $current
}

function Get-Tribonacci {
    param (
        $number
    )
    $current = $count = 1
    $previous = $previous_two = 0
    while ($count -lt $number){
        $current,$previous,$previous_two = ($current + $previous + $previous_two),$current,$previous
        $count++
    }
    #Write-Host "Trib: $number,$current"
    return $current
}

foreach ($line in $input){
    $jolt_array += [int]$line
}

$sorted_jolt_array = $jolt_array | sort
$sorted_jolt_array += $sorted_jolt_array[-1]+3

$look_behind = 0
$previous_difference = 0
$number_of_arrangements = 1
$number_tribonacci = 2
$number_fibonacci = 2

foreach ($jolt in $sorted_jolt_array){
    $difference = $jolt - $look_behind
    if ($difference -eq 1 -and $previous_difference -eq 1){
        $number_tribonacci++
    } elseif ($number_tribonacci -gt 2){
        $multiplier = Get-Tribonacci $number_tribonacci
        $number_tribonacci = 2
        $number_of_arrangements *= $multiplier
    } elseif (
        ($difference -eq 1 -and $previous_difference -eq 2) `
        -or `
        ($difference -eq 2 -and $previous_difference -eq 1)
    ){
        $number_fibonacci++
    } elseif ($number_fibonacci -gt 2){
        $multiplier = Get-Fibonacci $number_fibonacci
        $number_fibonacci = 2
        $number_of_arrangements *= $multiplier
    }
    $previous_difference = $difference
    $look_behind = $jolt
    
}

Write-Output $number_of_arrangements
