$input = Get-Content input.txt

$ErrorActionPreference = 'Stop'

$empty_seat = 'L'
$occupied_seat = '#'
$floor = '.'
$max_occupied_seats = 5

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
        $map,
        $row_number,
        $seat_number,
        $is_empty = $true
    )
    $occupied_seat_max = $max_occupied_seats
    $occupied_seat_count = 0
    if ($is_empty){
        $occupied_seat_max = 1
    }
    #Write-Host "Max = $occupied_seat_max"
    $starting_row = $row_number
    # Look left and right
    $row = $map[$row_number]
    $starting_position = $seat_number
    # Left
    $position = $starting_position
    $seat_found = $false
    while ($position -gt 0 -and !$seat_found){
        $position--
        $seat = $row[$position]
        if ($seat -ne $floor){
            $seat_found = $true
            if ($seat -eq $occupied_seat){
                $occupied_seat_count++
            }
        }
    }
    if ($occupied_seat_max -le $occupied_seat_count){
        return $occupied_seat_count
    }
    # Right
    $position = $starting_position
    $seat_found = $false
    while ($position -lt $row.Count-1 -and !$seat_found){
        $position++
        $seat = $row[$position]
        if ($seat -ne $floor){
            $seat_found = $true
            if ($seat -eq $occupied_seat){
                $occupied_seat_count++
            }
        }
    }
    if ($occupied_seat_max -le $occupied_seat_count){
        return $occupied_seat_count
    }

    # Look on rows scanning up
    
    $row_count = $starting_row - 1
    $position = $starting_position
    $found_all_seats = $false
    $seat_left = $floor
    $seat_right = $floor
    $seat_middle = $floor
    $spacer = 1
    $position = $starting_position
    while ($row_count -ge 0 -and !$found_all_seats){
        $left_number = $starting_position - $spacer
        $middle_number = $starting_position
        $right_number = $starting_position + $spacer

        if ($left_number -ge 0 -and $seat_left -eq $floor){
            $seat_left = $map[$row_count][$left_number]
            if ($seat_left -eq $occupied_seat){
                $occupied_seat_count++
                if ($occupied_seat_max -le $occupied_seat_count){
                    return $occupied_seat_count
                }
            }
        }
        if ($right_number -lt $map[$starting_row].Count -and $seat_right -eq $floor){
            $seat_right = $map[$row_count][$right_number]
            if ($seat_right -eq $occupied_seat){
                $occupied_seat_count++
                if ($occupied_seat_max -le $occupied_seat_count){
                    return $occupied_seat_count
                }
            }
        }
        if ($seat_middle -eq $floor){
            $seat_middle = $map[$row_count][$middle_number]
            if ($seat_middle -eq $occupied_seat){
                $occupied_seat_count++
                if ($occupied_seat_max -le $occupied_seat_count){
                    return $occupied_seat_count
                }
            }
        }
        if ($seat_left -ne $floor -and $seat_right -ne $floor -and $seat_middle -ne $floor){
            $found_all_seats = $true
        }
        $spacer++
        $row_count--
    }
    # Look on rows scanning down

    $row_count = $starting_row + 1
    $position = $starting_position
    $found_all_seats = $false
    $seat_left = $floor
    $seat_right = $floor
    $seat_middle = $floor
    $spacer = 1
    $position = $starting_position
    while (!$found_all_seats -and $row_count -lt $map.Count){
        $left_number = $starting_position - $spacer
        $middle_number = $starting_position
        $right_number = $starting_position + $spacer

        if ($left_number -ge 0 -and $seat_left -eq $floor){
            $seat_left = $map[$row_count][$left_number]
            if ($seat_left -eq $occupied_seat){
                $occupied_seat_count++
                if ($occupied_seat_max -le $occupied_seat_count){
                    return $occupied_seat_count
                }
            }
        }
        if ($right_number -lt $map[$starting_row].Count -and $seat_right -eq $floor){
            $seat_right = $map[$row_count][$right_number]
            if ($seat_right -eq $occupied_seat){
                $occupied_seat_count++
                if ($occupied_seat_max -le $occupied_seat_count){
                    return $occupied_seat_count
                }
            }
        }
        if ($seat_middle -eq $floor){
            $seat_middle = $map[$row_count][$middle_number]
            if ($seat_middle -eq $occupied_seat){
                $occupied_seat_count++
                if ($occupied_seat_max -le $occupied_seat_count){
                    return $occupied_seat_count
                }
            }
        }
        if ($seat_left -ne $floor -and $seat_right -ne $floor -and $seat_middle -ne $floor){
            $found_all_seats = $true
        }
        $spacer++
        $row_count++
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
    #foreach ($row in $map){
    #    Write-Host $row
    #}
    $row_count = 0
    foreach ($row in $map){
        $seat_count = 0
        foreach ($seat in $row){
            if ($seat -eq $empty_seat){
                #check for occupied seats
                $occupied_seat_count = Get-OccupiedSeats $map $row_count $seat_count
                if ($occupied_seat_count -eq 0){
                    $map_copy[$row_count][$seat_count] = '#'
                }
            } elseif ($seat -eq $occupied_seat){
                #check for > 3 occupied seats
                $occupied_seat_count = Get-OccupiedSeats $map $row_count $seat_count $false
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