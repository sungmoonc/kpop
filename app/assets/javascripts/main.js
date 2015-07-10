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
    context.videos = response.videos;

    $(".header_panel .numResults").html(response.count + " results");

    if (form.find("#page").val() == "1") {    
      $(".thumbnails").html("");
    }

    var cards = $("#cards");

	cards.imagesLoaded(function() {
		cards.masonry({
			itemSelector: '.box',
			isFitWidth: true			
		});		
	});

    var newThumbs = templatingFunction(context);
    $(".thumbnails").append(newThumbs);    

    $(".btn-group .btnView1").click();
  });
}

$(document).on('page:change', function () {		
	
	$("#ipSearch").keyup(function() {
		$("#ipSearchHd").val($(this).val());
		form.trigger("changeT");
	});

	//_left_menu	
	// $("[name='interval-slider']").slider({});
	var ipHN = $("#ipHN").slider({}).data("slider");	
	var ipCN = $("#ipCN").slider({}).data("slider");
	var ipEP = $("#ipEP").slider({}).data("slider");		
	var ipAR = $("#ipAR").slider({}).data("slider");	
	$(".inter_slider").on('slideStop', function(newV){
		form.trigger("changeT");
	});	

	$("[class='toggle-checkbox']").bootstrapSwitch();
	$("input[class='toggle-checkbox']").on("switchChange.bootstrapSwitch", function(event, state) {
		form.trigger("changeT");		
	});

	$(".dropdown-menu li a").click(function(){
	  $(this).parents(".dropdown").find('.selection').text($(this).text());
	  $(this).parents(".dropdown").find('.selection').val($(this).text());	  	  
	});	

	$("#ddSort li a").click(function() {
		$("#ipSort").val($(this).attr("value"));
		form.trigger("changeT");
	});

	$("#ddVType li a").click(function() {
		$("#ipVType").val($(this).attr("value"));
		form.trigger("changeT");
	});


	//_view_menu_box
	$(".btn-group .btnView1").click(function() {
		$(".cards .box").width("490px");
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
		var modal = $("#basicModal");
    	var url = $(this).attr("href");
    	modal.find(".iframe").attr('src', url);

    	var dataWrapper = $(this).find(".dataWrapper");    	
    	modal.find(".titleD").html(dataWrapper.attr("data-title"));    	
    	modal.find(".youtube_user_id").html(dataWrapper.attr("data-youtube-userid"));
    	modal.find(".category").html(dataWrapper.attr("data-category"));
    	modal.find(".upload_date").html(dataWrapper.attr("data-uploaded"));
    	modal.find(".views").html(dataWrapper.attr("data-views"));
    	modal.find(".upvotes").html(dataWrapper.attr("data-upvotes"));
    	modal.find(".downvotes").html(dataWrapper.attr("data-downvotes"));
    	modal.find(".approval").html(dataWrapper.attr("data-approval") + " Approval");
    	modal.find(".hotness").html(dataWrapper.attr("data-hotness"));
    	modal.find(".cheesiness").html(dataWrapper.attr("data-cheese"));    	
  	});

  	$("#basicModal").on('hidden.bs.modal', function () {
    	$("#iframe").attr('src', '');
  	});

  	// Filters and sorting
	//apply all filters at once
	var form = $("form[name=filters]");

	form.on('changeT', function () {
		console.log("changeT");		

		var arrHn = ipHN.getValue();
		$("#hnMin").val(arrHn[0]);
		$("#hnMax").val(arrHn[1]);

		var arrCn = ipCN.getValue();
		$("#cnMin").val(arrCn[0]);
		$("#cnMax").val(arrCn[1]);

		var arrEp = ipEP.getValue();		
		$("#epMin").val(arrEp[0]);
		$("#epMax").val(arrEp[1]);

		var arrAr = ipAR.getValue();
		$("#arMin").val(arrAr[0]);
		$("#arMax").val(arrAr[1]);

    	form.find("#page").val(1);
    	main_ajax_filters();
  	});
  	// form.on('keyup', function () {
   //  	form.find("#page").val(1);
   //  	main_ajax_filters();
  	// });

  	// Infinite scroll
  	if ($('#infinite-scrolling').size() > 0) {
    	$(window).on('scroll', function(e) {
	      	if ($(window).scrollTop() > $(document).height() - $(window).height() - 20)  {
	        	form.find("#page").val(parseInt(form.find("#page").val()) + 1);
	        	main_ajax_filters();	        	
	      	}
	      	$("#sidebar").css("height", $(document).height());
    	});
  	}

  	// Initial load
  	main_ajax_filters();
});
