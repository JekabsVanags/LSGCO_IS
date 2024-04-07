$(document).ready(function () {
  $('#multiSelect').select2({
    closeOnSelect: false,
    language: {
      noResults: function () {
        return "Nav biedru bez solījuma";
      }
    }
  });
});