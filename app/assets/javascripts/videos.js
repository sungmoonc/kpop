$(document).ready(function(){
  $(".hook--showmodal").on('click', function(){
    var url= $(this).attr("href")
    $("#iframe").attr('src', url);
  });

  $("#basicModal").on('hidden.bs.modal', function(){
    $("#iframe").attr('src', '');
  });

  $('#year').slider();

  $(".upvoteasc").on('click', function(e) {
    e.preventDefault();

    $.ajax({
      url: '/sortby/upvotes/asc',
      type: 'GET',
    })
        .done(function (response) {
          $(".thumbnails").remove();
          //$(".thumbnails").append()

        })
        .fail(function (response) {
          console.log('fail')
        })
    });
});