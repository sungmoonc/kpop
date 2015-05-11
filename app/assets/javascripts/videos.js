$(document).ready(function(){
  $(".hook--showmodal").on('click', function(){
    var url= $(this).attr("href")
    $("#iframe").attr('src', url);
  })

  $("#basicModal").on('hidden.bs.modal', function(){
    $("#iframe").attr('src', '');
  })

  $('#year').slider()
});