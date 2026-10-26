# Renderiza as 6 cenas de ÚLTIMO ESTOQUE e junta tudo em um MP4 vertical.
$ErrorActionPreference = "Stop"
$Project = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Project

if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw "Node.js não encontrado. Instale Node.js 22 ou superior." }
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) { throw "FFmpeg não encontrado. Instale o FFmpeg e adicione ao PATH." }

New-Item -ItemType Directory -Force -Path "renders" | Out-Null
$scenes = @(
  "scene1-apartment.html",
  "scene2-corridor.html",
  "scene3-kitchen.html",
  "scene4-entrance.html",
  "scene5-street-market.html",
  "scene6-finale.html"
)

$concatFile = Join-Path $Project "renders\concat-list.txt"
if (Test-Path $concatFile) { Remove-Item $concatFile -Force }

for ($i = 0; $i -lt $scenes.Count; $i++) {
  $scene = $scenes[$i]
  if (-not (Test-Path $scene)) { throw "Arquivo de cena não encontrado: $scene" }
  $out = "renders\scene$($i+1).mp4"
  Write-Host ""
  Write-Host "[$($i+1)/$($scenes.Count)] Renderizando $scene ..." -ForegroundColor Cyan
  & npx --yes hyperframes render --composition $scene --output $out --fps 30 --quality standard
  if ($LASTEXITCODE -ne 0 -or -not (Test-Path $out)) { throw "Falha ao renderizar $scene. Veja o erro acima." }
  $absolute = (Resolve-Path $out).Path.Replace('\','/')
  Add-Content -Path $concatFile -Value "file '$absolute'" -Encoding utf8
}

Write-Host ""
Write-Host "Juntando as cenas..." -ForegroundColor Cyan
& ffmpeg -y -f concat -safe 0 -i $concatFile -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -r 30 -movflags +faststart "renders\ULTIMO-ESTOQUE.mp4"
if ($LASTEXITCODE -ne 0 -or -not (Test-Path "renders\ULTIMO-ESTOQUE.mp4")) { throw "Falha ao unir as cenas com FFmpeg." }

Write-Host ""
Write-Host "Pronto: renders\ULTIMO-ESTOQUE.mp4" -ForegroundColor Green
