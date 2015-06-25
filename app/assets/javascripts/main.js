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
      $(".thumbnails").html("");
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

	$("#ipSearch").keyup(function() {
		$("#ipSearchHd").val($(this).val());
		form.trigger("change");
	});

	//_left_menu	
	// $("[name='interval-slider']").slider({});
	var ipHN = $("#ipHN").slider({}).data("slider");
	var ipCN = $("#ipCN").slider({}).data("slider");
	var ipEP = $("#ipEP").slider({}).data("slider");		
	var ipAR = $("#ipAR").slider({}).data("slider");
	$("[class='toggle-checkbox']").bootstrapSwitch();
	$("input[class='toggle-checkbox']").on("switchChange.bootstrapSwitch", function(event, state) {
		form.trigger("change");		
	});

	$(".dropdown-menu li a").click(function(){
	  $(this).parents(".dropdown").find('.selection').text($(this).text());
	  $(this).parents(".dropdown").find('.selection').val($(this).text());	  	  
	});	

	$("#ddSort li a").click(function() {
		$("#ipSort").val($(this).attr("value"));
		form.trigger("change");
	});

	$("#ddVType li a").click(function() {
		$("#ipVType").val($(this).attr("value"));
		form.trigger("change");
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
		var modal = $("#basicModal");
    	var url = $(this).attr("href");
    	modal.find(".iframe").attr('src', url);

    	var title = $(this).find(".dataWrapper").attr("data-title");
    	modal.find(".titleD").html(title);
  	});

  	$("#basicModal").on('hidden.bs.modal', function () {
    	$("#iframe").attr('src', '');
  	});

  	// Filters and sorting
	//apply all filters at once
	var form = $("form[name=filters]");

	form.on('change', function () {
		console.log("change");		

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
