﻿param([string]$RootPath="C:\AHToAccess\R2014.4\Database\SSDP\ACH_DB_All",[string]$DropLocation="C:\AHToAccess\R2014.4\Database\SSDP",[string]$BuildName=(Get-Date -format 'yyyyMMdd') +"_"+(Get-Date -format 'HHmm'),[string]$ENV="CI")

 #Register the DLL we need #######################################################
 Add-Type -Path "${env:ProgramFiles(x86)}\Microsoft SQL Server\110\DAC\bin\Microsoft.SqlServer.Dac.dll" 

 ###################### Global Variables ########################################
 $EnvConfigPath =""
 $LogPath =""
 $EnvDetailList =""
 # Out put Log File ############################################################# 
 $LogPath = $DropLocation+"\Logs\"
 $LogFilePath =$LogPath + $BuildName+"_EventLog_Summary.txt"
 ###################### SQLPackage Load #########################################
 $SQLPkgPath="${env:ProgramFiles(x86)}\Microsoft SQL Server\110\DAC\bin\sqlpackage.exe"
 $TFS = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 11.0\Common7\IDE\tf.exe"
 # Local database veriable details for deployment.###############################
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
 # Function for loging events and exceptions ####################################
 Function LogFileGen([string] $SummaryTxt )
 {  
        Write-Host $SummaryTxt
        $SummaryTxt +" Time : "+$((Get-Date).ToString('yyyy,MM,dd hh:mm:ss')) |Out-File -FilePath $LogFilePath -Append 
  }
 # Validate log file path.#######################################################
    Try
    {
        If (!$(Test-Path -Path $LogPath)){New-Item -ItemType "directory" -Path $LogPath | Out-Null}
    }
    Catch
    {
        LogFileGen -SummaryTxt "Creating Log Folder : "$error
    }
 # Validate and read environment config details.=================================
@( LogFileGen -SummaryTxt "Reading Environment Config file"
 $EnvConfigPath  = $RootPath+"\..\..\aaDeployment_Scripts\DeploymentTools\EnvironmentConfig-"+$ENV+".csv"
 if (Test-Path $EnvConfigPath ) 
 {
    $EnvDetailList= Import-Csv $EnvConfigPath  | Where-Object {$_.env -eq $Env}
 }
 Else 
 {
     LogFileGen -SummaryTxt "Environment Config file Missing."
 }
 )

 # Create a data table for holding change script details.========================
@( $dtScriptList = New-Object System.Data.DataTable            

 $dtScriptList.Columns.Add("FileName")| Out-Null
 $dtScriptList.Columns.Add("DBClass") | Out-Null
 $dtScriptList.Columns.Add("Order", [int]) | Out-Null
 $dtRow = $null)

