$input = Get-Content input.txt

$instruction_line_list = @()
$undo_buffer = New-Object System.Collections.ArrayList($null)
$accumulator = 0
$line_number = 0
$changed_instruction = $false
while ($line_number -lt $input.Count){
    $instruction = $input[$line_number].split(' ')
    if ($instruction[0] -eq 'nop'){
        if (-not $changed_instruction){
            $undo_buffer.add(@{line=$line_number;instruction=$input[$line_number];accumulator=$accumulator;instructionlinelist=$instruction_line_list}) | Out-Null
        }
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
        if (-not $changed_instruction){
            $undo_buffer.add(@{line=$line_number;instruction=$input[$line_number];accumulator=$accumulator;instructionlinelist=$instruction_line_list}) | Out-Null
        }
        $amount = [int]$instruction[1].Substring(1)
        if ($instruction[1].StartsWith('+')){
            $line_number = $line_number + $amount
        } else {
            $line_number = $line_number - $amount
        }
    }
    if ($instruction_line_list -contains $line_number){
        # Load undo buffer and move backwards until we get something working
        if ($changed_instruction){
            $undo_buffer_index = $undo_buffer.Count-1
            $line_number = $undo_buffer[$undo_buffer_index].line
            # fix the input back to the way it was
            $input[$line_number] = $undo_buffer[$undo_buffer_index].instruction
            $undo_buffer.RemoveAt($undo_buffer_index) | Out-Null
        }
        if ($undo_buffer.Count -le 0){
            Write-Host 'Failed... terminating'
            break
        }
        $changed_instruction = $true
        $undo_buffer_index = $undo_buffer.Count-1
        $line_number = $undo_buffer[$undo_buffer_index].line
        $accumulator = $undo_buffer[$undo_buffer_index].accumulator
        $instruction_line_list = $undo_buffer[$undo_buffer_index].instructionlinelist

        $instruction = $input[$line_number].split(' ')
        $toggle_value = 'nop'
        if ($instruction[0] -eq 'nop'){
            $toggle_value = 'jmp'
        }
        #Write-Host "Changing $($input[$line_number]) to..."
        $input[$line_number] = $input[$line_number] -replace $instruction[0],$toggle_value
        #Write-Host "$($input[$line_number])"
    }
    $instruction_line_list += $line_number
}
Write-Output $accumulator