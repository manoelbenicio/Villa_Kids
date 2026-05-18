/**
 * @file app.js
 * @description Villa Prime v3 client interactions:
 * scroll reveal, KPI count-up, navbar scroll state, smooth anchors,
 * form feedback, and optional hero canvas particles.
 */

const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

function onReady(callback) {
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', callback, { once: true });
  } else {
    callback();
  }
}

function easeOutQuart(value) {
  return 1 - Math.pow(1 - value, 4);
}

function initScrollReveal() {
  const targets = Array.from(document.querySelectorAll('[data-animate], .reveal'));
  if (targets.length === 0) return;

  const reveal = (element) => {
    const delay = Number(element.dataset.revealDelay || element.dataset.animateDelay || 0);
    const apply = () => {
      element.classList.add('in');
      element.classList.add('visible');
    };

    if (delay > 0 && !reduceMotion) {
      window.setTimeout(apply, delay);
    } else {
      apply();
    }
  };

  if (reduceMotion || !('IntersectionObserver' in window)) {
    targets.forEach(reveal);
    return;
  }

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        reveal(entry.target);
        observer.unobserve(entry.target);
      });
    },
    { threshold: 0.12, rootMargin: '0px 0px -40px 0px' },
  );

  targets.forEach((element) => observer.observe(element));
}

function readCounterConfig(element) {
  const target = Number(element.dataset.count || element.dataset.countup || 0);
  return {
    target: Number.isFinite(target) ? target : 0,
    suffix: element.dataset.suffix || element.dataset.countupSuffix || '',
    duration: Number(element.dataset.duration || element.dataset.countupDuration || 1800),
  };
}

function formatCounter(value, target) {
  const options = Number.isInteger(target)
    ? { maximumFractionDigits: 0 }
    : { minimumFractionDigits: 1, maximumFractionDigits: 1 };
  return value.toLocaleString('pt-BR', options);
}

function countUp(element) {
  if (element.dataset.counted === 'true') return;
  element.dataset.counted = 'true';

  const { target, suffix, duration } = readCounterConfig(element);
  if (reduceMotion || duration <= 0) {
    element.textContent = `${formatCounter(target, target)}${suffix}`;
    return;
  }

  const startValue = 0;
  const start = performance.now();

  const tick = (now) => {
    const progress = Math.min((now - start) / duration, 1);
    const current = startValue + (target - startValue) * easeOutQuart(progress);
    element.textContent = `${formatCounter(current, target)}${suffix}`;

    if (progress < 1) {
      requestAnimationFrame(tick);
    }
  };

  requestAnimationFrame(tick);
}

function initCountUp() {
  const counters = Array.from(document.querySelectorAll('[data-count], [data-countup]'));
  if (counters.length === 0) return;

  if (reduceMotion || !('IntersectionObserver' in window)) {
    counters.forEach(countUp);
    return;
  }

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) return;
        countUp(entry.target);
        observer.unobserve(entry.target);
      });
    },
    { threshold: 0.45 },
  );

  counters.forEach((element) => observer.observe(element));
}

function initNavbarScrollState() {
  const navs = Array.from(document.querySelectorAll('#nav, .nav, .site-header'));
  if (navs.length === 0) return;

  let ticking = false;
  const update = () => {
    const isScrolled = window.scrollY > 30;
    navs.forEach((nav) => {
      nav.classList.toggle('scrolled', isScrolled);
      if (nav.classList.contains('site-header')) {
        nav.dataset.state = isScrolled ? 'scrolled' : 'top';
      }
    });
    ticking = false;
  };

  update();
  window.addEventListener(
    'scroll',
    () => {
      if (ticking) return;
      ticking = true;
      requestAnimationFrame(update);
    },
    { passive: true },
  );
}

function initSmoothAnchors() {
  document.addEventListener('click', (event) => {
    if (!(event.target instanceof Element)) return;

    const link = event.target.closest('a[href^="#"]');
    if (!link || event.defaultPrevented || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) {
      return;
    }

    const hash = link.getAttribute('href');
    if (!hash || hash === '#') return;

    let target = null;
    try {
      target = document.querySelector(hash);
    } catch {
      return;
    }
    if (!target) return;

    event.preventDefault();
    target.scrollIntoView({ behavior: reduceMotion ? 'auto' : 'smooth', block: 'start' });
    history.pushState(null, '', hash);
  });
}

function setFormFeedback(form, state, message) {
  const submit = form.querySelector('[type="submit"]');
  const status = form.querySelector('[role="status"], .form-status') || form.querySelector('[aria-live]');

  form.dataset.submitState = state;
  form.classList.toggle('is-submitting', state === 'submitting');
  form.classList.toggle('is-submitted', state === 'submitted');

  if (submit) {
    submit.classList.toggle('is-loading', state === 'submitting');
    submit.disabled = state === 'submitting';

    const textNode = submit.querySelector('.form-submit-text') || submit.querySelector('span');
    if (textNode) {
      if (!submit.dataset.originalText) submit.dataset.originalText = textNode.textContent.trim();
      textNode.textContent = message || submit.dataset.originalText;
    } else {
      if (!submit.dataset.originalText) submit.dataset.originalText = submit.textContent.trim();
      submit.textContent = message || submit.dataset.originalText;
    }
  }

  if (status && message) {
    status.textContent = message;
  }
}

function shouldSimulateSubmit(form) {
  const action = (form.getAttribute('action') || '').trim();
  return form.matches('#contactForm, [data-demo-form], [data-app-form]') || action === '' || action === '#';
}

