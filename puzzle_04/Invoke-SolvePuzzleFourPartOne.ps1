$input = Get-Content input.txt

function Test-Passport {
    param (
        $arr_to_test
    )

    $required_fields = @('byr','iyr','eyr','hgt','hcl','ecl','pid')
    $optional_fields = @('cid')
    $compare = Compare-Object -ReferenceObject $required_fields -DifferenceObject $arr_to_test
    if ($compare.SideIndicator -contains '<='){
        return $false
    } else {
        return $true
    }

}
$valid_count = 0
$test_arr = @()
foreach ($line in $input){
    $space_split = $line.split(' ')
    foreach ($obj in $space_split){
        $key = $obj.split(':')[0]
        $test_arr += $key
    }
    if ($line.trim() -eq ""){
        #Write-Output $test_arr
        $test_result = Test-Passport $test_arr
        if ($test_result){
            $valid_count++
        }
        $test_arr = @()
    }
}
# If there's no blank space at the end of the input, then try one more time.
if ($test_arr.Count -ne 0){
    $test_result = Test-Passport $test_arr
    if ($test_result){
        $valid_count++
    }
}

Write-Output $valid_count