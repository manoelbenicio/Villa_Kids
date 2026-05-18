/* ═══════════════════════════════════════════════════════════════
   VILLA PRIME v3 — Premium Interactive Engine
   Canvas 2D Particle System + Scroll Reveals + KPI Counters
   Parallax + Navbar Effects + Form Handling
   ═══════════════════════════════════════════════════════════════ */

// === SCROLL REVEAL (IntersectionObserver) ===
const io = new IntersectionObserver((entries) => {
  entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); } });
}, { threshold: 0.1 });
document.querySelectorAll('[data-animate]').forEach(el => io.observe(el));

// === KPI COUNTER ===
function countUp(el, target, suffix = '') {
  const dur = 2000, start = performance.now();
  (function tick(now) {
    const p = Math.min((now - start) / dur, 1);
    const v = Math.round(target * (1 - Math.pow(1 - p, 4)));
    el.textContent = v.toLocaleString() + suffix;
    if (p < 1) requestAnimationFrame(tick);
  })(start);
}
const kpiIO = new IntersectionObserver((entries) => {
  entries.forEach(e => {
    if (e.isIntersecting) {
      countUp(e.target, +e.target.dataset.count, e.target.dataset.suffix || '');
      kpiIO.unobserve(e.target);
    }
  });
}, { threshold: 0.5 });
document.querySelectorAll('[data-count]').forEach(el => kpiIO.observe(el));

// === NAVBAR SCROLL ===
const nav = document.getElementById('nav');
window.addEventListener('scroll', () => nav && nav.classList.toggle('scrolled', scrollY > 30), { passive: true });

// === SMOOTH SCROLL ===
document.querySelectorAll('a[href^="#"]').forEach(a => {
  a.addEventListener('click', e => {
    const t = document.querySelector(a.getAttribute('href'));
    if (t) { e.preventDefault(); t.scrollIntoView({ behavior: 'smooth' }); }
  });
});

// === FORM ===
const form = document.getElementById('contactForm');
if (form) form.addEventListener('submit', e => {
  e.preventDefault();
  const btn = form.querySelector('.btn');
  btn.textContent = '✓ Enviado!'; btn.style.background = '#10B981';
  setTimeout(() => { btn.textContent = 'Enviar Mensagem ✨'; btn.style.background = ''; }, 3000);
});

// === HERO CANVAS — Magical Particle System ===
const canvas = document.getElementById('heroCanvas');
if (canvas) {
  const ctx = canvas.getContext('2d');
  let W, H, mx = 0.5, my = 0.5;

  function resize() { W = canvas.width = canvas.parentElement.offsetWidth; H = canvas.height = canvas.parentElement.offsetHeight; }
  resize(); window.addEventListener('resize', resize);
  document.addEventListener('mousemove', e => { mx = e.clientX / innerWidth; my = e.clientY / innerHeight; });

  // Stars
  const stars = Array.from({ length: 100 }, () => ({
    x: Math.random(), y: Math.random(), s: 0.8 + Math.random() * 2.5,
    phase: Math.random() * 6.28, speed: 0.015 + Math.random() * 0.025
  }));

  // Particles (floating orbs)
  const orbs = Array.from({ length: 30 }, () => ({
    x: Math.random(), y: Math.random(), r: 4 + Math.random() * 12,
    vx: (Math.random() - 0.5) * 0.0004, vy: -0.0002 - Math.random() * 0.0005,
    hue: [280, 320, 50, 160, 45][Math.floor(Math.random() * 5)],
    alpha: 0.08 + Math.random() * 0.15
  }));

  // Connection lines between nearby stars
  function drawConnections() {
    const px = (mx - 0.5) * 30, py = (my - 0.5) * 30;
    for (let i = 0; i < stars.length; i++) {
      for (let j = i + 1; j < stars.length; j++) {
        const dx = (stars[i].x - stars[j].x) * W;
        const dy = (stars[i].y - stars[j].y) * H;
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < 120) {
          ctx.beginPath();
          ctx.moveTo(stars[i].x * W + px, stars[i].y * H + py);
          ctx.lineTo(stars[j].x * W + px, stars[j].y * H + py);
          ctx.strokeStyle = `rgba(255,215,0,${0.06 * (1 - dist / 120)})`;
          ctx.lineWidth = 0.5;
          ctx.stroke();
        }
      }
    }
  }

  function render() {
    ctx.clearRect(0, 0, W, H);
    const px = (mx - 0.5) * 25, py = (my - 0.5) * 25;

    // Connections
    drawConnections();

    // Stars with twinkle
    stars.forEach(s => {
      s.phase += s.speed;
      const alpha = 0.3 + Math.sin(s.phase) * 0.5;
      const x = s.x * W + px, y = s.y * H + py;
      // Glow
      ctx.beginPath(); ctx.arc(x, y, s.s * 3, 0, 6.28);
      ctx.fillStyle = `rgba(255,215,0,${alpha * 0.15})`; ctx.fill();
      // Core
      ctx.beginPath(); ctx.arc(x, y, s.s, 0, 6.28);
      ctx.fillStyle = `rgba(255,255,255,${alpha})`; ctx.fill();
    });

    // Floating orbs
    orbs.forEach(o => {
      o.x += o.vx; o.y += o.vy;
      if (o.y < -0.05) { o.y = 1.05; o.x = Math.random(); }
      if (o.x < -0.05 || o.x > 1.05) o.vx *= -1;
      const x = o.x * W + px * 0.4, y = o.y * H + py * 0.4;
      // Outer glow
      const g = ctx.createRadialGradient(x, y, 0, x, y, o.r);
      g.addColorStop(0, `hsla(${o.hue},80%,70%,${o.alpha})`);
      g.addColorStop(1, `hsla(${o.hue},80%,70%,0)`);
      ctx.beginPath(); ctx.arc(x, y, o.r, 0, 6.28);
      ctx.fillStyle = g; ctx.fill();
    });

    requestAnimationFrame(render);
  }
  render();
}
