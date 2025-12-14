// Reading progress bar functionality
window.addEventListener('scroll', () => {
  const progressBar = document.querySelector('.reading-progress-bar');
  if (!progressBar) return;

  const windowHeight = window.innerHeight;
  const documentHeight = document.documentElement.scrollHeight;
  const scrollTop = window.scrollY || document.documentElement.scrollTop;
  const scrollPercent = (scrollTop / (documentHeight - windowHeight)) * 100;

  progressBar.style.width = scrollPercent + '%';
});
