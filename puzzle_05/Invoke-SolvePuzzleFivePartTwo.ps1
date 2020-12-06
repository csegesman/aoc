$input = Get-Content input.txt

function Get-Seat {
    param (
        $bsp_code
    )
    # Separate the codes out
    $row_code = $bsp_code.SubString(0,7)
    $column_code = $bsp_code.SubString(7)

    # Convert to 1's and 0's - F = 0, B = 1, R = 1, L = 0
    $row_binary = $row_code.Replace('F','0').Replace('B','1')
    $column_binary = $column_code.Replace('L','0').Replace('R','1')

    # Convert to 10 base
    $row_decimal = [Convert]::ToInt32($row_binary,2)
    $column_decimal = [Convert]::ToInt32($column_binary,2)

    # Get unique seat ID
    $seat_id = $row_decimal * 8 + $column_decimal

    #Write-Host "Row: $row_decimal; Column: $column_decimal; Seat ID: $seat_id"
    return $seat_id
}

$seat_arr = @()
foreach ($line in $input){
    $seat_arr += Get-Seat $line
}

$sorted_seat_arr = $seat_arr | Sort-Object

$seat_count = $sorted_seat_arr[0]
foreach ($seat in $sorted_seat_arr){
    if ($seat_count -ne $seat){
        Write-Output $seat_count
        break
    }
    $seat_count++
}
