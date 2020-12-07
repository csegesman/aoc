$input = Get-Content input.txt

$bags = @{}

foreach ($line in $input){
    $bag_object = $line -split ' contain '
    $bag_name_array = $bag_object[0].split(' ')
    $bag_name = "$($bag_name_array[0])_$($bag_name_array[1])"
    $contained_bag_array = $bag_object[1].split(',')
    if ($contained_bag_array -ne 'no other bags.'){
        foreach ($contained_bag in $contained_bag_array){
            $contained_bag_obj = $contained_bag.trim().split(' ')
            $contained_bag_count = [int]$contained_bag_obj[0]
            $contained_bag_name = "$($contained_bag_obj[1])_$($contained_bag_obj[2])"
            $bags["$bag_name"] += @{
                "$contained_bag_name"=$contained_bag_count
            }
        }
    }
}

$global:bag_list = @()
function Get-BagCount {
    param (
        $bag_object,
        $bag_to_find,
        $is_first = $true,
        $count = 1
    )
    While ($count -gt 0){
        $count--
        if ($bag_object.Keys -contains $bag_to_find){
            foreach ($bag in $bag_object["$bag_to_find"].GetEnumerator()){
                if ($bag_object.Keys -contains $bag_to_find){
                    $global:bag_list += $bag.Value
                    Get-BagCount $bag_object $bag.Name $false $bag.Value
                }
            }
        }
    }
    if ($is_first){
        return $bag_list
    }
}
# Get sum
$count_arr = Get-BagCount $bags "shiny_gold"
$sum = 0
$count_arr | Foreach {$sum += $_ }

Write-Output $sum