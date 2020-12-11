$input = Get-Content input.txt

$jolt_array = @()
$jolt_diff_one_accumulator = 0
$jolt_diff_three_accumulator = 1 # Starting at one because the built-in adapter is always a difference of 3

foreach ($line in $input){
    $jolt_array += [int]$line
}

$sorted_jolt_array = $jolt_array | sort

$look_behind = 0
foreach ($jolt in $sorted_jolt_array){
    $difference = $jolt - $look_behind
    if ($difference -eq 1){
        $jolt_diff_one_accumulator++
    }
    if ($difference -eq 3){
        $jolt_diff_three_accumulator++
    }
    $look_behind = $jolt
}
$answer = $jolt_diff_one_accumulator * $jolt_diff_three_accumulator
Write-Output $answer
