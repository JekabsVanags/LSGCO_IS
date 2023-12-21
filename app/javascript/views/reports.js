function showField(show, hide) {
  $(show).show()
  hide.forEach((element) => {
    $(element).hide()
  })
}

$(document).on('turbo:load', function () {
  $('#user-report-show').click(() => {
    showField('#user-report', ['#event-report', '#fee-report'])
  })

  $('#event-report-show').click(() => {
    showField('#event-report', ['#user-report', '#fee-report'])
  })

  $('#fee-report-show').click(() => {
    showField('#fee-report', ['#user-report', '#event-report'])
  })
});
