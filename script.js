document.addEventListener('DOMContentLoaded', () => {
    // 1. Initialize Ambient Particles
    initParticles();
    
    // 2. Initialize Clock
    updateClock();
    setInterval(updateClock, 60000); // Update every minute
    
    // 3. Set Current Dates in App
    setAppDates();
    
    // 4. Initialize Scroll Reveal (Intersection Observer)
    initScrollReveal();
    
    // 5. Hero fade in
    setTimeout(() => {
        const hero = document.querySelector('.hero');
        if(hero) hero.classList.remove('hidden-on-load');
    }, 100);

    // 6. Smooth scroll for CTA
    const ctaBtn = document.querySelector('.cta a');
    if(ctaBtn) {
        ctaBtn.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if(target) {
                target.scrollIntoView({ behavior: 'smooth' });
            }
        });
    }

    // 7. Interactive cards subtle glow effect based on mouse position
    initCardGlow();
});

/* --- Functions --- */

function initParticles() {
    const container = document.getElementById('particles');
    if (!container) return;
    
    const particleCount = 15;
    
    for (let i = 0; i < particleCount; i++) {
        const particle = document.createElement('div');
        particle.className = 'particle';
        
        const size = Math.random() * 4 + 1;
        const x = Math.random() * 100;
        const y = Math.random() * 100;
        const delay = Math.random() * 20;
        const duration = 15 + Math.random() * 15;
        
        particle.style.width = size + 'px';
        particle.style.height = size + 'px';
        particle.style.left = x + '%';
        particle.style.top = y + '%';
        
        // Use animation programmatically or let CSS handle a generic float
        // For smoother effect, we add a simple custom animation via JS inline styles
        particle.animate([
            { transform: 'translate(0,0) scale(1)', opacity: Math.random() * 0.2 + 0.1 },
            { transform: `translate(${Math.random() * 50 - 25}px, ${Math.random() * -50 - 20}px) scale(1.5)`, opacity: Math.random() * 0.4 + 0.2 },
            { transform: 'translate(0,0) scale(1)', opacity: Math.random() * 0.2 + 0.1 }
        ], {
            duration: duration * 1000,
            delay: delay * 1000,
            iterations: Infinity,
            easing: 'ease-in-out'
        });
        
        container.appendChild(particle);
    }
}

function updateClock() {
    const now = new Date();
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const clock = document.getElementById('clock');
    if (clock) clock.textContent = hours + ':' + minutes;
}

function setAppDates() {
    const now = new Date();
    const options = { weekday: 'long', day: 'numeric', month: 'long' };
    const dateString = now.toLocaleDateString('id-ID', options);
    
    document.getElementById('current-date').textContent = dateString;
    document.getElementById('current-date-2').textContent = dateString;
}

function initScrollReveal() {
    const revealElements = document.querySelectorAll('.reveal');
    
    const observerOptions = {
        root: null,
        rootMargin: '0px',
        threshold: 0.15
    };
    
    const observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                // Optional: Stop observing once revealed
                // observer.unobserve(entry.target);
            }
        });
    }, observerOptions);
    
    revealElements.forEach(el => observer.observe(el));
}

// App Tab Switching
window.switchTab = function(tabId) {
    // Hide all tabs
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // Show selected tab
    document.getElementById('tab-' + tabId).classList.add('active');
    
    // Update nav items
    document.querySelectorAll('.nav-item').forEach((item, index) => {
        item.classList.remove('active');
        if (
            (tabId === 'home' && index === 0) ||
            (tabId === 'rhythm' && index === 1) ||
            (tabId === 'settings' && index === 2)
        ) {
            item.classList.add('active');
        }
    });
};

// Toggle switches in settings
window.toggleSwitch = function(element) {
    const toggle = element.querySelector('.toggle-switch');
    if (toggle) {
        toggle.classList.toggle('active');
    }
};

// Mouse follow glow effect on interactable cards
function initCardGlow() {
    const cards = document.querySelectorAll('.interactable, .bento-card');
    
    cards.forEach(card => {
        card.addEventListener('mousemove', (e) => {
            const rect = card.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            
            const glow = card.querySelector('.card-glow');
            if (glow) {
                glow.style.background = `radial-gradient(circle at ${x}px ${y}px, rgba(229, 193, 141, 0.08) 0%, transparent 60%)`;
            }
        });
        
        card.addEventListener('mouseleave', () => {
            const glow = card.querySelector('.card-glow');
            if (glow) {
                glow.style.background = `radial-gradient(circle at center, rgba(255,255,255,0.05) 0%, transparent 70%)`;
            }
        });
    });
}
