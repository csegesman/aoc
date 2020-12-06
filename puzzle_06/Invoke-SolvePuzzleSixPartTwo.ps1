$input = Get-Content input.txt

$count_arr = @()
$group_arr = @()
$is_person_one = $true
foreach ($line in $input){
    if ($is_person_one){
        $group_arr += $line.ToCharArray()
        $is_person_one = $false
    } elseif ($line.trim() -ne "") {
        if ($group_arr.Count -ge 1){
            $group_arr = (Compare-Object -ReferenceObject $group_arr -DifferenceObject $line.ToCharArray() -IncludeEqual -ExcludeDifferent).InputObject
        }
    }
    if ($line.trim() -eq "")
    {
        $count_arr += $group_arr.Count
        $group_arr = @()
        $is_person_one = $true
    }
}
# If there's no blank space at the end of the input, then try one more time.
if ($group_arr.Count -ne 0){
    $count_arr += $group_arr.Count
    $group_arr = @()
}

# Get sum
$sum = 0
$count_arr | Foreach {$sum += $_ }

Write-Output $sum