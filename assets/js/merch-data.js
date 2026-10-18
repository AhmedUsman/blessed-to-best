/* Blessed to Best apparel links. Use the public Shopify product URLs from Detroit Got Grit. */
window.BLESSED_MERCH = {
  hoodie:
    "https://detroitgotgrit.com/products/blessed-to-best-inspirational-hoodie", // Example: https://detroitgotgrit.com/products/blessed-to-best-hoodie
  tshirt:
    "https://detroitgotgrit.com/products/blessed-to-the-best-inspirational-t-shirt", // Example: https://detroitgotgrit.com/products/blessed-to-best-t-shirt
};

document.querySelectorAll("[data-merch]").forEach((link) => {
  const key = link.dataset.merch;
  const url = (window.BLESSED_MERCH[key] || "").trim();
  if (/^https:\/\/[^\s]+$/i.test(url)) {
    link.href = url;
    link.hidden = false;
    link.rel = "noopener noreferrer";
    document.querySelector(`[data-pending="${key}"]`)?.remove();
  }
});

const hoodieMain = document.querySelector("#hoodie-main-image");
document.querySelectorAll("[data-hoodie-image]").forEach((button) => {
  button.addEventListener("click", () => {
    if (!hoodieMain) return;
    hoodieMain.src = button.dataset.hoodieImage;
    hoodieMain.alt = button.dataset.hoodieAlt;
    document.querySelectorAll("[data-hoodie-image]").forEach((other) => {
      const selected = other === button;
      other.classList.toggle("is-active", selected);
      other.setAttribute("aria-pressed", String(selected));
    });
  });
});
