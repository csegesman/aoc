$input = Get-Content input.txt

$ErrorActionPreference = 'Stop'

$empty_seat = 'L'
$occupied_seat = '#'
$floor = '.'
$max_occupied_seats = 4

function Get-SeatCount {
    param (
        $map_to_check
    )
    $occupied_seat_count = 0
    foreach ($row in $map_to_check){
        $occupied_seat_count += [int]($row | Group-Object | Where { $_.Name -eq '#'} | Select -ExpandProperty Count)
    }
    return $occupied_seat_count
}

# Can't deep clone natively
function Invoke-DeepCloneArray {
    param (
        $array_to_clone
    )
    $ms = New-Object System.IO.MemoryStream
    $bf = New-Object System.Runtime.Serialization.Formatters.Binary.BinaryFormatter
    $bf.Serialize($ms, $array_to_clone)
    $ms.Position = 0
    $cloned_array = $bf.Deserialize($ms)
    $ms.Close()
    return $cloned_array
}

# Compare two arrays to see if they're equal
function Check-ArraysEqual {
    param (
        $array_one,
        $array_two
    )
    
    $match = $true
    $row_count = 0
    while ($row_count -lt $array_one.Count){
        $column_count = 0
        while ($column_count -lt $array_one[$row_count].Count){
            if ($array_one[$row_count][$column_count] -ne $array_two[$row_count][$column_count]){
                $match = $false
                $column_count = $array_one[$row_count].Count
                $row_count = $array_one.Count
            }
            $column_count++
        }
        $row_count++
    }
    return $match
}

# Count number of occupied seats insofar as we care
function Get-OccupiedSeats {
    param (
        $row_before,
        $current_row,
        $row_after,
        $seat_number,
        $is_empty = $true
    )
    
    $occupied_seat_count = 0
    $neighbor_count = 0
    # count top row
    foreach ($neighbor in $row_before){
        if ($neighbor_count -gt $seat_number+1){
            break
        } elseif ($neighbor_count -ge $seat_number-1){
            if ($neighbor -eq $occupied_seat){
                $occupied_seat_count++
                if ($is_empty){
                    return 1
                } elseif ($occupied_seat_count -ge $max_occupied_seats) {
                    return $max_occupied_seats
                }
            }
        }
        
        $neighbor_count++
    }
    # count middle row
    $neighbor_count = 0
    foreach ($neighbor in $current_row){
        if ($neighbor_count -gt $seat_number+1){
            break
        } elseif ($neighbor_count -ge $seat_number-1 -and $seat_number -ne $neighbor_count){
            if ($neighbor -eq $occupied_seat){
                $occupied_seat_count++
                if ($is_empty){
                    return 1
                } elseif ($occupied_seat_count -ge $max_occupied_seats) {
                    return $max_occupied_seats
                }
            }
        }
        $neighbor_count++
    }
    # count bottom row
    $neighbor_count = 0
    foreach ($neighbor in $row_after){
        if ($neighbor_count -gt $seat_number+1){
            break
        } elseif ($neighbor_count -ge $seat_number-1){
            if ($neighbor -eq $occupied_seat){
                $occupied_seat_count++
                if ($is_empty){
                    return 1
                } elseif ($occupied_seat_count -gt $max_occupied_seats) {
                    return $max_occupied_seats
                }
            }
        }
        $neighbor_count++
    }
    return $occupied_seat_count
}


$map = @($null) * $input.Count
$count = 0
foreach ($line in $input){
    $map[$count] = $line.ToCharArray()
    $count++
}
$pass_count = 0
$map_copy = Invoke-DeepCloneArray $map
$keep_going = $true
while ($keep_going){
    $surrounding_seats = @()
    $pass_count++
    Write-Verbose "Pass $pass_count" -Verbose
    $row_count = 0
    foreach ($row in $map){
        $row_before = $null
        $row_after = $null
        if ($row_count -gt 0){
            $row_before = $map[$row_count-1]
        }
        if ($row_count -lt $map.Count-1){
            $row_after = $map[[int]$row_count+1]
        }
        $seat_count = 0
        foreach ($seat in $row){
            if ($seat -eq $empty_seat){
                #check for occupied seats
                $occupied_seat_count = Get-OccupiedSeats $row_before $row $row_after $seat_count
                if ($occupied_seat_count -eq 0){
                    $map_copy[$row_count][$seat_count] = '#'
                }
            } elseif ($seat -eq $occupied_seat){
                #check for > 3 occupied seats
                $occupied_seat_count = Get-OccupiedSeats $row_before $row $row_after $seat_count $false
                if ($occupied_seat_count -ge $max_occupied_seats){
                    $map_copy[$row_count][$seat_count] = 'L'
                }
            }
            $seat_count++
        }
        $row_count++
    }
    if (Check-ArraysEqual $map $map_copy){
        $keep_going = $false
    }

    $map = Invoke-DeepCloneArray $map_copy

}

Write-Output $(Get-SeatCount $map)