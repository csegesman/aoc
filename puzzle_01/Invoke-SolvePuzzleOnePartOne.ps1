$list = Get-Content list.txt

foreach ($number_one in $list){
    foreach ($number_two in $list){
        if ([int]$number_one + [int]$number_two -eq 2020){
            $answer = [int]$number_one * [int]$number_two
            return Write-Output $answer
        }
    }
}