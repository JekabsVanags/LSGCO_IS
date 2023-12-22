function initializeDataTable(tableSelector) {
  const pageLength = window.innerWidth > 1024 ? 13 : 5;

  return $(tableSelector).DataTable({
    dom: 'lrtip',
    paging: true,
    ordering: true,
    info: false,
    searching: true,
    pageLength: pageLength,
    bLengthChange: false,
    pagingType: "full",

    fnDrawCallback: function (oSettings) {
      const paginateElement = $(oSettings.nTableWrapper).find('.dataTables_paginate');
      oSettings._iDisplayLength > oSettings.fnRecordsDisplay() ? paginateElement.hide() : paginateElement.show();
    },

    columnDefs: [{
      orderable: false,
      targets: "no-sort"
    }],

    language: {
      emptyTable: "Nav datu"
    }
  });
}

document.addEventListener('turbo:before-cache', function () {
  $('#dataTable').DataTable().destroy();
  $('#dataTable2').DataTable().destroy();
  $('#dataTable3').DataTable().destroy();
  $('#dataTable4').DataTable().destroy();
});

$(document).on('turbo:load', function () {

  const table1 = initializeDataTable('#dataTable')
  const table2 = initializeDataTable('#dataTable2')
  const table3 = initializeDataTable('#dataTable3')
  const table4 = initializeDataTable('#dataTable4')
  var tables = [table1, table2, table3, table4]

  $('#searchField').on( 'keyup', function () {
      tables.forEach((table)=>{
        table.search( this.value ).draw();
      })
  } );
});
