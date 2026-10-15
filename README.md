# BLESSED TO BEST V4 — Netlify-ready affiliate product discovery site

**Domain:** https://blessedtobest.com
**Catalog:** 27 products (17 original + 10 newly approved)
**No cart or checkout.** Every Farmasi link is an affiliate outbound link.

## How to edit EVERYTHING commercial from one file

Open `assets/js/store-data.js`:

- Change `generalAffiliate` to edit all Visit Farmasi links.
- Change `giveawayUrl` when your external giveaway form is ready.
- Under `products`, fill each product `price` and `affiliateUrl`.
- Leave `affiliateUrl` empty to use the global storefront link, which is currently `https://www.farmasius.com/tatianagrantgrant`.
- Product prices deliberately show `$XX.XX` until manually entered.

Product names, descriptions, usage, formulas and SEO copy live in `data/products.json` AND are pre-rendered into static HTML. Editing a substantial description after deployment requires updating the corresponding HTML (or asking to regenerate).

## Images
- The original 17 product images are included locally, unaltered.
- The two Cleanse & Reset flavor compositions approved by the user are included as local WebP files.
- Eight sourced additional product photos currently load from official Farmasi image hosts or identifiable source hosts via remote URLs. `data/image-sources.json` lists each source.
- For 100% self-hosted performance and durability, replace the eight remote URLs with legally usable product photos saved under `assets/products/`. This is the only asset completeness limitation.
- Any remote image that fails displays a tasteful descriptive fallback rather than a broken image icon; the correct product name remains in the card/title.
- Tatiana's supplied PNG remains untouched in `assets/brand/tatiana.png`.

## Pages
- Static SEO product pages: `/products/{slug}/`, 27 pages.
- Search/filter catalog: `/shop/`.
- Category pages: cleanse, meal replacements, weight management, wellness, performance, skincare, beauty.
- Useful educational guides: `/guides/`.
- About and home contain explicit biography placeholders, with supplied original portrait.
- Giveaway site banner uses the configurable external link in `store-data.js`; no entry form exists on this static site.
- `/disclosure/`, `/privacy/`, `robots.txt`, `sitemap.xml`, schema on product pages, social share images.

## Launch QA checklist
1. Test all outbound affiliate URLs after adding real links in `store-data.js`.
2. Replace all 27 placeholder prices.
3. Replace Tatiana's biography placeholders with approved copy.
4. Add the real external giveaway form URL, eligibility, privacy and rules before advertising an event giveaway.
5. Confirm any current Farmasi formulation changes and availability; some new product details and usage could not be confirmed due catalog access restrictions.
6. Check 8 remote images on live site; self-host copies before launch if possible.
7. Connect the purchased domain `blessedtobest.com` in Netlify; point DNS to Netlify; enable HTTPS and canonical www redirect.
8. Verify in Search Console; submit `https://blessedtobest.com/sitemap.xml`.
9. If you add analytics, advertising or email capture, update Privacy Notice and add consent features as required.
10. Do not publish fake testimonials/before-after results. Interactive comparison feature was deliberately deferred until authenticated user-authorized images are supplied.

## Deploy
Unzip this ZIP; drag the CONTENTS of the `blessed_to_best_v4` folder to Netlify Drop (make sure `index.html` is at publish root). No dependencies, backend or build command needed.
