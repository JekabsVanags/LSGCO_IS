function showAlert() {
  if (confirm("Vai esi pārliecināts?")) {
    return true
  } else {
    return false
  }
}

$(document).on('turbo:load', function () {
  $('.form-with-alert').submit((event) => {
    if (!showAlert()) {
      event.preventDefault() //Neizpildam pieprasījumu ja neapstiprina
    }
  })

  $('input').on('change invalid', function() {
    //Notīram noklusēto paziņojumu un aizstājam ar latvisko
    var textfield = $(this).get(0)
    
    textfield.setCustomValidity('')
    
    if (!textfield.validity.valid) {
      if($(this).hasClass("terms-and-services")){
        textfield.setCustomValidity('Šis ir vajadzīgs lai turpinātu lietot ')  
      }else{
        textfield.setCustomValidity('Lūdzu aizpildiet šo lauku')  
      }
    }
  });
});
