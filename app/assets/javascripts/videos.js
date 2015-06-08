function ajax_filters() {
  // Apply all the filters
  var source = $('#indv_video_template').html();
  var templatingFunction = Handlebars.compile(source);
  var context = {};

  var form = $("form[name=filters]");

  $.ajax({
    url: '/videos/filters',
    type: 'POST',
    data: form.serialize()
  }).done(function (response) {
    console.log(response);
    context.videos = response;
    if (form.find("#page").val() == "1") {
      $("ul.thumbnails").html("");
    }
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

  // Filters and sorting
  //apply all filters at once
  var form = $("form[name=filters]");

  form.on('submit', function (e) {
    e.preventDefault();
    ajax_filters.call(this);
  });

  form.on('change', function () {
    form.find("#page").val(1);
    ajax_filters.call(this);
  });

  // Infinite scroll
  if ($('#infinite-scrolling').size() > 0) {
    $(window).on('scroll', function(e) {
      if ($(window).scrollTop() > $(document).height() - $(window).height() - 20)  {
        form.find("#page").val(parseInt(form.find("#page").val()) + 1);
        form.submit();
      }
    })
  }

  // Initial load
  form.submit();

});