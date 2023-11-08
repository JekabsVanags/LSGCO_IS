$(document).ready(function() {
  $('#unitMemberTable').DataTable(
    {
      "paging":   false,
      "ordering": true,
      "info":     false,
      "searching": false,

      columnDefs: [{
        orderable: false,
        targets: "no-sort"
      }]
  
    }
  );
});