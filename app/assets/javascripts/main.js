function main_ajax_filters() {
  // Apply all the filters
  var source = $("#video_card_template").html();  
  var templatingFunction = Handlebars.compile(source);
  var context = {};

  var form = $("form[name=filters]");

  $.ajax({
    url: '/videos/filters_test',
    type: 'POST',
    data: form.serialize()
  }).done(function (response) {
    context.videos = response;
    if (form.find("#page").val() == "1") {
      $("#cards.thumbnails").html("");
    }

    $(".thumbnails").append(templatingFunction(context));

    $(".btn-group .btnView1").click();
  });
}

$(document).on('page:change', function () {	
	var cards = $("#cards");

	cards.imagesLoaded(function() {
		cards.masonry({
			itemSelector: '.box',
			isFitWidth: true
		});		
	});

	//_left_menu
	$("[name='interval-slider']").slider({});
	$("[name='toggle-checkbox']").bootstrapSwitch();
	$(".dropdown-menu li a").click(function(){
	  $(this).parents(".dropdown").find('.selection').text($(this).text());
	  $(this).parents(".dropdown").find('.selection').val($(this).text());
	});


	//_view_menu_box
	$(".btn-group .btnView1").click(function() {
		$(".cards .box").width("320px");
		$("#cards").masonry('reload');
	});

	$(".btn-group .btnView2").click(function() {
		$(".cards .box").width("500px");
		$("#cards").masonry('reload');
	});

	$(".btn-group .btnView3").click(function() {
		
	});

	//cards	
	$(".cards").on('mouseover', ".hook--showmodal", function() {
		$(this).find(".overlay").show();
	});

	$(".cards").on('mouseout', ".hook--showmodal", function() {		
		$(this).find(".overlay").hide();
	});

	$(".cards").on('click', ".hook--showmodal", function () {
    	var url = $(this).attr("href");
    	$("#iframe").attr('src', url);
  	});

  	$("#basicModal").on('hidden.bs.modal', function () {
    	$("#iframe").attr('src', '');
  	});

  	// Filters and sorting
	//apply all filters at once
	var form = $("form[name=filters]");

	form.on('change', function () {
    	form.find("#page").val(1);
    	main_ajax_filters();
  	});
  	form.on('keyup', function () {
    	form.find("#page").val(1);
    	main_ajax_filters();
  	});

  	// Infinite scroll
  	if ($('#infinite-scrolling').size() > 0) {
    	$(window).on('scroll', function(e) {
	      	if ($(window).scrollTop() > $(document).height() - $(window).height() - 20)  {
	        	form.find("#page").val(parseInt(form.find("#page").val()) + 1);
	        	main_ajax_filters();
	      	}
    	});
  	}

  	// Initial load
  	main_ajax_filters();
});
