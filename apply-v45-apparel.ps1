# Blessed to Best — V4.5 COMPLETE apparel update
# Run from your GitHub repository root. Safe to rerun.
$ErrorActionPreference = 'Stop'
$repoRoot = (Get-Location).Path
$homePath = Join-Path $repoRoot 'index.html'
$cssPath = Join-Path $repoRoot 'assets/css/styles.css'
$fragmentPath = Join-Path $repoRoot 'banner-fragment.html'
$baseCssPath = Join-Path $repoRoot 'spotlight-base.css'
$fadeCssPath = Join-Path $repoRoot 'spotlight-fade.css'
$merchPath = Join-Path $repoRoot 'merch/index.html'
$merchCSSPath = Join-Path $repoRoot 'assets/css/merch.css'
$linksPath = Join-Path $repoRoot 'assets/js/apparel-links.js'
$rotationPath = Join-Path $repoRoot 'assets/js/merch-rotation.js'
$required = @($homePath,$cssPath,$fragmentPath,$baseCssPath,$fadeCssPath,$merchPath,$merchCSSPath,$linksPath,$rotationPath)
foreach ($file in $required) { if (-not (Test-Path $file)) { throw "Missing required file: $file`nCopy all patch files into the repository root before running." } }
foreach ($img in @('editorial-tee','editorial-hoodie','cursive-tee','cursive-hoodie')) {
  foreach ($variant in @('.webp','-banner.webp')) {
    $imgPath = Join-Path $repoRoot "assets/merch/v45/$img$variant"
    if (-not (Test-Path $imgPath)) { throw "Missing photo: $imgPath" }
  }
}
$utf8 = New-Object System.Text.UTF8Encoding($false)
$page = [System.IO.File]::ReadAllText($homePath)
$styles = [System.IO.File]::ReadAllText($cssPath)
$banner = [System.IO.File]::ReadAllText($fragmentPath).Trim()
# Remove any earlier edition of the same banner before reinserting after Favorites.
$oldBanner = '(?is)<section\b(?=[^>]*\bid\s*=\s*["'']merch-drop-banner["''])[^>]*>.*?</section\s*>'
$page = [regex]::Replace($page, $oldBanner, '')
# Explicitly reject unexpected or malformed layouts; no edits are written before these checks.
if ($page.IndexOf('id="merch-drop-banner"', [StringComparison]::OrdinalIgnoreCase) -ge 0) { throw 'Unrecognized older merch block. Nothing written.' }
$fav = $page.IndexOf('Start with these favorites.', [StringComparison]::OrdinalIgnoreCase)
if ($fav -lt 0) { throw 'Could not locate Favorites heading. Nothing written.' }
$secStart = $page.LastIndexOf('<section', $fav, [StringComparison]::OrdinalIgnoreCase)
$secEnd = $page.IndexOf('</section>', $fav, [StringComparison]::OrdinalIgnoreCase)
if ($secStart -lt 0 -or $secEnd -lt 0) { throw 'Favorites section structure changed. Nothing written.' }
$favHtml = $page.Substring($secStart, $secEnd - $secStart)
if (-not $favHtml.Contains('product-grid')) { throw 'Favorites product grid not found. Nothing written.' }
$insertAt = $secEnd + '</section>'.Length
$page = $page.Insert($insertAt,"`r`n"+$banner+"`r`n")
# Add stylesheet for existing spotlight only when a prior spotlight stylesheet is absent.
if (-not $styles.Contains('/* BTB APPAREL SPOTLIGHT START */')) {
  $styles += "`r`n`r`n" + [System.IO.File]::ReadAllText($baseCssPath)
}
$fadeStart = '/* BTB MERCH CROSSFADE V4.5 START */'
$fadeEnd = '/* BTB MERCH CROSSFADE V4.5 END */'
$fadePattern = '(?s)/\* BTB MERCH CROSSFADE V4\.5 START \*/.*?/\* BTB MERCH CROSSFADE V4\.5 END \*/'
$styles = [regex]::Replace($styles,$fadePattern,'')
$styles += "`r`n" + [System.IO.File]::ReadAllText($fadeCssPath)
$scriptTag = '<script src="/assets/js/merch-rotation.js" defer></script>'
# Insert exactly once, before </body>, and preserve existing store-data and site scripts.
$page = $page.Replace($scriptTag,'')
if (-not $page.Contains('</body>')) { throw 'Missing </body>. Nothing written.' }
$page = $page.Replace('</body>', $scriptTag + '</body>')
# Save only after successful validation and transformation.
[System.IO.File]::WriteAllText($homePath,$page,$utf8)
[System.IO.File]::WriteAllText($cssPath,$styles,$utf8)
Write-Host 'SUCCESS: Installed V4.5 apparel crossfade and 4-product gallery.' -ForegroundColor Green
Write-Host 'Changed: index.html, assets/css/styles.css, merch/index.html, assets/css/merch.css' -ForegroundColor Green
Write-Host 'New: four local mockup sets, assets/js/merch-rotation.js, assets/js/apparel-links.js' -ForegroundColor Green
Write-Host 'Edit Shopify links in assets/js/apparel-links.js, preview, then commit/push.' -ForegroundColor Green
