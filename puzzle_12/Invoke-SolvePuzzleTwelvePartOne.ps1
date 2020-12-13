$input = Get-Content input.txt

$direction = 90
$location = @(0,0)
$compass = @{N=0;E=90;S=180;W=270}

function Invoke-GoDirection {
    param (
        $coordinates,
        $distance,
        $direction
    )
    switch ($direction) {
        0   { $coordinates[1] += $distance }
        90  { $coordinates[0] += $distance }
        180 { $coordinates[1] -= $distance }
        270 { $coordinates[0] -= $distance }
    }
    return $coordinates
}

foreach ($line in $input){
    $director = $line.Substring(0,1)
    $amount = [int]$line.Substring(1)
    switch ($director){
        'F' { $location = Invoke-GoDirection $location $amount $direction }
        'R' { $direction = ($direction + $amount) % 360 }
        'L' { $direction = (360 + $direction - $amount) % 360 }
        default { $location = Invoke-GoDirection $location $amount $compass[$director] }
    }
}
$manhattan_distance = [Math]::Abs($location[0]) + [Math]::Abs($location[1])
Write-Output $manhattan_distance