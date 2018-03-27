#Lets exit, just in case the script should run by accident
exit 

<#
This script adds two rules to the synchronization engine of Azure AD Connect.
Remember to fix it you have your deployment guids, a also review the country code at line 64
Can't remember all the sources for this script, but thanks to the internet then?
#>

Get-ADSyncConnector | Select-Object Name, Identifier

<#

Name                             Identifier                          
----                             ----------                          
mycompany.onmicrosoft.com - AAD  b891884f-xxxx-xxxx-xxxx-xxxxxxxxxxxx
localad.local                    0e9547d8-xxxx-xxxx-xxxx-xxxxxxxxxxxx

#>

Get-ADSyncRule | Select-Object Name, Identifier | Sort-Object Name

<#

Get-ADSyncRule | select Name, Identifier | sort Name

Name                                            Identifier                          
----                                            ----------                          
...
In from AAD - Group Join                        8a3977c6-cd6b-4929-a3de-b574728076cb
In from AAD - User Join                         abcc0b0d-afb6-45ca-b71f-6a2c84ca2ce7
...
Out to AAD - User Intune                        aad85d93-9ef1-4630-b58e-49fcb38c5a7e
Out to AAD - User Join                          4ae8b2e4-e22a-46e6-a71d-271f61fc4e02
...

#>

# Update these values accoring to output from Get-ADSyncConnector
$connectorAD = '<Guid>'
$connectorAAD = '<Guid>'

# Update these values accoring to output from Get-ADSyncRule
$ruleInFromADUserJoin = '<Guid>' # In from AD - User Join (Guid)
$ruleOutToAADUserJoin = '<Guid>' # Out to AAD - User Join (Guid)

New-ADSyncRule `
    -Name 'In from AD - User Usage Location - Custom' `
    -Description 'Import Usage Location from AD' `
    -Direction 'Inbound' `
    -Connector $connectorAD `
    -SourceObjectType 'user' `
    -TargetObjectType 'person' `
    -PrecedenceAfter  $ruleInFromADUserJoin `
    -LinkType 'Join' `
    -OutVariable syncRule

Add-ADSyncAttributeFlowMapping `
    -SynchronizationRule $syncRule[0] `
    -Source @('c') `
    -Destination 'usageLocation' `
    -FlowType 'Expression' `
    -ValueMergeType 'Update' `
    -Expression 'IIF(IsNullOrEmpty([c]),"NO",[c])'  # Replace NO with your defaul country code

Add-ADSyncRule -SynchronizationRule $syncRule[0]

#####

New-ADSyncRule  `
    -Name 'Out to AAD - User Usage Location - Custom' `
    -Description 'Export Usage Location to Azure AD' `
    -Direction 'Outbound' `
    -PrecedenceAfter $ruleOutToAADUserJoin `
    -SourceObjectType 'person' `
    -TargetObjectType 'user' `
    -Connector  $connectorAAD `
    -LinkType 'Join' `
    -OutVariable syncRule

Add-ADSyncAttributeFlowMapping  `
    -SynchronizationRule $syncRule[0] `
    -Source @('usageLocation') `
    -Destination 'usageLocation' `
    -FlowType 'Direct' `
    -ValueMergeType 'Update'

New-Object  `
    -TypeName 'Microsoft.IdentityManagement.PowerShell.ObjectModel.ScopeCondition' `
    -ArgumentList 'sourceObjectType','User','EQUAL' `
    -OutVariable condition0


New-Object  `
    -TypeName 'Microsoft.IdentityManagement.PowerShell.ObjectModel.ScopeCondition' `
    -ArgumentList 'cloudMastered','True','NOTEQUAL' `
    -OutVariable condition1

Add-ADSyncScopeConditionGroup  `
    -SynchronizationRule $syncRule[0] `
    -ScopeConditions @($condition0[0],$condition1[0]) `
    -OutVariable syncRule

Add-ADSyncRule -SynchronizationRule $syncRule[0]