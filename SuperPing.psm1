function superping {
    param (
        [parameter(Mandatory=$true)][string]$ipdebut,
        [string]$ipfin
        )
    
    if ($ipfin){
        $arrayipdebut = $ipdebut.Split("`.")
        $arrayipfin = $ipfin.Split("`.")

        while ([int]$arrayipdebut[3] -le [int]$arrayipfin[3]){
            $ipactuelle = $arrayipdebut -join '.'
            $cible = $cible + " " + $ipactuelle
            $arrayipdebut[3] = [string]([int]$arrayipdebut[3] + 1)
            }
            
            $arraycible = $cible.Split(" ")   
            $arraycible = $arraycible[1..($arraycible.length -1)]
            $requete = $arraycible -join "'or Address ='" 
            $arptargets = Get-WmiObject -Class Win32_PingStatus -Filter "(Address='$requete')" | Where StatusCode -EQ 0
            }

    else{
        $arptargets = Get-WmiObject -Class Win32_PingStatus -Filter "(Address='$ipdebut')" | Where StatusCode -EQ 0
        }

    $arpresults = foreach ($arptarget in $arptargets){
            Get-NetNeighbor -IPAddress $arptarget.Address -ErrorAction 0 | select IPAddress, LinkLayerAddress
            }
    $MacVendors = Import-Csv -Path $PSScriptRoot\mac-vendors-export.csv -Delimiter ","

    $arpids = foreach ($arpresult in $arpresults){
        $arpbeginning = $arpresult.LinkLayerAddress[0..7] -join ""
        $arpbeginning = $arpbeginning -replace '-',':'
        $arpcompare = foreach ($MacVendor in $MacVendors){        
            if ($MacVendor.Mac_Prefix -like $arpbeginning){
                $objetfinal = [PSCustomObject]@{
                    "IPv4Address" =  [IPAddress]$arpresult.IPAddress
                    "Address" = ([IPAddress]$arpresult.IPAddress).Address
                    "MacAddress" = $arpresult.LinkLayerAddress
                    "Vendor_Name" = $MacVendor.Vendor_Name
                    "4thOctet" = [int]$($arpresult.IPAddress).Split("`.")[3]
                    }
                $objetfinal            
                }
            }
        Write-Output $arpcompare            
        }
        
    $output = $arpids | Sort-Object -Property Address | select IPv4Address, MacAddress, Vendor_Name
    if ($output.IPv4Address -like "*.*.*.*"){
        $output
        }
    else{
        Write-output "Couldn`'t reach Host"
	} 
}