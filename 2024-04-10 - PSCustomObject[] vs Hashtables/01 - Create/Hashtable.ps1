# Empty hashtable
$ht = New-Object -TypeName hashtable
$ht

# Alternate empty hashtable
$ht = @{}
$ht

# Adding values
$ht.Add('Event', 'PowerShell Summit 2024')
$ht.Add('Date', '2024-04-10')
$ht.Add('Location', 'Bellevue, WA')
$ht

# Easy way
$ht = @{
    Event    = 'PowerShell Summit 2024'
    Date     = '2024-04-10'
    Location = 'Bellevue, WA'
}
$ht

# Or inline
$ht = @{ Event = 'PowerShell Summit 2024'; Date = '2024-04-10'; Location = 'Bellevue, WA' }
$ht

# Sorting properties
$ht | Sort-Object -Property Name -Descending
$ht.GetEnumerator() | Sort-Object -Property Name -Descending

# Ordered
$orderedHt = [ordered]@{
    Event    = 'PowerShell Summit 2024'
    Date     = '2024-04-10'
    Location = 'Bellevue, WA'
}
$orderedHt
$orderedHt.GetType()

# Nested
$nestedHt = @{
    Event    = 'PowerShell Summit 2024'
    Date     = @{
        Year  = 2024
        Month = 4
        Day   = 10
    }
    Location = @{
        City  = 'Bellevue'
        State = 'WA'
    }
}
$nestedHt

# Large(ish) hashtable
$largeHt = @{
    '2024-04-10' = @{
        Event    = 'PowerShell Summit 2024'
        Date     = @{
            Year  = 2024
            Month = 4
            Day   = 10
        }
        Location = @{
            City  = 'Bellevue'
            State = 'WA'
        }
    }
    '2024-04-11' = @{
        Event    = 'PowerShell Summit 2024'
        Date     = @{
            Year  = 2024
            Month = 4
            Day   = 11
        }
        Location = @{
            City  = 'Bellevue'
            State = 'WA'
        }
    }
}
$largeHt

# As an array
$arrayHt = @{
    Events = @(
        @{
            Event    = 'PowerShell Summit 2024'
            Date     = @{
                Year  = 2024
                Month = 4
                Day   = 10
            }
            Location = @{
                City  = 'Bellevue'
                State = 'WA'
            }
        },
        @{
            Event    = 'PowerShell Summit 2024'
            Date     = @{
                Year  = 2024
                Month = 4
                Day   = 11
            }
            Location = @{
                City  = 'Bellevue'
                State = 'WA'
            }
        }
    )
}
$arrayHt
$arrayHt.Events

# Array of hashtables
$arrayOfHts = 2024..2030 | ForEach-Object {
    @{
        Event    = "PowerShell Summit $_"
        Date     = @{
            Year  = $_
            Month = 4
            Day   = 10
        }
        Location = @{
            City  = 'Bellevue'
            State = 'WA'
        }
    }
}
$arrayOfHts

# Sorting an array of hashtables by a nested property
$arrayOfHts | Sort-Object -Property @{ Expression = { $_.Date.Year } } -Descending

# From JSON
$data = Get-Content '.\2024-04-10 - PSCustomObject`[`] vs Hashtables\MOCK_DATA.json' | ConvertFrom-Json -AsHashtable
$data[0]

# Any object type as a key
$validHt = @{
    $true            = 'True'
    $false           = 'False'
    1                = 'One'
    'One'            = 1
    [datetime]::Now  = 'Now'
    (Get-Process)[0] = (Get-Service)[0]
}
$validHt