function initFormFeedback() {
  const forms = Array.from(document.querySelectorAll('form'));
  if (forms.length === 0) return;

  forms.forEach((form) => {
    form.addEventListener('submit', (event) => {
      if (!form.checkValidity()) {
        event.preventDefault();
        setFormFeedback(form, 'invalid', 'Verifique os campos destacados antes de enviar.');
        form.reportValidity();
        return;
      }

      setFormFeedback(form, 'submitting', 'Enviando...');

      if (!shouldSimulateSubmit(form)) return;

      event.preventDefault();
      window.setTimeout(() => {
        setFormFeedback(form, 'submitted', 'Enviado!');
        form.reset();

        window.setTimeout(() => {
          setFormFeedback(form, 'idle');
        }, 2400);
      }, 650);
    });
  });
}

function initHeroCanvas() {
  const canvas = document.getElementById('heroCanvas');
  if (!canvas) return;

  const context = canvas.getContext('2d');
  if (!context) return;

  let width = 0;
  let height = 0;
  let animationFrame = 0;
  let pointerX = 0.5;
  let pointerY = 0.5;
  const pixelRatio = Math.min(window.devicePixelRatio || 1, 2);
  const parent = canvas.parentElement || canvas;

  const stars = Array.from({ length: 100 }, () => ({
    x: Math.random(),
    y: Math.random(),
    size: 0.8 + Math.random() * 2.4,
    phase: Math.random() * Math.PI * 2,
    speed: 0.012 + Math.random() * 0.024,
  }));

  const orbs = Array.from({ length: 30 }, () => ({
    x: Math.random(),
    y: Math.random(),
    radius: 18 + Math.random() * 42,
    vx: (Math.random() - 0.5) * 0.00045,
    vy: -0.00018 - Math.random() * 0.00042,
    hue: [45, 160, 280, 305, 320][Math.floor(Math.random() * 5)],
    alpha: 0.07 + Math.random() * 0.13,
  }));

  const resize = () => {
    const rect = parent.getBoundingClientRect();
    width = Math.max(rect.width, 1);
    height = Math.max(rect.height, 1);
    canvas.width = Math.round(width * pixelRatio);
    canvas.height = Math.round(height * pixelRatio);
    canvas.style.width = `${width}px`;
    canvas.style.height = `${height}px`;
    context.setTransform(pixelRatio, 0, 0, pixelRatio, 0, 0);
  };

  const drawConnections = (offsetX, offsetY) => {
    for (let i = 0; i < stars.length; i += 1) {
      for (let j = i + 1; j < stars.length; j += 1) {
        const dx = (stars[i].x - stars[j].x) * width;
        const dy = (stars[i].y - stars[j].y) * height;
        const distance = Math.sqrt(dx * dx + dy * dy);

        if (distance < 120) {
          context.beginPath();
          context.moveTo(stars[i].x * width + offsetX, stars[i].y * height + offsetY);
          context.lineTo(stars[j].x * width + offsetX, stars[j].y * height + offsetY);
          context.strokeStyle = `rgba(255, 215, 0, ${0.055 * (1 - distance / 120)})`;
          context.lineWidth = 0.6;
          context.stroke();
        }
      }
    }
  };

  const render = () => {
    context.clearRect(0, 0, width, height);

    const offsetX = reduceMotion ? 0 : (pointerX - 0.5) * 26;
    const offsetY = reduceMotion ? 0 : (pointerY - 0.5) * 26;

    drawConnections(offsetX, offsetY);

    stars.forEach((star) => {
      star.phase += reduceMotion ? 0 : star.speed;
      const alpha = Math.max(0.18, 0.42 + Math.sin(star.phase) * 0.38);
      const x = star.x * width + offsetX;
      const y = star.y * height + offsetY;

      context.beginPath();
      context.arc(x, y, star.size * 3.2, 0, Math.PI * 2);
      context.fillStyle = `rgba(255, 215, 0, ${alpha * 0.14})`;
      context.fill();

      context.beginPath();
      context.arc(x, y, star.size, 0, Math.PI * 2);
      context.fillStyle = `rgba(255, 255, 255, ${alpha})`;
      context.fill();
    });

    orbs.forEach((orb) => {
      if (!reduceMotion) {
        orb.x += orb.vx;
        orb.y += orb.vy;
      }

      if (orb.y < -0.12) {
        orb.y = 1.12;
        orb.x = Math.random();
      }
      if (orb.x < -0.12 || orb.x > 1.12) {
        orb.vx *= -1;
      }

      const x = orb.x * width + offsetX * 0.45;
      const y = orb.y * height + offsetY * 0.45;
      const gradient = context.createRadialGradient(x, y, 0, x, y, orb.radius);
      gradient.addColorStop(0, `hsla(${orb.hue}, 88%, 70%, ${orb.alpha})`);
      gradient.addColorStop(1, `hsla(${orb.hue}, 88%, 70%, 0)`);

      context.beginPath();
      context.arc(x, y, orb.radius, 0, Math.PI * 2);
      context.fillStyle = gradient;
      context.fill();
    });

    if (!reduceMotion) {
      animationFrame = requestAnimationFrame(render);
    }
  };

  resize();
  render();

  window.addEventListener('resize', resize, { passive: true });
  window.addEventListener(
    'resize',
    () => {
      if (reduceMotion) render();
    },
    { passive: true },
  );
  document.addEventListener(
    'pointermove',
    (event) => {
      pointerX = event.clientX / window.innerWidth;
      pointerY = event.clientY / window.innerHeight;
    },
    { passive: true },
  );

  document.addEventListener('visibilitychange', () => {
    if (reduceMotion) return;

    if (document.hidden) {
      cancelAnimationFrame(animationFrame);
    } else {
      animationFrame = requestAnimationFrame(render);
    }
  });
}

onReady(() => {
  initScrollReveal();
  initCountUp();
  initNavbarScrollState();
  initSmoothAnchors();
  initFormFeedback();
  initHeroCanvas();
});
