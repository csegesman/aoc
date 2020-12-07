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
function Get-BagColorCount {
    param (
        $bag_object,
        $bag_to_find,
        $is_first = $true
    )
    foreach ($bag in $bag_object.GetEnumerator()){
        if ($bag.Value.Keys -contains $bag_to_find){
            $global:bag_list += $bag.Name
            Get-BagColorCount $bag_object $bag.Name $false
        }
    }
    if ($is_first){
        $unique_bag_list = $global:bag_list | Select -Unique
        return $unique_bag_list.count
    }
}

Get-BagColorCount $bags "shiny_gold"