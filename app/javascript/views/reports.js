function showField(show, hide) {
  $(show).show()
  hide.forEach((element) => {
    $(element).hide()
  })
}

function colorActiveButton(active, inactive) {
  $(active).addClass('text-scout-red').removeClass('text-scout-blue');
  inactive.forEach((element) => {
    $(element).addClass('text-scout-blue').removeClass('text-scout-red');
  })
}

$(document).on('turbo:load', function () {
  $('#user-report-show').click(() => {
    showField('#user-report', ['#event-report', '#fee-report', '#position-report'])
    colorActiveButton('#user-report-show', ['#event-report-show', '#fee-report-show', '#position-report-show'])
  })

  $('#event-report-show').click(() => {
    showField('#event-report', ['#user-report', '#fee-report', '#position-report'])
    colorActiveButton('#event-report-show', ['#user-report-show', '#fee-report-show', '#position-report-show'])
  })

  $('#fee-report-show').click(() => {
    showField('#fee-report', ['#user-report', '#event-report', '#position-report'])
    colorActiveButton('#fee-report-show', ['#event-report-show', '#user-report-show', '#position-report-show'])
  })

  $('#position-report-show').click(() => {
    showField('#position-report', ['#user-report', '#event-report', '#fee-report'])
    colorActiveButton('#position-report-show', ['#event-report-show', '#user-report-show', '#fee-report-show'])
  })
});
