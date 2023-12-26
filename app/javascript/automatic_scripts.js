function showDropdown() {
  $('#dropdown').toggle(500);
}

function hidePopup(){
  setTimeout(() => {
    $('#popup').hide('drop', () => {
      $(this).remove();
    });
  }, 3500);
}

$(document).on('turbo:load', function() {
  $('#dropdown-button').click(() => showDropdown())

  $('#popup').ready(() => hidePopup())
})