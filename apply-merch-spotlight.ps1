# Blessed to Best: replace old broken banner with live mobile-friendly merch spotlight.
# Run from the repository root in VS Code's PowerShell terminal.
$ErrorActionPreference = 'Stop'
$repoRoot = (Get-Location).Path
$homepagePath = Join-Path $repoRoot 'index.html'
$stylesheetPath = Join-Path $repoRoot 'assets/css/styles.css'
$imagePath = Join-Path $repoRoot 'assets/merch/merch-banner-products.webp'
if (-not (Test-Path $homepagePath) -or -not (Test-Path $stylesheetPath)) {
  throw 'Cannot find index.html or assets/css/styles.css. Run in the GitHub repository root.'
}
if (-not (Test-Path $imagePath)) {
  throw 'Missing assets/merch/merch-banner-products.webp. Copy the assets folder from this patch first.'
}
$utf8 = New-Object System.Text.UTF8Encoding($false)
$page = [System.IO.File]::ReadAllText($homepagePath)
$styles = [System.IO.File]::ReadAllText($stylesheetPath)
# Remove previous spotlight and old merch drop if installed. Their sections have no nested <section>.
$oldPattern = '(?is)<section\b(?=[^>]*\bid\s*=\s*["'']merch-drop-banner["''])[^>]*>.*?</section\s*>'
$page = [regex]::Replace($page, $oldPattern, '')
# Do not duplicate our CSS on subsequent runs.
$newCssPattern = '(?s)/\* BTB APPAREL SPOTLIGHT START \*/.*?/\* BTB APPAREL SPOTLIGHT END \*/'
$styles = [regex]::Replace($styles, $newCssPattern, '')
# Pin placement using distinctive text from the existing Favorites heading rather than end of main.
$favoriteLocation = $page.IndexOf('Start with these favorites.', [StringComparison]::OrdinalIgnoreCase)
if ($favoriteLocation -lt 0) {
  throw 'Favorites heading not found. Nothing was written. Please share the relevant homepage HTML section.'
}
$sectionStart = $page.LastIndexOf('<section', $favoriteLocation, [StringComparison]::OrdinalIgnoreCase)
$sectionEnd = $page.IndexOf('</section>', $favoriteLocation, [StringComparison]::OrdinalIgnoreCase)
if ($sectionStart -lt 0 -or $sectionEnd -lt 0) {
  throw 'Could not identify closing Favorites section. Nothing was written.'
}
# Safeguard against insertion in unrelated section.
$favoriteHtml = $page.Substring($sectionStart, $sectionEnd - $sectionStart)
if (-not $favoriteHtml.Contains('product-grid')) {
  throw 'Favorites product grid not found in matching section. Nothing was written.'
}
$insertAt = $sectionEnd + '</section>'.Length
$banner = @'
<section class="btb-apparel-spotlight" id="merch-drop-banner" aria-labelledby="btb-apparel-title">
  <div class="container">
    <div class="btb-apparel-panel">
      <div class="btb-apparel-copy">
        <p class="btb-apparel-eyebrow">NEW &middot; BLESSED TO BEST APPAREL</p>
        <h2 id="btb-apparel-title">The merch drop <em>is here.</em></h2>
        <p class="btb-apparel-description">Wear the reminder. Discover Blessed to Best hoodies and tees, made for everyday comfort and a little extra confidence.</p>
        <a class="btb-apparel-button" href="/merch/">Shop the merch drop <span aria-hidden="true">&rarr;</span></a>
      </div>
      <div class="btb-apparel-products">
        <img src="/assets/merch/merch-banner-products.webp" alt="Blessed to Best apparel collection in white, blush pink, and heather gray" width="1312" height="724" loading="lazy" decoding="async">
      </div>
    </div>
  </div>
</section>
'@
$cssBlock = @'

