// Shared dark/light mode toggle functionality for Tiation projects
document.addEventListener('DOMContentLoaded', function() {
    // Dark mode toggle functionality
    const themeToggle = document.getElementById('theme-toggle');
    const themeIcon = document.getElementById('theme-icon');
    const themeToggleMobile = document.getElementById('theme-toggle-mobile');
    const themeIconMobile = document.getElementById('theme-icon-mobile');
    const html = document.documentElement;
    
    // Check for saved theme preference or default to light mode
    const savedTheme = localStorage.getItem('theme') || 'light';
    
    // Apply saved theme
    if (savedTheme === 'dark') {
        html.classList.add('dark');
        if (themeIcon) {
            themeIcon.classList.remove('fa-moon');
            themeIcon.classList.add('fa-sun');
        }
        if (themeIconMobile) {
            themeIconMobile.classList.remove('fa-moon');
            themeIconMobile.classList.add('fa-sun');
        }
    }
    
    // Toggle theme function
    function toggleTheme() {
        html.classList.toggle('dark');
        
        if (html.classList.contains('dark')) {
            if (themeIcon) {
                themeIcon.classList.remove('fa-moon');
                themeIcon.classList.add('fa-sun');
            }
            if (themeIconMobile) {
                themeIconMobile.classList.remove('fa-moon');
                themeIconMobile.classList.add('fa-sun');
            }
            localStorage.setItem('theme', 'dark');
        } else {
            if (themeIcon) {
                themeIcon.classList.remove('fa-sun');
                themeIcon.classList.add('fa-moon');
            }
            if (themeIconMobile) {
                themeIconMobile.classList.remove('fa-sun');
                themeIconMobile.classList.add('fa-moon');
            }
            localStorage.setItem('theme', 'light');
        }
    }
    
    // Add event listeners
    if (themeToggle) {
        themeToggle.addEventListener('click', toggleTheme);
    }
    if (themeToggleMobile) {
        themeToggleMobile.addEventListener('click', toggleTheme);
    }

    // Smooth scroll for navigation links
    const navLinks = document.querySelectorAll('a[href^="#"]');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            if (targetSection) {
                targetSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });

    // Add active class to navigation items on scroll
    const sections = document.querySelectorAll('section[id]');
    const navItems = document.querySelectorAll('nav a[href^="#"]');

    function updateActiveNav() {
        const scrollY = window.pageYOffset;
        
        sections.forEach(section => {
            const sectionHeight = section.offsetHeight;
            const sectionTop = section.offsetTop - 100;
            const sectionId = section.getAttribute('id');
            
            if (scrollY > sectionTop && scrollY <= sectionTop + sectionHeight) {
                navItems.forEach(item => {
                    item.classList.remove('text-indigo-600');
                    if (item.getAttribute('href') === '#' + sectionId) {
                        item.classList.add('text-indigo-600');
                    }
                });
            }
        });
    }

    window.addEventListener('scroll', updateActiveNav);

    // Console welcome message
    console.log('%c Welcome to Tiation! 🚀', 'font-size: 20px; color: #4f46e5; font-weight: bold;');
    console.log('%c People aren\'t broken. Fix the systems.', 'font-size: 14px; color: #6366f1;');
    console.log('%c Join us: https://github.com/tiation', 'font-size: 12px; color: #8b5cf6;');
});
