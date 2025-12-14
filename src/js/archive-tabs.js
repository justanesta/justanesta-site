// Archive page tab switching functionality
document.addEventListener('DOMContentLoaded', () => {
  const tabs = document.querySelectorAll('.tabs li');
  const tabContents = document.querySelectorAll('.tab-content');

  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      const target = tab.dataset.tab;

      // Remove active class from all tabs
      tabs.forEach(t => t.classList.remove('is-active'));
      // Add active class to clicked tab
      tab.classList.add('is-active');

      // Hide all tab contents
      tabContents.forEach(content => {
        content.classList.add('tab-content-hidden');
      });
      // Show target tab content
      document.getElementById(target).classList.remove('tab-content-hidden');
    });
  });

  // Handle hash navigation
  if (window.location.hash) {
    const hash = window.location.hash.substring(1);
    if (hash === 'by-category' || hash.startsWith('category-')) {
      tabs[1].click();
      // If it's a specific category hash, scroll to it after a small delay
      if (hash.startsWith('category-')) {
        setTimeout(() => {
          const element = document.getElementById(hash);
          if (element) element.scrollIntoView();
        }, 100);
      }
    } else if (hash === 'by-tag' || hash.startsWith('tag-')) {
      tabs[2].click();
      // If it's a specific tag hash, scroll to it after a small delay
      if (hash.startsWith('tag-')) {
        setTimeout(() => {
          const element = document.getElementById(hash);
          if (element) element.scrollIntoView();
        }, 100);
      }
    } else if (hash === 'by-year' || hash.startsWith('year-')) {
      tabs[0].click();
      // If it's a specific year hash, scroll to it after a small delay
      if (hash.startsWith('year-')) {
        setTimeout(() => {
          const element = document.getElementById(hash);
          if (element) element.scrollIntoView();
        }, 100);
      }
    }
  }
});
