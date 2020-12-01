$list = Get-Content list.txt

foreach ($number_one in $list){
    foreach ($number_two in $list){
        foreach ($number_three in $list){
            if ([int]$number_one + [int]$number_two + [int]$number_three -eq 2020){
                $answer = [int]$number_one * [int]$number_two * [int]$number_three
                return Write-Output $answer
            }
        }
    }
}