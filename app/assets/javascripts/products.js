document.addEventListener('DOMContentLoaded', function() {
  const fullSizeImage = document.querySelector('.full-size-image img');
  const thumbnails = document.querySelectorAll('.thumbnail img');

  thumbnails.forEach(thumbnail => {
    thumbnail.addEventListener('click', function() {
      fullSizeImage.src = thumbnail.src.replace(/100x100/, '800x600');
    });
  });
});
