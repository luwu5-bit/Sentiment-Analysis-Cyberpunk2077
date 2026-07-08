# Build the submission ZIP (Cyberpunk_Sentiment_Group1.zip).
# Run from the project root:  powershell -ExecutionPolicy Bypass -File make_submission.ps1
# Place the finished report.pdf in the project root first so it is included.
$ErrorActionPreference = 'Stop'
$stage = 'submission_stage'
$zip   = 'Cyberpunk_Sentiment_Group1.zip'

if (Test-Path $stage) { Remove-Item -Recurse -Force $stage }
New-Item -ItemType Directory -Force "$stage\notebooks", "$stage\data" | Out-Null

Copy-Item README.md $stage
Copy-Item notebooks\pipeline.ipynb, notebooks\pipeline.html "$stage\notebooks"
Copy-Item -Recurse data\sample "$stage\data\sample"
Copy-Item -Recurse results "$stage\results"
if (Test-Path Project Report_Group 1.pdf) { Copy-Item Project Report_Group 1.pdf $stage; $pdf = 'included' }
else { $pdf = 'MISSING — add report.pdf to the project root and re-run' }

if (Test-Path $zip) { Remove-Item $zip }
Compress-Archive -Path "$stage\*" -DestinationPath $zip -CompressionLevel Optimal
Remove-Item -Recurse -Force $stage

"ZIP {0} = {1} MB | PDF: {2}" -f $zip, [math]::Round((Get-Item $zip).Length / 1MB, 1), $pdf
