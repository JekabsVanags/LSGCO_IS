function togglePasswordEddit() {
  $('#password_reset_form').toggle(500);
  $('#data_reset_form').toggle(500);
  
}

$(document).ready(function() {
  $('.form_toggle').click(() => togglePasswordEddit())
})