# Function for adding new change script into TFS. ===============================
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
# Generate OUT Script File Name and Location ====================================
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
# Function for Sql Script Cleanup.  =============================================
Function UpdateChangeScript([string] $SourceFile,[string] $TargetFile, [string] $DBClass,[Int] $Order,[bool] $IncludeTran )
{  

    $FileContaints =Get-Content $SourceFile 

     for ($i=0; $i -lt $FileContaints.Count; $i++)
        {
 # Remove Drop User Scripts from Change Script =================================
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
  #Add Change SCript Details into script Collection.============================
    $dtRow = $dtScriptList.NewRow()
    $dtRow["FileName"]= $TargetFile
    $dtRow["DbClass"]= $DBClass
    $dtRow["Order"]= $Order
    $dtScriptList.Rows.Add($dtRow)
}
# Generating Change script for all Databases.===================================
Try
{
# Populate Database list. =======================================================
    @(
       # 1-DNN30 
       # 2-DNNStage 
       # 3-ClaimStatus
       # 4-CrossSiteYBFU
       # 5-Reference
       # 6-Global_AhtoDialer
       # 7-DataArchive
       # 8-ELIGIBILITY
       # 9-Accretive  
       # 10-AccretiveLogs
       # 11-CrossSiteSupport
       # 12-Global_FCC_PreRegistration
       # 13-TranGLOBAL
       # 14-FileExchange
       # 15-Tran
    $DatabaseList=@()
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "DNN30"; ExcOrder = "1" }
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "DNNStage"; ExcOrder = "2"   }
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "ClaimStatus"; ExcOrder = "3"}
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "CrossSiteYBFU"; ExcOrder = "4" }
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "Reference"; ExcOrder = "5" }
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "Global_AhtoDialer"; ExcOrder = "6" }
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "DataArchive"; ExcOrder = "7" }
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "ELIGIBILITY"; ExcOrder = "8" }
    $DatabaseList+=New-Object PsObject -property @{  DatabaseName = "Accretive"; ExcOrder = "9" }
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "AccretiveLogs"; ExcOrder = "10" }
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "CrossSiteSupport"; ExcOrder = "11" }
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "Global_FCC_PreRegistration"; ExcOrder = "12" }
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "TranGLOBAL"; ExcOrder = "13" }
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "FileExchange"; ExcOrder = "14" }
    #$DatabaseList+=New-Object PsObject -property @{  DatabaseName = "Tran"; ExcOrder = "15" }
   )
    $DatabaseList |Format-Table -AutoSize
    Function GenerateChangeScript([string] $DbProjectName,[int] $ExcOrder)
    {
       Try
        {
           $ProfilePath=($RootPath+"\"+$DbProjectName +"\"+$DbProjectName+"_"+$Env+".publish.xml")
           $ProjDacpacPath = ($RootPath+"\Bin\"+$DbProjectName+".dacpac")
           $OrgOutScriptPath = ($RootPath+"\Bin\"+$DbProjectName+".sql")
           $UpdatedChangeScriptFile = GetOutScriptFileName -DBClass $DbProjectName

              if ((Test-Path $ProjDacpacPath) -and (Test-Path $ProfilePath ))
              {
                   $dacProfile = [Microsoft.SqlServer.Dac.DacProfile]::Load($ProfilePath)
                   & $SQLPkgPath /a:Script /SourceFile:$ProjDacpacPath /Profile:$ProfilePath /OutPutPath:$OrgOutScriptPath

                   #Get Published File Info =====================================
                   LogFileGen -SummaryTxt ($DbProjectName +" : Updating sql script file.")
                   if (Test-Path $OrgOutScriptPath ) 
                   {
                        UpdateChangeScript -SourceFile $OrgOutScriptPath -TargetFile $UpdatedChangeScriptFile -DBClass $DbProjectName -Order $ExcOrder -IncludeTran $dacProfile.DeployOptions.IncludeTransactionalScripts
                   }
                   Else
                   {
                        LogFileGen -SummaryTxt ($DbProjectName +" :Script file not generated.")
                   }
      
              }
              Else
              {
                LogFileGen -SummaryTxt ($DbProjectName+" :.dacpac or .publish file not found.")
              } 
         }
         Catch
         {
             LogFileGen -SummaryTxt ("Error in Project "+$DProjectName+ " Function GenerateChangeScript. ErrorLog :"+$_.Exception)
         }
    }
# Iterate All Database and generate change script. ============================== 
    foreach ($Database in $DatabaseList)
    {
       LogFileGen -SummaryTxt ($Database.DatabaseName + " : Start Change Script Generation.")
       GenerateChangeScript -DbProjectName $Database.DatabaseName -ExcOrder $Database.ExcOrder
       LogFileGen -SummaryTxt ($Database.DatabaseName +" : END Change Script Generation.")
    }
# Publish the change to target database. ========================================
    Try
    {
      # Function for asigining value to all deployment veriables.================
        @(            
           LogFileGen -SummaryTxt "Asigining Deployment Veriable Values."

            if ($EnvDetailList.Count -gt 0)
            {
                if ($ENV -eq "CI")
                   {
                        $DefaultFDataPath ="E:\MSSQL\FTData\"
                   }
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
 )
      # Function for execute sql scripts. =======================================
       Function Execute-Sql{
           param($ServerName, $DbName, $ScriptFile,$DeployVarArray)

           $LogFilePath =$LogPath + $BuildName+"_"+$ServerName+"_"+$DbName+"_Log.txt"
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
       # Print Change script colletion data.=====================================
       $dtScriptList |Sort-Object Order |Format-Table -AutoSize
       if ($dtScriptList.Rows.Count -gt 0)
       {
       # Iterate throw change script list. ====================================== 
           foreach($Row in $dtScriptList.Rows)
           {
               # Iterate throw environment config records. ====================== 
               $EnvValue = $EnvDetailList|  Where-Object {$_.dbclass -eq $Row["DbClass"].ToString() -and $_.Replication -in ('Pub','None')}
               foreach($EnvRow in $EnvValue)
               {
                   LogFileGen -SummaryTxt ("Deploying Script on :" + $EnvRow.SERVERNAME.Trim()+"_"+$EnvRow.DBNAME)
                   # 1-DNN30 ====================================================
                   if ($Row["DbClass"].ToString() -eq "DNN30")
                   {
                        $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+"")
                   }
                   # 2-DNNStage ================================================= 
                   Elseif ($Row["DbClass"].ToString() -eq "DNNStage")
                   {
                        $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+"")
                   }
                   # 3-ClaimStatus ==============================================
                   Elseif ($Row["DbClass"].ToString() -eq "ClaimStatus")
                   {
                        $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+"")
                   }
                   # 4-CrossSiteYBFU ============================================
                   Elseif ($Row["DbClass"].ToString() -eq "CrossSiteYBFU")
                   {
                        $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+"")
                   }
                   # 5-Reference ================================================
                   Elseif ($Row["DbClass"].ToString() -eq "Reference")
                   {
                        $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+""),("DefaultFDataPath="+$DefaultFDataPath+"")
                   }
                   # 6-Global_AhtoDialer ========================================
                   Elseif ($Row["DbClass"].ToString() -eq "Global_AhtoDialer")
                   {
                        $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+""),("AccretiveDb="+$AccretiveDb+"")
                   }
                   # 7-DataArchive ==============================================
                   Elseif ($Row["DbClass"].ToString() -eq "DataArchive")
                   {
                        $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+""),("AccretiveDb="+$AccretiveDb+""),("AccretiveServer="+$AccretiveServer+""),("EligibilityDb="+$EligibilityDb+""),("EligibilityServer="+$EligibilityServer+"")
                   }
                   # 8-ELIGIBILITY ==============================================
                   Elseif ($Row["DbClass"].ToString() -eq "ELIGIBILITY")
                   {
                        $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+""),("AccretiveDb="+$AccretiveDb+""),("DataArchiveDb="+$DataArchiveDb+""),("DataArchiveServer="+ $DataArchiveServer+"")
                   }
                   # 9-Accretive ================================================
                   elseif ($Row["DbClass"].ToString() -eq "Accretive")
                   { 
                       $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+""),("DefaultFDataPath='"+$DefaultFDataPath+"'"),("AccretiveLogsDb="+ $AccretiveLogsDb+""),("AccretiveLogsServer="+$AccretiveLogsServer+""),("AuditDNNBetaDb="+$AuditDNNBetaDb+""),`
                                     ("AuditDNNBetaServer="+$AuditDNNBetaServer+""),("DataArchiveDb="+$DataArchiveDb+""),("DataArchiveServer="+$DataArchiveServer+""),("DNNDb="+$DNNDb+""),("EligibilityDb="+$EligibilityDb+""),("EligibilityServer="+$EligibilityServer+""),`
                                     ("FileExchangeDb="+$FileExchangeDb+""),("FileExchangeServer="+$FileExchangeServer+""),("ReferenceDb="+$ReferenceDb+"")
                   }
                    # 10-AccretiveLogs ==========================================
                   Elseif ($Row["DbClass"].ToString() -eq "AccretiveLogs") 
                   {
                        $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+""),("AccretiveDb="+$AccretiveDb+""),("DNNDb="+$DNNDb+""),("EligibilityDb="+$EligibilityDb+""),("EligibilityServer="+$EligibilityServer+"")
                   }
                    # 11-CrossSiteSupport =======================================
                   Elseif ($Row["DbClass"].ToString() -eq "CrossSiteSupport")
                   {
                         $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+""),("AccretiveDb="+$AccretiveDb+""),("AccretiveServer="+$AccretiveServer+"")
                   }
                    # 12-Global_FCC_PreRegistration =============================
                   Elseif ($Row["DbClass"].ToString() -eq "Global_FCC_PreRegistration")
                   {
                        $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+""),("AccretiveDb="+$AccretiveDb+"")
                   }
                    # 13-TranGLOBAL =============================================
                   Elseif ($Row["DbClass"].ToString() -eq "TranGLOBAL")
                   {
                        $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+""),("AccretiveDb="+$AccretiveDb+"")
                   }
                    # 14-FileExchange ===========================================
                   Elseif ($Row["DbClass"].ToString() -eq "FileExchange")
                   {
                        $MyArrayAcc = ("DatabaseName="+$EnvRow.DBNAME+""),("AccretiveDb="+$AccretiveDb+""),("AccretiveLogsDb="+$AccretiveLogsDb+""),("AccretiveLogsServer="+$AccretiveLogsServer+""),("DNNDb="+$DNNDb+""),("DNNServer="+$DNNServer+""),("ReferenceDb="+$ReferenceDb+""),("ReferenceServer="+$ReferenceServer+"")
                   }
                   # 15-Tran ====================================================
                   Elseif ($Row["DbClass"].ToString() -eq "Tran")
                   {

                   }
                   execute-Sql -ServerName $EnvRow.SERVERNAME.Trim() -DbName $EnvRow.DBNAME.Trim() -ScriptFile $Row["FileName"].ToString() -DeployVarArray $MyArrayAcc
               }
           }
       }
    }
    catch
    {
      LogFileGen -SummaryTxt $_.Exception  
    }
}
Catch
{
   LogFileGen -SummaryTxt $_.Exception.ToString()
}