/* BTB APPAREL SPOTLIGHT START */
.btb-apparel-spotlight {
  padding: clamp(35px, 5.4vw, 78px) 0;
  background: #fff;
}
.btb-apparel-panel {
  position: relative;
  display: flex;
  align-items: center;
  min-height: clamp(340px, 35vw, 430px);
  overflow: hidden;
  isolation: isolate;
  border-radius: 30px;
  background: radial-gradient(circle at 9% 90%, rgba(248,221,215,.52), transparent 47%), #fdf7f4;
  border: 1px solid rgba(162, 95, 107, .10);
  box-shadow: 0 15px 45px rgba(71, 39, 54, .055);
}
.btb-apparel-copy {
  position: relative;
  z-index: 2;
  flex: 0 0 47%;
  max-width: 520px;
  padding: clamp(28px, 5.3vw, 66px) 0 clamp(28px, 5.3vw, 66px) clamp(27px, 5.3vw, 65px);
}
.btb-apparel-eyebrow {
  margin: 0 0 16px;
  color: #a95470;
  letter-spacing: .16em;
  text-transform: uppercase;
  font: 700 .73rem/1.5 system-ui, sans-serif;
}
.btb-apparel-panel h2 {
  margin: 0 0 20px;
  color: #432f3a;
  font: 500 clamp(2.4rem, 4.5vw, 4.15rem)/1.03 Georgia, 'Times New Roman', serif;
  letter-spacing: -.045em;
  text-wrap: balance;
}
.btb-apparel-panel h2 em {
  display: block;
  color: #a95470;
  font-weight: 400;
}
.btb-apparel-description {
  max-width: 425px;
  margin: 0 0 25px;
  color: #64535c;
  font-size: clamp(.91rem, 1.33vw, 1.05rem);
  line-height: 1.65;
}
.btb-apparel-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  min-height: 50px;
  max-width: 100%;
  padding: 14px 27px;
  border-radius: 999px;
  background: #ad5572;
  color: #fff;
  text-decoration: none;
  font: 700 .96rem/1.2 system-ui, sans-serif;
  text-align: center;
  transition: transform .18s ease, background .18s ease;
}
.btb-apparel-button:hover, .btb-apparel-button:focus-visible { background: #8d405d; transform: translateY(-2px); color: #fff; }
.btb-apparel-button:focus-visible { outline: 3px solid #4b2d3d; outline-offset: 3px; }
.btb-apparel-products {
  position: absolute;
  z-index: 1;
  inset: 0 0 0 auto;
  width: 63%;
  overflow: hidden;
  -webkit-mask-image: linear-gradient(to right, transparent 0%, #000 18%, #000 100%);
  mask-image: linear-gradient(to right, transparent 0%, #000 18%, #000 100%);
}
.btb-apparel-products img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: 55% center;
}
@media (max-width: 940px) {
  .btb-apparel-panel { min-height: 345px; }
  .btb-apparel-copy { flex-basis: 51%; padding-left: 32px; }
  .btb-apparel-panel h2 { font-size: clamp(2.3rem, 5.2vw, 3.3rem); }
  .btb-apparel-products { width: 58%; }
}
@media (max-width: 680px) {
  .btb-apparel-spotlight { padding: 38px 0 50px; }
  .btb-apparel-panel { display: flex; flex-direction: column; align-items: stretch; min-height: 0; border-radius: 24px; }
  .btb-apparel-copy { flex: auto; max-width: none; padding: 32px 25px 8px; }
  .btb-apparel-eyebrow { font-size: .67rem; letter-spacing: .12em; margin-bottom: 12px; }
  .btb-apparel-panel h2 { font-size: clamp(2.25rem, 9vw, 3.5rem); margin-bottom: 14px; }
  .btb-apparel-description { font-size: .94rem; line-height: 1.55; margin-bottom: 22px; }
  .btb-apparel-button { min-height: 48px; padding: 13px 22px; font-size: .91rem; }
  .btb-apparel-products { position: relative; width: 100%; height: clamp(185px, 54vw, 320px); inset: auto; -webkit-mask-image: linear-gradient(to bottom, transparent 0%, #000 17%); mask-image: linear-gradient(to bottom, transparent 0%, #000 17%); }
  .btb-apparel-products img { object-fit: cover; object-position: center 42%; }
}
@media (max-width: 365px) {
  .btb-apparel-copy { padding: 25px 19px 6px; }
  .btb-apparel-panel h2 { font-size: 2.15rem; }
  .btb-apparel-products { height: 180px; }
}
@media (prefers-reduced-motion: reduce) {
  .btb-apparel-button { transition: none; }
}
/* BTB APPAREL SPOTLIGHT END */

'@
$page = $page.Insert($insertAt, "`r`n" + $banner + "`r`n")
$styles = $styles.TrimEnd() + "`r`n`r`n" + $cssBlock + "`r`n"
[System.IO.File]::WriteAllText($homepagePath, $page, $utf8)
[System.IO.File]::WriteAllText($stylesheetPath, $styles, $utf8)
Write-Host 'Success: Replaced old merch banner and placed new spotlight directly after Favorites.' -ForegroundColor Green
Write-Host 'Updated: index.html, assets/css/styles.css' -ForegroundColor Green
Write-Host 'Image: assets/merch/merch-banner-products.webp' -ForegroundColor Green
Write-Host 'Preview locally, then commit and push with GitHub Desktop.'
