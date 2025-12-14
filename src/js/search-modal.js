// Search modal logic
document.addEventListener('DOMContentLoaded', () => {
  const searchModal = document.getElementById('searchModal');
  const searchToggle = document.getElementById('searchToggle');
  const closeSearch = document.getElementById('closeSearch');
  const modalBackground = searchModal.querySelector('.modal-background');

  let pagefindInstance = null;

  // Function to open modal
  function openSearch() {
    searchModal.classList.add('is-active');
    document.body.classList.add('is-clipped'); // Prevent body scroll

    // Initialize Pagefind UI only once
    if (!pagefindInstance) {
      pagefindInstance = new PagefindUI({
        element: "#modalSearch",
        showSubResults: true,
        showImages: false,
        excerptLength: 30,
        resetStyles: false,
        bundlePath: "/pagefind/",
        autofocus: true
      });
    }

    // Focus the search input
    setTimeout(() => {
      const searchInput = document.querySelector('#modalSearch input[type="text"]');
      if (searchInput) {
        searchInput.focus();
      }
    }, 100);
  }

  // Function to close modal
  function closeSearchModal() {
    searchModal.classList.remove('is-active');
    document.body.classList.remove('is-clipped');
  }

  // Open search when button clicked
  if (searchToggle) {
    searchToggle.addEventListener('click', openSearch);
  }

  // Close search when close button clicked
  if (closeSearch) {
    closeSearch.addEventListener('click', closeSearchModal);
  }

  // Close search when clicking outside modal
  if (modalBackground) {
    modalBackground.addEventListener('click', closeSearchModal);
  }

  // Close search on Escape key
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && searchModal.classList.contains('is-active')) {
      closeSearchModal();
    }
  });
});