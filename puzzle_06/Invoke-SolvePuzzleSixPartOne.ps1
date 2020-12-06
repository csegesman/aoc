$input = Get-Content input.txt

$count_arr = @()
$group_arr = @()
foreach ($line in $input){
    $group_arr += $line.ToCharArray()
    
    if ($line.trim() -eq ""){
        $group_arr = $group_arr | Sort-Object -Unique
        $count_arr += $group_arr.Count
        $group_arr = @()
    }
}
# If there's no blank space at the end of the input, then try one more time.
if ($group_arr.Count -ne 0){
    $group_arr = $group_arr | Sort-Object -Unique
    $count_arr += $group_arr.Count
    $group_arr = @()
}

# Get sum
$sum = 0
$count_arr | Foreach {$sum += $_ }

Write-Output $sum