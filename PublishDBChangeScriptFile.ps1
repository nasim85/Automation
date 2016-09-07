﻿param([string]$RootPath="C:\AHToAccess\R2014.4\Database\SSDP\ACH_DB_All",[string]$DropLocation="C:\AHToAccess\R2014.4\Database\SSDP",[string]$BuildName=(Get-Date -format 'yyyyMMdd') +"_"+(Get-Date -format 'HHmm'),[string]$ENV="CI")


#Import-Module "SQLMaint"
#Import-Module "SQLServer"

 ###################### Global Variables ########################################
 $EnvConfigPath =""
 $LogPath =""
 $EnvDetailList =""
 # Local database veriable details for deployment.
@(  $AccretiveDb =""
    $AccretiveServer=""
    $AccretiveLogsDb=""
    $AccretiveLogsServer=""
    $AuditDNNBetaDb=""
    $AuditDNNBetaServer=""
    $DataArchiveDb=""
    $DataArchiveServer=""
    $DefaultFDataPath=""
    $DNNDb=""
    $DNNServer=""
    $EligibilityDb=""
    $EligibilityServer=""
    $FileExchangeDb=""
    $FileExchangeServer=""
    $ReferenceDb=""
    $ReferenceServer="" )

 # Out put Log File 
 $LogPath = $DropLocation+"\Logs\"
 $LogFilePath =$LogPath + $BuildName+"_EventLog_Summary.txt"

    # Function for loging events and exceptions 
    Function LogFileGen([string] $SummaryTxt )
    {  
        #Write-Host $SummaryTxt
        $SummaryTxt +" Time : "+$((Get-Date).ToString('yyyy,MM,dd hh:mm:ss')) |Out-File -FilePath $LogFilePath -Append 
    }
    # Validate log file path.
     try
     {
        If (!$(Test-Path -Path $LogPath)){New-Item -ItemType "directory" -Path $LogPath | Out-Null}
     }
     Catch
     {
       LogFileGen -SummaryTxt "Creating Log Folder : "$error
     }
 #============================================================================

 # Validate and read environment config details.
 LogFileGen -SummaryTxt "Reading Environment Config file"
 $EnvConfigPath  = $RootPath+"\..\..\aaDeployment_Scripts\DeploymentTools\EnvironmentConfig-"+$ENV+".csv"
 if (Test-Path $EnvConfigPath ) 
 {
    $EnvDetailList= Import-Csv $EnvConfigPath | Where-Object {$_.env -eq $Env}
 }
 Else
 {
     LogFileGen -SummaryTxt "Environment Config file Missing."
 }

###################### SQLPackage Load ###############################
 $SQLPkgPath="${env:ProgramFiles(x86)}\Microsoft SQL Server\110\DAC\bin\sqlpackage.exe"
 $TFS = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 11.0\Common7\IDE\tf.exe"
 #Register the DLL we need
 Add-Type -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\110\DAC\bin\Microsoft.SqlServer.Dac.dll" 

############ Create a data table for holding change script details.
@( $dtScriptList = New-Object System.Data.DataTable            

 $dtScriptList.Columns.Add("FileName")| Out-Null
 $dtScriptList.Columns.Add("DBClass") | Out-Null
 $dtScriptList.Columns.Add("Order") | Out-Null
 $dtRow = $null)

