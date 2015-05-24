function call_sort_by(e, field, order) {
  e.preventDefault();
  var source = $('#indv_video_template').html();
  var templatingFunction = Handlebars.compile(source);
  var context = {};

  $.ajax({
    url: '/sortby/'+ field + '/' + order,
    type: 'GET'
  }).done(function (response) {
    context.videos = response;
    $("ul.thumbnails").html("");
    $(".thumbnails").append(templatingFunction(context));
  })
}
$(document).on('page:change', function () {
  $(".hook--showmodal").on('click', function () {
    var url = $(this).attr("href");
    console.log("choki==========")
    console.log(url)
    $("#iframe").attr('src', url);
  });

  $("#basicModal").on('hidden.bs.modal', function () {
    $("#iframe").attr('src', '');
  });

  $('#year').slider();

  $(".upvoteasc").on('click', function (e) {
    call_sort_by(e, "upvotes", "asc");
  });

  $(".upvotedesc").on('click', function (e) {
    call_sort_by(e, "upvotes", "desc");
  });

  $(".youtubeasc").on('click', function (e) {
    call_sort_by(e, "youtube_views", "asc");
  });

  $(".youtubedesc").on('click', function (e) {
    call_sort_by(e, "youtube_views", "desc");
  });

  $(".uploadasc").on('click', function (e) {
    call_sort_by(e, "upload_date", "asc");
  });

  $(".uploaddesc").on('click', function (e) {
    call_sort_by(e, "upload_date", "desc");
  });
});