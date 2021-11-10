<#
Simple script to copy parts of one object to another, with the posibility to define the name for the new key at destination
#>

# Sample PowerShell Object used as Source
$SourceObject = @{
  "Key1" = "Value1"
  "Key2" = "Value2"
  "Key3" = "Value3"
  "Key4" = "Value4"
}

# Empty PowerShell Object used as destination
$DestinationObject = @{}

# Define Keys to copy
$KeysToCopy = @(
  @{
    # Name of the key
    name        = "Key1"
    # Optionally new key name in the destination object
    destination = "Key2"
  }
  @{
    name = "Key3"
  }
  @{
    name = "Key4"
  }
)

# Foreach loop that does the copy job
foreach ($KeyToCopy in $KeysToCopy) {
  if ($KeyToCopy.destination) {
    $DestinationObject.Add($KeyToCopy.destination, $SourceObject.$($KeyToCopy.name))
  }
  else {
    $DestinationObject.Add($KeyToCopy.name, $SourceObject.$($KeyToCopy.name))
  }     
}

# Print result to screen
$DestinationObject

# Name                           Value
# ----                           -----
# Key3                           Value3
# Key4                           Value4
# Key2                           Value1
