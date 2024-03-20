# Empty hashtable
$ht = New-Object -TypeName hashtable
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

# Sorting
$ht | Sort-Object -Property Name
$ht.GetEnumerator() | Sort-Object -Property Name

# Ordered
$ht = [ordered]@{
    Event    = 'PowerShell Summit 2024'
    Date     = '2024-04-10'
    Location = 'Bellevue, WA'
}
$ht

# Nested
$ht = @{
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

# Large hashtable
$ht = @{
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

# As an array
$ht = @{
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

# Cleanup
Remove-Variable ht