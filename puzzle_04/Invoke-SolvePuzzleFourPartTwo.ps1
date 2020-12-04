$input = Get-Content input.txt

function Test-Passport {
    param (
        $arr_to_test,
        $hash_to_test
    )

    $required_fields = @('byr','iyr','eyr','hgt','hcl','ecl','pid')
    $optional_fields = @('cid')
    $compare = Compare-Object -ReferenceObject $required_fields -DifferenceObject $arr_to_test
    if ($compare.SideIndicator -contains '<='){
        return $false
    } else {
        # byr test
        $byr_regex = '^\d{4}$'
        if ($hash_to_test.byr -notmatch $byr_regex){
            return $false
        }
        if ([int]($hash_to_test.byr) -lt 1920 -or [int]($hash_to_test.byr) -gt 2002){
            return $false
        }

        # iyr test
        $iyr_regex = '^\d{4}$'
        if ($hash_to_test.iyr -notmatch $iyr_regex){
            return $false
        }
        if ([int]($hash_to_test.iyr) -lt 2010 -or [int]($hash_to_test.iyr) -gt 2020){
            return $false
        }

        # eyr test
        $eyr_regex = '^\d{4}$'
        if ($hash_to_test.eyr -notmatch $eyr_regex){
            return $false
        }
        if ([int]($hash_to_test.eyr) -lt 2020 -or [int]($hash_to_test.eyr) -gt 2030){
            return $false
        }

        # hgt test
        $hgt_regex = '\d+cm|\d+in'
        if ($hash_to_test.hgt -notmatch $hgt_regex){
            return $false
        }
        if ($hash_to_test.hgt.endsWith('cm')){
            $height_cm = $hash_to_test.hgt.split('c')[0]
            if ([int]$height_cm -lt 150 -or [int]$height_cm -gt 193){
                return $false
            }
        } else {
            $height_in = $hash_to_test.hgt.split('i')[0]
            if ([int]$height_in -lt 59 -or [int]$height_in -gt 76){
                return $false
            }
        }

        # hcl test
        $hcl_regex = '^#[0-9a-f]{6}$'
        if ($hash_to_test.hcl -notmatch $hcl_regex){
            return $false
        }

        # ecl test
        $ecl_valid_arr = @('amb','blu','brn','gry','grn','hzl','oth')
        if ($hash_to_test.ecl -notin $ecl_valid_arr){
            return $false
        }

        # pid test
        $pid_regex = '^\d{9}$'
        if ($hash_to_test.pid -notmatch $pid_regex){
            return $false
        }

        return $true
    }

}
$valid_count = 0
$test_arr = @()
$test_hash = @{}
foreach ($line in $input){
    $space_split = $line.split(' ')
    foreach ($obj in $space_split){
        $key = $obj.split(':')[0]
        $value = $obj.split(':')[1]
        $test_arr += $key
        $test_hash["$key"] = $value
    }
    if ($line.trim() -eq ""){
        #Write-Output $test_arr
        $test_result = Test-Passport $test_arr $test_hash
        if ($test_result){
            $valid_count++
        }
        $test_arr = @()
        $test_hash = @{}
    }
}
# If there's no blank space at the end of the input, then try one more time.
if ($test_arr.Count -ne 0){
    $test_result = Test-Passport $test_arr $test_hash
    if ($test_result){
        $valid_count++
    }
}

Write-Output $valid_count