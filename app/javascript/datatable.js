$(document).ready(function() {
  $('#dataTable').DataTable(
    {
      "paging":   true,
      "ordering": true,
      "info":     false,
      "searching": false,
      "pageLength": 13,
      "bLengthChange" : false,
      "pagingType": "full",

      "fnDrawCallback": function(oSettings) {
        if (oSettings._iDisplayLength > oSettings.fnRecordsDisplay()) {
            $(oSettings.nTableWrapper).find('.dataTables_paginate').hide();
        } else {
             $(oSettings.nTableWrapper).find('.dataTables_paginate').show();
        }},

      columnDefs: [{
        orderable: false,
        targets: "no-sort"
      }],

      language: {
        emptyTable: "Nav datu"
      }
    }
  );
});