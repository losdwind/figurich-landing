(function () {
  const storageKey = 'figurich-language';

  function safeReadStoredLanguage() {
    try {
      return window.localStorage.getItem(storageKey);
    } catch (error) {
      return null;
    }
  }

  function safeStoreLanguage(language) {
    try {
      window.localStorage.setItem(storageKey, language);
    } catch (error) {
      return;
    }
  }

  function resolveInitialLanguage() {
    const stored = safeReadStoredLanguage();
    if (stored === 'zh' || stored === 'en') {
      return stored;
    }

    const browserLanguage = (navigator.language || navigator.userLanguage || '').toLowerCase();
    return browserLanguage.startsWith('zh') ? 'zh' : 'en';
  }

  function applyLanguage(language) {
    document.body.classList.remove('mode-zh', 'mode-en');
    document.body.classList.add(language === 'zh' ? 'mode-zh' : 'mode-en');
    document.documentElement.lang = language === 'zh' ? 'zh-CN' : 'en';
    document.body.dataset.language = language;
    safeStoreLanguage(language);
  }

  function toggleLanguage() {
    const nextLanguage = document.body.classList.contains('mode-zh') ? 'en' : 'zh';
    applyLanguage(nextLanguage);
  }

  function setActiveRoute() {
    const currentPath = window.location.pathname.replace(/index\.html$/, '');

    document.querySelectorAll('[data-route]').forEach((link) => {
      const route = link.getAttribute('data-route');
      const isHomeRoute = route === '/' && currentPath === '/';
      const isNestedRoute = route !== '/' && currentPath.startsWith(route);

      if (isHomeRoute || isNestedRoute) {
        link.classList.add('is-active');
      }
    });
  }

  function bindMobileMenu() {
    const toggle = document.querySelector('[data-menu-toggle]');
    const menu = document.querySelector('[data-mobile-menu]');

    if (!toggle || !menu) {
      return;
    }

    toggle.addEventListener('click', () => {
      const isOpen = menu.classList.toggle('open');
      toggle.setAttribute('aria-expanded', String(isOpen));
    });

    document.querySelectorAll('[data-nav-close]').forEach((link) => {
      link.addEventListener('click', () => {
        menu.classList.remove('open');
        toggle.setAttribute('aria-expanded', 'false');
      });
    });
  }

  document.addEventListener('DOMContentLoaded', () => {
    applyLanguage(resolveInitialLanguage());

    const languageToggle = document.querySelector('[data-language-toggle]');
    if (languageToggle) {
      languageToggle.addEventListener('click', toggleLanguage);
    }

    bindMobileMenu();
    setActiveRoute();
  });
})();
