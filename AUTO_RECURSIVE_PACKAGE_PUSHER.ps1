    
    Clear-Host; 

    #$Destinations = @('BaGet','NuGet')

    $Path = "C:\ACT\Releases\"
    $Filter = "*.nupkg"
    
    $AllPackages = Read-Host -Prompt "Push All New Packages (Y / N): "
    # CRAP CODE BUT IT WORKS JUST DONT TYPE ;)
    $DestinationName = Read-Host -Prompt "Type the Destination Name: " 

    #if ($Destinations.Contains($DestinationName)) { Write-Host "Invalid Destination (Check Line 4)" Write-Host Script End }
    
    if ($AllPackages -eq "y") { 

        $directories = Get-ChildItem $path -Directory -Recurse
        
        foreach ($directory in $directories)
        {
            #Write-Output $directory.FullName;

            if ($directory.FullName.Contains("Release"))
            {  
                if (!$directory.FullName.Contains("Debug"))
                {          
                    #  $fullPath = Get-ChildItem -File -Filter *.nupkg -Path $directory.FullName | Sort CreationTime -Descending | Select-Object -First 1
                    $latest = Get-ChildItem -Path $directory.FullName -Filter $Filter | Sort-Object LastAccessTime -Descending | Select-Object -First 1
                    
                    if ($latest.FullName -ne $null)
                    {   
                        $FileNameToSend = $latest.FullName                    
                        if ($DestinationName -eq "baget") { PushToDestination $DestinationName $FileNameToSend }
                        elseif ($DestinationName -eq "nuget") { PushToDestination $DestinationName $FileNameToSend }
                        else 
                        {
                            Write-Host "Error Odd..."
                        }                        
                    }              
                }
            }  
        }
    }
    else
    {
        
    }
    
    Write-Host Script End;
    
function PushToDestination {
        Param
            (
                 [Parameter(Mandatory=$true, Position=0)]
                 [string] $Destination,
                 [Parameter(Mandatory=$true, Position=1)]
                 [string] $PackageName
            )

    Write-Host "Pushing $($PackageName) To $($Destination)"

    if ($Destination -eq "baget")
    {
         # PUT YOUR API KEY HERE
         $APIBAGET = ""
         $CommandBaGet = "nuget push $($PackageName) -Source http://localhost:5000/v3/index.json -ApiKey $($APIBAGET)" 
         Invoke-Expression $CommandBaGet
    }
    else # ($Destination -eq "nuget")
    {
        # PUT YOUR API KEY HERE
        'nuget setApiKey ""', 'nuget push "$PackageName" -Source https://api.nuget.org/v3/index.json' | Invoke-Expression
    }

    Write-Host Script End;
}