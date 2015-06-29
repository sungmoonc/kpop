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
    context.videos = response;
    if (form.find("#page").val() == "1") {
      $("ul.thumbnails").html("");
    }
    $(".thumbnails").append(templatingFunction(context));

    $(context.videos).each(
        function(i, v){
          if (v.editable) {
            $("input[value="+ v["id"] + "]").parent().find("select[name=category]").val(v["category"])
          }
        }
    );

    $(".add-collection").on("change", function(e){
      var collection_id = $(this).val();
      if (collection_id == "new"){
        var collection_name = prompt('How would you name the new collection?');
        alert(collection_name);
        return; // todo: call ajax
      }

      $.ajax({
        url: '/videos/add_collection',
        type: 'POST',
        data: {
          "collection_id": collection_id,
          "video_id": $(this).parent().data()["video_id"]
        }
      }).fail(function(response){
        alert("Unable to save the field:\n " + response.responseText);
      })

    });
  })
}

function ajax_save_edit() {
  $.ajax({
    url: '/videos/save_kpop_fields',
    type: 'POST',
    data: $(this).serialize()
  }).fail(function(response){
    alert("Unable to save the field:\n " + response.responseText);
  })
}

$(document).on('page:change', function () {
  $("ul.thumbnails").on('click', ".hook--showmodal", function () {
    var url = $(this).attr("href");
    $("#iframe").attr('src', url);

    var popup_details = $(this).parent().find(".popup");
    var htmls = $.map(popup_details, function(val, i) {
      return "<div class='popup-desc'>" + val.innerHTML + "</div>";
    });

    $("#popup_details").html(htmls.join(""));
  });

  $("#basicModal").on('hidden.bs.modal', function () {
    $("#iframe").attr('src', '');
  });

  // Filters and sorting
  //apply all filters at once
  var form = $("form[name=filters]");

  form.on('change', function () {
    form.find("#page").val(1);
    ajax_filters();
  });

  form.on('keyup', function () {
    form.find("#page").val(1);
    ajax_filters();
  });


  // Edit forms
  var main_container = $('.thumbnails');

  main_container.on('change', "form[name=video_edit]", function(){
    ajax_save_edit.call(this);
  });

  main_container.on('change', "form[name=video_edit]", function(){
    ajax_save_edit.call(this);
  });


  // Infinite scroll
  if ($('#infinite-scrolling').size() > 0) {
    $(window).on('scroll', function(e) {
      if ($(window).scrollTop() > $(document).height() - $(window).height() - 20)  {
        form.find("#page").val(parseInt(form.find("#page").val()) + 1);
        ajax_filters();
      }
    })
  }

  // Initial load
  ajax_filters();
});