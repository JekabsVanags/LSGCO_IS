function showDropdown() {
  $('#dropdown').toggle(500);
}

$(document).ready(function() {
  $('#dropdown-button').click(() => showDropdown())
})