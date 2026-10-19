/* Blessed to Best V4.5 — only edit the four Shopify URLs below.
   Copy the FULL public product URL from your Detroit Got Grit Shopify store.
   Leave a value blank until that product is available.
   No cart or checkout is hosted on Blessed to Best. */
window.BLESSED_APPAREL_LINKS = {
  editorialTshirt:
    "https://detroitgotgrit.com/products/blessed-to-the-best-inspirational-t-shirt",
  editorialHoodie:
    "https://detroitgotgrit.com/products/blessed-to-best-inspirational-hoodie",
  cursiveTshirt:
    "https://detroitgotgrit.com/products/blessed-to-best-inspirational-quote-t-shirt",
  cursiveHoodie:
    "https://detroitgotgrit.com/products/blessed-to-best-calligraphy-hoodie",
};

(function () {
  const links = window.BLESSED_APPAREL_LINKS || {};
  for (const [key, raw] of Object.entries(links)) {
    const value = String(raw || "").trim();
    let valid = false;
    try {
      valid = new URL(value).protocol === "https:";
    } catch (e) {
      valid = false;
    }
    if (!valid) continue;
    document
      .querySelectorAll('[data-apparel-buy="' + key + '"]')
      .forEach((el) => {
        el.href = value;
        el.hidden = false;
      });
    document
      .querySelectorAll('[data-apparel-card-link="' + key + '"]')
      .forEach((el) => {
        el.href = value;
        el.hidden = false;
        el.target = "_blank";
        el.rel = "noopener noreferrer";
      });
    document
      .querySelectorAll('[data-apparel-card-static="' + key + '"]')
      .forEach((el) => {
        el.hidden = true;
      });
    document
      .querySelectorAll('[data-apparel-pending="' + key + '"]')
      .forEach((el) => {
        el.hidden = true;
      });
  }
})();
