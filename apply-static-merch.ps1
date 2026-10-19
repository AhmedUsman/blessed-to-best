# Blessed to Best V4.6 - replace nonworking crossfade with one static, responsive banner.
# Safe to rerun. Execute from the root of your GitHub repository.
$ErrorActionPreference = 'Stop'
$repoRoot = (Get-Location).Path
$homepagePath = Join-Path $repoRoot 'index.html'
$fragmentPath = Join-Path $repoRoot 'merch-static-fragment.html'
$cssPath = Join-Path $repoRoot 'assets/css/merch-static-banner.css'
$desktopPath = Join-Path $repoRoot 'assets/merch/merch-all-four-desktop.webp'
$mobilePath = Join-Path $repoRoot 'assets/merch/merch-all-four-mobile.webp'
foreach ($requiredFile in @($homepagePath, $fragmentPath, $cssPath, $desktopPath, $mobilePath)) {
  if (-not (Test-Path $requiredFile)) { throw "Missing file: $requiredFile - ensure the entire ZIP was copied into the repository root." }
}
$encoding = New-Object System.Text.UTF8Encoding($false)
$page = [System.IO.File]::ReadAllText($homepagePath)
$fragment = [System.IO.File]::ReadAllText($fragmentPath).Trim()
# Remove all previously installed merch section(s), including V4.4/V4.5.
$oldBannerPattern = '(?is)<section\b(?=[^>]*\bid\s*=\s*["'']merch-drop-banner["''])[^>]*>.*?</section\s*>'
$page = [regex]::Replace($page, $oldBannerPattern, '')
if ($page -match '(?i)id\s*=\s*["'']merch-drop-banner["'']') { throw 'Could not safely remove an older merch section. No changes written.' }
# Insert immediately after the Favorites section without changing other content.
$fav = $page.IndexOf('Start with these favorites.', [StringComparison]::OrdinalIgnoreCase)
if ($fav -lt 0) { throw 'Favorites heading not found. No changes written.' }
$secStart = $page.LastIndexOf('<section', $fav, [StringComparison]::OrdinalIgnoreCase)
$secEnd = $page.IndexOf('</section>', $fav, [StringComparison]::OrdinalIgnoreCase)
if ($secStart -lt 0 -or $secEnd -lt 0) { throw 'Favorites section could not be located. No changes written.' }
if (-not $page.Substring($secStart, $secEnd - $secStart).Contains('product-grid')) { throw 'Unexpected Favorites layout. No changes written.' }
$insertAt = $secEnd + '</section>'.Length
$page = $page.Insert($insertAt, "`r`n" + $fragment + "`r`n")
# Remove slideshow script tag; no JS needed for static banner.
$page = [regex]::Replace($page,'(?i)<script\s+src\s*=\s*["'']/assets/js/merch-rotation\.js["'']\s+defer\s*></script>','')
# Include static stylesheet exactly once, regardless of prior banner patch version.
$styleTag = '<link rel="stylesheet" href="/assets/css/merch-static-banner.css">'
$page = $page.Replace($styleTag, '')
if (-not $page.Contains('</head>')) { throw 'Missing HTML </head>. No changes written.' }
$page = $page.Replace('</head>', $styleTag + "`r`n" + '</head>')
[System.IO.File]::WriteAllText($homepagePath,$page,$encoding)
Write-Host 'SUCCESS: Static four-product merch banner installed after Favorites.' -ForegroundColor Green
Write-Host 'Only homepage index.html updated; added one CSS file and two images.' -ForegroundColor Green
Write-Host 'Slideshow JavaScript disconnected. Existing /merch/ product page unchanged.' -ForegroundColor Green
