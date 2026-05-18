/**
 * @file scroll-reveal.ts
 * @description IntersectionObserver-based scroll-reveal animation runner.
 *              Adds the `.visible` class to any element with `.reveal` once
 *              it enters the viewport. Also drives the count-up animation
 *              for elements with `[data-countup]`.
 *
 *              Both effects are skipped when the user prefers reduced motion,
 *              in which case all elements become immediately visible.
 *
 * @author GEMINI-UX
 * @phase 2
 * @created 2026-05-17T20:49:00Z
 */

const REDUCED_MOTION = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

/**
 * Reveal `.reveal` elements when they intersect the viewport.
 * Honors `data-reveal-delay` (ms) for stagger.
 */
function initRevealObserver(): void {
  const items = document.querySelectorAll<HTMLElement>('.reveal');
  if (items.length === 0) return;

  if (REDUCED_MOTION || !('IntersectionObserver' in window)) {
    items.forEach((el) => el.classList.add('visible'));
    return;
  }

  const observer = new IntersectionObserver(
    (entries) => {
      for (const entry of entries) {
        if (!entry.isIntersecting) continue;
        const target = entry.target as HTMLElement;
        const delay = Number(target.dataset.revealDelay ?? '0');
        if (delay > 0) {
          window.setTimeout(() => target.classList.add('visible'), delay);
        } else {
          target.classList.add('visible');
        }
        observer.unobserve(target);
      }
    },
    { threshold: 0.12, rootMargin: '0px 0px -40px 0px' },
  );

  items.forEach((el) => observer.observe(el));
}

/**
 * Animate numeric count-up for `[data-countup]` elements.
 * Reads the target value from `data-countup` and an optional
 * suffix from `data-countup-suffix` (e.g. "+", "%").
 */
function initCountUpObserver(): void {
  const items = document.querySelectorAll<HTMLElement>('[data-countup]');
  if (items.length === 0) return;

  const setFinal = (el: HTMLElement) => {
    const value = Number(el.dataset.countup ?? '0');
    const suffix = el.dataset.countupSuffix ?? '';
    el.textContent = `${value.toLocaleString('pt-BR')}${suffix}`;
  };

  if (REDUCED_MOTION || !('IntersectionObserver' in window)) {
    items.forEach(setFinal);
    return;
  }

  const animate = (el: HTMLElement) => {
    const target = Number(el.dataset.countup ?? '0');
    const suffix = el.dataset.countupSuffix ?? '';
    const duration = Number(el.dataset.countupDuration ?? '1600');
    const start = performance.now();

    const tick = (now: number) => {
      const elapsed = now - start;
      const progress = Math.min(elapsed / duration, 1);
      // easeOutQuart for a satisfying deceleration
      const eased = 1 - Math.pow(1 - progress, 4);
      const current = Math.round(target * eased);
      el.textContent = `${current.toLocaleString('pt-BR')}${suffix}`;
      if (progress < 1) requestAnimationFrame(tick);
    };

    requestAnimationFrame(tick);
  };

  const observer = new IntersectionObserver(
    (entries) => {
      for (const entry of entries) {
        if (!entry.isIntersecting) continue;
        animate(entry.target as HTMLElement);
        observer.unobserve(entry.target);
      }
    },
    { threshold: 0.4 },
  );

  items.forEach((el) => observer.observe(el));
}

function init(): void {
  initRevealObserver();
  initCountUpObserver();
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init, { once: true });
} else {
  init();
}
