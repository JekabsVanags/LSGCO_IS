function showDropdown() {
  const toggleValue = !$('#dropdown').attr('hidden')
  $('#dropdown').toggle(500);
}

$(document).ready(function() {
  $('#dropdown-button').click(() => showDropdown())
})