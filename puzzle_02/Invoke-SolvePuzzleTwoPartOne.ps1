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
    $policy_number_min_max = $policy_numberrange.split('-')
    $policy_number_min = [int]$policy_number_min_max[0]
    $policy_number_max = [int]$policy_number_min_max[1]

    # Count the letter in the password
    $letter_count = ($password.ToCharArray() -eq $policy_letter).count
    if ($letter_count -ge $policy_number_min -and $letter_count -le $policy_number_max){
        $valid_count++
    }
}

Write-Output $valid_count