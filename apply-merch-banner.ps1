# Blessed to Best - add one homepage merch banner without overwriting existing edits.
$ErrorActionPreference = 'Stop'
$root = (Get-Location).Path
$homeFile = Join-Path $root 'index.html'
$css = Join-Path $root 'assets/css/styles.css'
if (-not (Test-Path $homeFile) -or -not (Test-Path $css)) {
  throw 'Run this script from the root of the Blessed to Best repository (where index.html is located).'
}
$html = [System.IO.File]::ReadAllText($homeFile)
$styles = [System.IO.File]::ReadAllText($css)
if ($html.Contains('id="merch-drop-banner"')) {
  Write-Host 'Homepage merch banner already installed. No changes made.'
  exit 0
}
if (-not $html.Contains('</main>')) { throw 'Cannot find </main> in index.html; no changes made.' }
$banner = @'
<section class="merch-drop-section" id="merch-drop-banner" aria-labelledby="merch-drop-title">
  <div class="container">
    <div class="merch-drop-panel">
      <div class="merch-drop-content">
        <p class="merch-drop-eyebrow">NEW · BLESSED TO BEST APPAREL</p>
        <h2 id="merch-drop-title">The merch drop<br><em>is here.</em></h2>
        <p>Wear the reminder. Discover Blessed to Best hoodies and tees, made for everyday comfort and a little extra confidence.</p>
        <a class="btn merch-drop-cta" href="/merch/">Shop the merch drop <span aria-hidden="true">→</span></a>
      </div>
      <div class="merch-drop-art" aria-hidden="true"><span>BLESSED</span><i>to</i><span>BEST</span></div>
    </div>
  </div>
</section>
'@
$cssBlock = @'

/* Blessed to Best merch drop: homepage-only banner */
.merch-drop-section{padding:0 0 84px;background:#fff}
.merch-drop-panel{display:grid;grid-template-columns:1.2fr .8fr;gap:36px;align-items:center;overflow:hidden;position:relative;padding:clamp(30px,5vw,68px);border-radius:28px;background:linear-gradient(125deg,#4e2936 0%,#38212e 72%,#563042 100%);color:#fff;box-shadow:0 20px 55px rgba(58,31,42,.15)}
.merch-drop-panel:before{content:"";position:absolute;width:340px;height:340px;border:1px solid rgba(250,210,220,.18);border-radius:50%;right:-110px;top:-170px;pointer-events:none}
.merch-drop-content{position:relative;z-index:1}
.merch-drop-eyebrow{margin:0 0 14px;color:#e7b9c5;font-size:.72rem;letter-spacing:.2em;font-weight:800}
.merch-drop-panel h2{margin:0 0 18px;font:500 clamp(2.5rem,5vw,4.8rem)/1.02 Georgia,serif;letter-spacing:-.045em}
.merch-drop-panel h2 em{color:#efb6c7;font-weight:400}
.merch-drop-content>p:not(.merch-drop-eyebrow){max-width:510px;margin:0 0 25px;color:#f4e8eb;font-size:1rem;line-height:1.7}
.merch-drop-cta{background:#f3c3d0!important;color:#35202a!important;white-space:normal;text-align:center}
.merch-drop-cta:hover{background:#fff!important}
.merch-drop-art{display:flex;flex-direction:column;align-items:center;justify-content:center;min-height:230px;padding:18px 0;border:1px solid rgba(244,195,208,.2);border-radius:18px;color:#f2c4d0;font-family:Georgia,serif;text-align:center}
.merch-drop-art span{font-size:clamp(1.9rem,3.7vw,3.6rem);letter-spacing:.17em;line-height:1.25}
.merch-drop-art i{font-size:clamp(1.2rem,2vw,2rem);line-height:1.4}
@media(max-width:700px){.merch-drop-section{padding:0 0 48px}.merch-drop-panel{grid-template-columns:1fr;gap:22px;padding:32px 25px;border-radius:22px}.merch-drop-panel h2{font-size:clamp(2.5rem,10vw,3.7rem)}.merch-drop-art{min-height:115px;padding:14px;flex-direction:row;gap:10px}.merch-drop-art span{font-size:clamp(1.1rem,5vw,1.7rem);letter-spacing:.08em}.merch-drop-art i{font-size:1.1rem}.merch-drop-cta{width:100%}}
@media(max-width:360px){.merch-drop-panel{padding:26px 18px}.merch-drop-art{gap:6px}.merch-drop-art span{font-size:1rem}}
'@
$html = $html.Replace('</main>', $banner + '</main>')
if (-not $styles.Contains('/* Blessed to Best merch drop: homepage-only banner */')) {
  $styles += $cssBlock
}
[System.IO.File]::WriteAllText($homeFile,$html,[System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText($css,$styles,[System.Text.UTF8Encoding]::new($false))
Write-Host 'Added homepage merch banner. Only index.html and assets/css/styles.css changed.'
