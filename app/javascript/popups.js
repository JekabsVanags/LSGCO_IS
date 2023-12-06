$(document).ready(function () {
  $('#popup').ready(function() {
    setTimeout(() => {
      $('#popup').hide('drop', () => {
        $(this).remove();
      });
    }, 3500);
  })
  }
);