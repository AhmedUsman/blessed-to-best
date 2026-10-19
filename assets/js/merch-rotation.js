/* Blessed to Best V4.5 — image-only homepage crossfade. */
(function () {
  const wrap = document.querySelector('#merch-drop-banner .btb-merch-rotator');
  if (!wrap) return;
  const frames = Array.from(wrap.querySelectorAll('.btb-merch-frame'));
  if (frames.length < 2) return;
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  const STEP_MS = 5000;
  let activeIndex = 0;
  let timer = null;
  const advance = () => {
    const next = (activeIndex + 1) % frames.length;
    frames[next].classList.add('is-active');
    frames[activeIndex].classList.remove('is-active');
    activeIndex = next;
  };
  const start = () => { if (timer === null && !document.hidden) timer = window.setInterval(advance, STEP_MS); };
  const stop = () => { if (timer !== null) { window.clearInterval(timer); timer = null; } };
  document.addEventListener('visibilitychange', () => { if (document.hidden) stop(); else start(); });
  start();
})();
