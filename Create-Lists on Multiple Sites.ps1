#Variables
$siteLocations = @("https://mysite.sharepoint.com/Site1/Subsite1"
                   #"https://cohnreznick.sharepoint.com/Site2/Subsite2", 
                   #"https://cohnreznick.sharepoint.com/Site3/Subsite3"
                   )
$listName = "Policies and Procedures Acknowledgements"
$trimmedListName = $listName -replace "\s+", ""
$listLocation = "List/" + $trimmedListName

#use for base text columns
$sLTextColumnName = @(
                "First Name",
                "Last Name",
                "Full Name",
                "Email Address",
                "Office",
                "Department"               
)
$mLTextColumnName = @(
                "Link"
)
$dateColumnName = @(
               "Submission Date"

)
$numberColumnName = @(
                "Employee ID"
)
$booleanColumnName = @(
                
)


$ClientId = '123456'
$ClientSecret = '234567'

try{
    foreach($siteLocation in $siteLocations){
        Connect-PnPOnline -Url $siteLocation -ClientId $ClientId -ClientSecret $ClientSecret
        Write-Host "Connection Successful: '$siteLocation'" -ForegroundColor Green
        #create new list
        Write-Host "Creating List: '$listName'" -ForegroundColor DarkYellow
            try{
                New-PnPList -Title $listName -Template GenericList -Url $listLocation
                Write-Host $listName "Successfully Created" -ForegroundColor Green
                #add list items
                $listItems = Get-PnPListItem -List $listName 
                Write-Host "Adding List Items" -ForegroundColor DarkYellow
                try{
                    #iterates through columnName array
                    foreach($columnItem in $sLTextColumnName){
                        Add-PnPField -List $listName -Type Text -DisplayName $columnItem -InternalName $columnItem  -AddToDefaultView
                    #Write-Host $columnItem -ForegroundColor Green
                    }
                    foreach($columnItem in $mLTextColumnName ){
                        Add-PnPField -Type Note -List $listName -DisplayName $columnItem -InternalName $columnItem -AddToDefaultView
                    }
                    foreach($columnItem in $dateColumnName ){
                        Add-PnPField -Type DateTime -List $listName -DisplayName $columnItem -InternalName $columnItem -AddToDefaultView
                    }
                    foreach($columnItem in $booleanColumnName ){
                        Add-PnPField -Type Boolean -List $listName -DisplayName $columnItem -InternalName $columnItem -AddToDefaultView
                    }
                    foreach($columnItem in $numberColumnName ){
                        Add-PnPField -Type Number -List $listName -DisplayName $columnItem -InternalName $columnItem -AddToDefaultView
                    }
                    Add-PnPField -Type Choice -List $listName -DisplayName "Group" -InternalName "Group" -AddToDefaultView -Choices ""
                    Add-PnPField -Type Choice -List $listName -DisplayName "SubGroup" -InternalName "SubGroup" -AddToDefaultView -Choices ""



                }catch{
                    Write-Host "Error creating list item(s) ->" $_.Exception.Message -ForegroundColor Red
                }

            }catch{
                Write-Host "Error creating list ->" $_.Exception.Message -ForegroundColor Red

            }
    }
}catch{
    Write-Host "Error Connecting. Check Credentials" $_.Exception.Message -ForegroundColor Red
}