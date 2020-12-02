$list = Get-Content list.txt
$count1 = 0
foreach ($number_one in $list){
    $count1++
    $count2 = 0
    foreach ($number_two in $list){
        $count2++
        $count3 = 0
        foreach ($number_three in $list){
            $count3++
            if ($count1 -ne $count2 -and $count1 -ne $count3 -and $count2 -ne $count3){
                if ([int]$number_one + [int]$number_two + [int]$number_three -eq 2020){
                    $answer = [int]$number_one * [int]$number_two * [int]$number_three
                    return Write-Output $answer
                }
            }
        }
    }
}