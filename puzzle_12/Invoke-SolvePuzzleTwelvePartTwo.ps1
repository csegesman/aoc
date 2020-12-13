$input = Get-Content input.txt

$location = @(0,0)
$waypoint = @(10,1)
$compass = @{N=@(0,1);E=@(1,0);S=@(0,-1);W=@(-1,0)}

function Invoke-GoDirection {
    param (
        $coordinates,
        $distance,
        $multiplier
    )
    
    $coordinates[0] = $coordinates[0] + ($distance[0] * $multiplier)
    $coordinates[1] = $coordinates[1] + ($distance[1] * $multiplier)

    return $coordinates
}


function Invoke-RotateWaypoint {
    param (
        $coordinates,
        $degrees,
        $clockwise = $true
    )

    while ($degrees -gt 0){
        $x = $coordinates[0]
        $y = $coordinates[1]
        if ($clockwise){
            $coordinates = @($y,-$x)
        } else {
            $coordinates = @(-$y,$x)
        }
        $degrees = $degrees - 90
    }
    return $coordinates
}

function Invoke-UpdateWaypoint {
    param (
        $coordinates,
        $amount,
        $direction
    )
    $coordinates[0] = $coordinates[0] + ($amount * $direction[0])
    $coordinates[1] = $coordinates[1] + ($amount * $direction[1])
    return $coordinates
}

foreach ($line in $input){
    $director = $line.Substring(0,1)
    $amount = [int]$line.Substring(1)
    switch ($director){
        'F' { $location = Invoke-GoDirection $location $waypoint $amount }
        'R' { $waypoint = Invoke-RotateWaypoint $waypoint $amount }
        'L' { $waypoint = Invoke-RotateWaypoint $waypoint $amount $false }
        default { $waypoint = Invoke-UpdateWaypoint $waypoint $amount $compass[$director] }
    }
}
$manhattan_distance = [Math]::Abs($location[0]) + [Math]::Abs($location[1])
Write-Output $manhattan_distance