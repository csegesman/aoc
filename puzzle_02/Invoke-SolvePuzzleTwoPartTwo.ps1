$list = Get-Content list.txt

$valid_count = 0

foreach ($line in $list){
    # translate the line
    $policy_password = $line.split(':')
    $policy = $policy_password[0]
    $password = $policy_password[1].trim()
    $policy_numberrange_letter = $policy.split(' ')
    $policy_numberrange = $policy_numberrange_letter[0]
    $policy_letter = $policy_numberrange_letter[1]
    $policy_number_one_two = $policy_numberrange.split('-')
    $policy_number_index_one = [int]$policy_number_one_two[0] - 1
    $policy_number_index_two = [int]$policy_number_one_two[1] - 1

    $password_character_array = $password.ToCharArray()

    if ($password_character_array[$policy_number_index_one] -eq $policy_letter -xor $password_character_array[$policy_number_index_two] -eq $policy_letter){
        $valid_count++
    }
}

Write-Output $valid_count