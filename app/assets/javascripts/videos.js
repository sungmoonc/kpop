function ajax_filters(e) {
  // Apply all the filters

  e.preventDefault();
  var source = $('#indv_video_template').html();
  var templatingFunction = Handlebars.compile(source);
  var context = {};
  var requestData = {
    sort_by: field,
    sort_order: order
  }

  console.log(JSON.stringify(requestData));

  $.ajax({
    url: '/videos/filters',
    type: 'POST',
    data: $(this).serialize()
  }).done(function (response) {
    console.log(response);
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
    ajax_filters.call(this, e);
  });
});