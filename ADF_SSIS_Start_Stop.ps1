param(
[parameter(Mandatory=$false)]
[string] $azureRunAsConnectionName = "AzureRunAsConnection",

[parameter(Mandatory=$true)]
[string] $resourceGroupName,

[parameter(Mandatory=$true)]
[string] $DataFactoryName,

[parameter(Mandatory=$true)]
[string] $AzureSSISName,

[parameter(Mandatory=$true)]
[bool] $stop
)



$runAsConnectionProfile = Get-AutomationConnection `
-Name $azureRunAsConnectionName
Add-AzureRmAccount -ServicePrincipal `
-TenantId $runAsConnectionProfile.TenantId `
-ApplicationId $runAsConnectionProfile.ApplicationId `
-CertificateThumbprint ` $runAsConnectionProfile.CertificateThumbprint | Out-Null
Write-Output "Authenticated with Automation Run As Account." 

if($stop) {
write-host("##### Stopping your Azure-SSIS integration runtime. #####")
Stop-AzureRmDataFactoryV2IntegrationRuntime -ResourceGroupName $ResourceGroupName `
                                             -DataFactoryName $DataFactoryName `
                                             -Name $AzureSSISName `
                                             -Force

}
else {
write-host("##### Starting your Azure-SSIS integration runtime. This command takes 20 to 30 minutes to complete. #####")
Start-AzureRmDataFactoryV2IntegrationRuntime -ResourceGroupName $ResourceGroupName `
                                             -DataFactoryName $DataFactoryName `
                                             -Name $AzureSSISName `
                                             -Force											 
}
