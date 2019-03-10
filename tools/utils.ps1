# Unsure if this will ever be needed ...
#    Started writing this code before I found native commands
# Function Update-CodeUri{
#     param(
#         $BuildDir = "./build/"
#     )
# }

# Function Update-BuildZip {
#     <# Ended up not needing this function #>
#     [CmdletBinding()]
#     Param(
#         [string]$ZIPFileName,
#         [Alias("FullName")]
#         [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
#         [string]$NewFileToAdd
#     )
#     begin{
#         [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | Out-Null
#         $zip = [System.IO.Compression.ZipFile]::Open($ZIPFileName,"Update")
#     }
#     process{
#         try{
#             $FileName = [System.IO.Path]::GetFileName($NewFileToAdd)
#             [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip,$NewFileToAdd,$FileName,"Optimal") | Out-Null
#             Write-Host "Successfully added $NewFileToAdd to $ZIPFileName "
#         } catch {
#             Write-Warning "Failed to add $NewFileToAdd to $ZIPFileName . Details : $_"
#         }
#     }
#     end{
#         $Zip.Dispose()
#     }
# }
