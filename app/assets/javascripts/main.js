$(document).ready(function() {
	var cards = $("#cards");
	cards.imagesLoaded(function() {
		cards.masonry({
			itemSelector: '.box',
			isFitWidth: true
		});
	});
});

$(document).on('page:change', function () {
	//_left_menu
	$("[name='interval-slider']").slider({});
	$("[name='toggle-checkbox']").bootstrapSwitch();

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

});