# Function for adding new change script into TFS. 
Function ChekinFile([string] $FolderPath )
{  
   Try
   {
        &$TFS add $FolderPath /recursive /lock:none
        &$TFS checkin $FolderPath /comment:"Automation:Change Script generated by Build DB Automation." /noprompt
   }
   catch
   {
        LogFileGen -SummaryTxt ("Chekin File : "+ $_.Exception)
   }
}
# Generate OUT Script File Name and Location
Function GetOutScriptFileName([string] $DBClass)
{
    $FileNo =""
    $List = Get-ChildItem $RootPath"\DailyBuildScript" | Where-Object {$_.Extension -eq ".sql" -and $_.Name -match $ENV +"_*" -and $_.Name -match $DBClass }
    #$List
    if (($list.Count.ToString().length -le 1 ))
    {
       $FileNo= "0"+([int]$list.Count+1)
    }
    Elseif (($list.Count -eq 0 ))
    {
      $FileNo=  "01"
    }
    Else
    {
       $FileNo= ([int]$list.Count+1)
    }

    return $RootPath + "\DailyBuildScript\"+ $Env+"_"+$FileNo+$DBClass+"_"+$BuildName+".sql"
}
################ Function for Sql Script Cleanup.  
Function UpdateChangeScript([string] $SourceFile,[string] $TargetFile, [string] $DBClass,[Int] $Order,[bool] $IncludeTran )
{  

    $FileContaints =Get-Content $SourceFile 

     for ($i=0; $i -lt $FileContaints.Count; $i++)
        {
           ####################### Remove Drop User Scripts from Change Script
           # Write-Host $FileContaints.GetValue($i).ToString()
            $SummaryTxt ="";
            $PrintTRG = "Y"

            if ($IncludeTran -eq $true)
            {
                if ($FileContaints.GetValue($i) -match "PRINT N'Dropping" -and $FileContaints.GetValue($i+4) -match "DROP USER")
                    {
                        $i = $i+22
                        $SummaryTxt = $FileContaints.GetValue($i)
                        $PrintTRG ="N"
                    }
                    else
                    {
                        $SummaryTxt = $FileContaints.GetValue($i)
                    }
            }
            Else
            {
                if ($FileContaints.GetValue($i) -match "PRINT N'Dropping" -and $FileContaints.GetValue($i+4) -match "DROP USER")
                {
                    $i = $i+7
                    $SummaryTxt = $FileContaints.GetValue($i)
                    $PrintTRG ="N"
                }
                else
                {
                    $SummaryTxt = $FileContaints.GetValue($i)
                }
            }

            if ($PrintTRG -eq "Y")
            {
               $SummaryTxt |Out-File -FilePath $TargetFile -Append 
            }
        }
    #Add Change SCript Details into script Collection.
    $dtRow = $dtScriptList.NewRow()
    $dtRow["FileName"]= $TargetFile
    $dtRow["DbClass"]= $DBClass
    $dtRow["Order"]= $Order
    $dtScriptList.Rows.Add($dtRow)
}
# Generating Change script for all Databases.
try
{
   # 1-DNN30 
   # 2-DNNStage 
   # 3-ClaimStatus
   # 4-CrossSiteYBFU
   # 5-Reference
   # 6-Global_AhtoDialer
   # 7-DataArchive
   # 8-ELIGIBILITY
   # 9-Accretive  ########################################################################## 
    LogFileGen -SummaryTxt "Start-Accretive Change Script."
   if ((Test-Path $RootPath\Bin\Accretive.dacpac ) -and (Test-Path $RootPath\Accretive\Accretive_$Env.publish.xml))
   {

       $ProfilePath="$RootPath"+"\Accretive\Accretive_"+$Env+".publish.xml"
       $dacProfile = [Microsoft.SqlServer.Dac.DacProfile]::Load($ProfilePath)

       $SQLPKGMSG= & $SQLPkgPath /a:Script /SourceFile:$RootPath\Bin\Accretive.dacpac /Profile:$ProfilePath /OutPutPath:$RootPath\Bin\Accretive.sql 

       #Get Published File Info
       LogFileGen -SummaryTxt "Updating sql script file."

       if (Test-Path $RootPath\Bin\Accretive.sql ) 
       {
            $OutScriptFile =GetOutScriptFileName -DBClass "Accretive"
            UpdateChangeScript -SourceFile $RootPath"\Bin\Accretive.sql" -TargetFile $OutScriptFile -DBClass "Accretive" -Order 9 -IncludeTran $dacProfile.DeployOptions.IncludeTransactionalScripts
       }
       Else
       {
            LogFileGen -SummaryTxt "Accretive:Script file not generated."
       }
       LogFileGen -SummaryTxt "END-Accretive Change Script."
  }
  Else
  {
    LogFileGen -SummaryTxt "Accretive:.dacpac or .publish file not found."
  }
  # 10-AccretiveLogs
  # 11-CrossSiteSupport
  # 12-Global_FCC_PreRegistration
  # 13-TranGLOBAL
  # 14-FileExchange
  # 15-Tran
}
Catch
{
   LogFileGen -SummaryTxt $_.Exception.ToString()
}

######### Print Datatable data ################

$dtScriptList | Format-Table -AutoSize

##################### Publish the change to target database ######################



