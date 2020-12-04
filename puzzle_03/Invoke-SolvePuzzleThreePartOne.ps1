$input = Get-Content input.txt

$tree_count = 0
$right_number = 3
$down_number = 1
$start_position_x = 1
$start_position_y = 1
$position_x = $start_position_x + $right_number
$position_y = $start_position_y + $down_number
$line_number = 1
foreach ($line in $input){
    if ($line_number -eq $position_y){
        $line_wrap_number = $line.Length
        if ($line_wrap_number -lt $position_x){
            $position_x = $position_x - $line_wrap_number
        }
        $tree_char = $line[$position_x-1]
        if ($tree_char -eq '#'){
            $tree_count++
        }
        #Write-Host "X: $position_x | Y: $position_y | Char: $tree_char | Count: $tree_count"
        $position_x = $position_x + $right_number
        $position_y = $position_y + $down_number
    }
    $line_number++
    
}

Write-Output $tree_count