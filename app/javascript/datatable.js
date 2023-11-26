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

$(document).on('turbo:load', function () {
  var table = initializeDataTable('#dataTable');
  initializeDataTable('#dataTable2');

  $('#searchField').on( 'keyup', function () {
      table.search( this.value ).draw();
  } );
});
