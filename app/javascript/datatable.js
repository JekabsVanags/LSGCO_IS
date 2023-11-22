const pageLength = window.clientWidth > 1024 ? 13 : 5
$(document).ready(function() {
  $('#dataTable').DataTable(
    {
      "paging":   true,
      "ordering": true,
      "info":     false,
      "searching": false,
      "pageLength": pageLength,
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
  $('#dataTable2').DataTable(
    {
      "paging":   true,
      "ordering": true,
      "info":     false,
      "searching": false,
      "pageLength": pageLength,
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