$global:progressPreference = 'silentlyContinue'

#--------------------------------------------------------------
#                Start User Defined Variables
#--------------------------------------------------------------

#define directory and txt files where traffic data will be stored
$textDir = "$HOME\Documents\WindowsPowerShell\Text_Files"
$trafficAtoBtxt = "$textDir\trafficAtoB.txt"
$trafficBtoAtxt = "$textDir\trafficBtoA.txt"

#define the names of location A and location B
$A = "Location A"  #(rename $A and $B to the name of your choosing)
$B = "Location B"

#define coordinates for location A and B
$LocACoords = "40.9613489,-74.2462697"  #(swap these coordinates to your coordinates)
$LocBCoords = "40.9589372,-74.2301864"

#--------------------------------------------------------------
#                 End User Defined Variables
#--------------------------------------------------------------

# gets current time and formats it
$currentTime = Get-Date -format "dd-MMM-yyyy"

#defines the google maps link structure for A and B
$trafficAtoB = "https://www.google.com/maps/dir/$LocACoords/$LocBCoords/am=t/"
$trafficBtoA = "https://www.google.com/maps/dir/$LocBCoords/$LocACoords/am=t/"

#output google traffic data to txt files
curl $trafficAtoB -o $trafficAtoBtxt
curl $trafficBtoA -o $trafficBtoAtxt

#string manipulation to extract relevant traffic data
$minuteline = cat $trafficAtoBtxt | % {$_.split("\n"::NewLine)} | Select-String -Pattern 'min\\' | select -first 1
$minuteline = $minuteline.ToString()
$locAtime = $minuteline.Split('"')[-1]

$minuteline2 = cat $trafficBtoAtxt | % {$_.split("\n"::NewLine)} | Select-String -Pattern 'min\\' | select -first 1
$minuteline2 = $minuteline2.ToString()
$locBtime = $minuteline2.Split('"')[-1]

$dash = " ------------------------------------------"

#output traffic data to terminal
echo "`n$dash`n  Traffic Conditions - $currentTime`n$dash`n   From $A to $B`n    $locAtime Minutes`n"
echo "`   From $B to $A`n    $locBtime Minutes`n$dash`n"       
