$input = Get-Content input.txt

$instruction_line_list = @()
$accumulator = 0
$line_number = 0

while ($line_number -le $input.Count){
    $instruction = $input[$line_number].split(' ')
    if ($instruction[0] -eq 'nop'){
        $line_number++
    }
    if ($instruction[0] -eq 'acc'){
        $amount = [int]$instruction[1].Substring(1)
        if ($instruction[1].StartsWith('+')){
            $accumulator = $accumulator + $amount
        } else {
            $accumulator = $accumulator - $amount
        }
        $line_number++
    }
    if ($instruction[0] -eq 'jmp'){
        $amount = [int]$instruction[1].Substring(1)
        if ($instruction[1].StartsWith('+')){
            $line_number = $line_number + $amount
        } else {
            $line_number = $line_number - $amount
        }
    }
    if ($instruction_line_list -contains $line_number){
        break
    }
    $instruction_line_list += $line_number
}
Write-Output $accumulator