(function(){
  const s=window.BLESSED_STORE||window.BETTER_STORE||{products:{}};
  const btn=document.querySelector('[data-menu-btn]'),menu=document.querySelector('[data-mobile-menu]');
  if(btn&&menu){btn.addEventListener('click',()=>{let o=menu.classList.toggle('open');btn.setAttribute('aria-expanded',String(o));btn.setAttribute('aria-label',o?'Close navigation':'Open navigation');});}
  document.querySelectorAll('[data-price-slug]').forEach(el=>{const c=s.products?.[el.dataset.priceSlug];if(c?.price)el.textContent=c.price;});
  document.querySelectorAll('[data-affiliate-slug]').forEach(a=>{const c=s.products?.[a.dataset.affiliateSlug]||{};a.href=c.affiliateUrl?.trim()||s.generalAffiliate;a.rel='sponsored nofollow noopener';a.target='_blank';});
  document.querySelectorAll('[data-general-affiliate]').forEach(a=>{a.href=s.generalAffiliate;a.rel='sponsored nofollow noopener';a.target='_blank';});
  document.querySelectorAll('[data-giveaway-link]').forEach(a=>{a.href=s.giveawayUrl?.trim()||'/giveaway/';});
  document.querySelectorAll('[data-share]').forEach(b=>b.addEventListener('click',async()=>{try{if(navigator.share)await navigator.share({title:document.title,url:location.href});else{await navigator.clipboard.writeText(location.href);b.textContent='Copied!';}}catch(e){}}));
  document.querySelectorAll('[data-copy-link]').forEach(b=>b.addEventListener('click',async()=>{try{await navigator.clipboard.writeText(location.href);b.textContent='Copied!';}catch(e){}}));
  const range=document.querySelector('[data-comparison-range]');if(range){range.addEventListener('input',()=>{document.documentElement.style.setProperty('--compare',range.value+'%')})}
})();