Try
{

    # Function for asigining value to all deployment veriables.
    Function AsignDeploymentVeriable()
    {
        LogFileGen -SummaryTxt "Asigining Deployment Veriable Values."

        if ($EnvDetailList.Count -gt 0)
        {
            #Accretive
            $EnvValue = $EnvDetailList|  Where-Object {$_.dbclass -eq 'Accretive' -and $_.Replication -in ('Pub','None')}|Select-Object -First 1
            $AccretiveDb = $EnvValue.DbName
            $AccretiveServer = $EnvValue.ServerName
            #AccretiveLogs
            $EnvValue = $EnvDetailList|  Where-Object {$_.dbclass -eq 'AccretiveLogs' -and $_.Replication -in ('Pub','None')}|Select-Object -First 1
            $AccretiveLogsDb = $EnvValue.DbName
            $AccretiveLogsServer = $EnvValue.ServerName

            #Audit11.DNNBeta
            $EnvValue = $EnvDetailList|  Where-Object {$_.dbclass -eq 'Audit11.DNNBeta' -and $_.Replication -in ('Pub','None')}|Select-Object -First 1
            $AuditDNNBetaDb = $EnvValue.DbName
            $AuditDNNBetaServer = $EnvValue.ServerName


            #DataArchive
            $EnvValue = $EnvDetailList|  Where-Object {$_.dbclass -eq 'DataArchive' -and $_.Replication -in ('Pub','None')}|Select-Object -First 1
            $DataArchiveDb = $EnvValue.DbName
            $DataArchiveServer = $EnvValue.ServerName

            #DNN
            $EnvValue = $EnvDetailList|  Where-Object {$_.dbclass -eq 'DNN30' -and $_.Replication -in ('Pub','None')}|Select-Object -First 1
            $DNNDb = $EnvValue.DbName
            $DNNServer = $EnvValue.ServerName

            #DNN
            $EnvValue = $EnvDetailList|  Where-Object {$_.dbclass -eq 'Eligibility' -and $_.Replication -in ('Pub','None')}|Select-Object -First 1
            $EligibilityDb = $EnvValue.DbName
            $EligibilityServer = $EnvValue.ServerName

            #FileExchange
            $EnvValue = $EnvDetailList|  Where-Object {$_.dbclass -eq 'FileExchange' -and $_.Replication -in ('Pub','None')}|Select-Object -First 1
            $FileExchangeDb = $EnvValue.DbName
            $FileExchangeServer = $EnvValue.ServerName

            #Reference
            $EnvValue = $EnvDetailList|  Where-Object {$_.dbclass -eq 'Reference' -and $_.Replication -in ('Pub','None')}|Select-Object -First 1
            $ReferenceDb = $EnvValue.DbName
            $ReferenceServer = $EnvValue.ServerName

        }
        
    }
   AsignDeploymentVeriable
   # Function for execute sql scripts.
    function execute-Sql{
       param($ServerName, $DbName, $ScriptFile,$DeployVarArray)

       $LogFilePath =$LogPath + $BuildName+"_"+$ServerName+"_"+$DbName+"_OutPut.txt"
       try
       {
            Invoke-Sqlcmd -ServerInstance "$ServerName" -Database "$DbName" -InputFile "$ScriptFile" -Variable $DeployVarArray -OutputSqlErrors:$true -Verbose *>&1  |Out-File -FilePath $LogFilePath
       }
       Catch
       {
            $_.Exception.ToString()|Out-File -FilePath $LogFilePath -Append 
            LogFileGen -SummaryTxt ( "Execute SQL Error : " +$_.Exception)
       }
    }

   # 1-DNN30 
   # 2-DNNStage 
   # 3-ClaimStatus
   # 4-CrossSiteYBFU
   # 5-Reference
   # 6-Global_AhtoDialer
   # 7-DataArchive
   # 8-ELIGIBILITY
   # 9-Accretive  ########################################################################## 

   if ($dtScriptList.Rows.Count -gt 0)
   {
      
       foreach($Row in $dtScriptList.Rows)
       {
           $EnvValue = $EnvDetailList|  Where-Object {$_.dbclass -eq $Row["DbClass"].ToString() -and $_.Replication -in ('Pub','None')}
           foreach($EnvRow in $EnvValue)
           {
               LogFileGen -SummaryTxt ("Deploying Script on :" + $EnvRow.SERVERNAME.Trim()+"_"+$EnvRow.DBNAME)
               $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME)
              # Invoke-Sqlcmd -ServerInstance $EnvDetail.SERVERNAME.Trim() -Database $EnvDetail.DBNAME.Trim() -InputFile $OutFile -Verbose -Variable $MyArrayAcc
               execute-Sql -ServerName $EnvRow.SERVERNAME.Trim() -DbName $EnvRow.DBNAME.Trim() -ScriptFile $Row["FileName"].ToString() -DeployVarArray $MyArrayAcc
           }
       }
   }
   # 10-AccretiveLogs
   # 11-CrossSiteSupport
   # 12-Global_FCC_PreRegistration
   # 13-TranGLOBAL
   # 14-FileExchange
   # 15-Tran
}
catch
{
  LogFileGen -SummaryTxt $_.Exception  
}
#IF($FlagAction -eq "3" -OR $FlagAction -eq "0"){
# Publish the chnages to the target server
#& $SQLPkgPath /a:Publish /tsn:$TargetServer /tdn:$TargetDB /sf:$SourceFile /p:RegisterDataTierApplication=True /p:BlockWhenDriftDetected=False /p:IgnoreUserSettingsObjects=True /P:IgnoreRoleMembership=True /P:IgnorePermissions=True /P:AllowIncompatiblePlatform=True
#& $SQLPkgPath /a:Publish /Profile:$DacProfile /sf:$SourceFile 
#}


