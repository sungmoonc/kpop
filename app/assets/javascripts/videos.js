function ajax_filters(e) {
  // Apply all the filters

  e.preventDefault();
  var source = $('#indv_video_template').html();
  var templatingFunction = Handlebars.compile(source);
  var context = {};
  debugger

  $.ajax({
    url: '/videos/filters',
    type: 'POST',
    data: $(this).serialize()
  }).done(function (response) {
    context.videos = response;
    $("ul.thumbnails").html("");
    $(".thumbnails").append(templatingFunction(context));
  })
}


$(document).on('page:change', function () {
  $("ul.thumbnails").on('click', ".hook--showmodal", function () {
    var url = $(this).attr("href");
    $("#iframe").attr('src', url);
  });

  $("#basicModal").on('hidden.bs.modal', function () {
    $("#iframe").attr('src', '');
  });

  //$('#year').slider();

  // Filters and sorting
  $("form[name=filters]").on('submit', function (e) {
    e.preventDefault();
    ajax_filters.call(this, e);
  });

});