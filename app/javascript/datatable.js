function initializeDataTable(tableSelector) {
  const pageLength = window.clientWidth > 1024 ? 13 : 5;

  $(tableSelector).DataTable({
    paging: true,
    ordering: true,
    info: false,
    searching: false,
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
  initializeDataTable('#dataTable');
  initializeDataTable('#dataTable2');
});
