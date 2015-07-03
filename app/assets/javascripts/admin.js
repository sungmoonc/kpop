$(function(){
  $(".admin_toggle").on("click", function(e){

    console.log(e);

    var data = $(this).data();
    var object = $(this);
    $.ajax({
      url: '/admin/users/admin',
      type: 'POST',
      data: data
    }).done(function(response){
      console.log($(this));
      data["admin"]=response["admin"];
      object.text(response["admin"]);
    }).fail(function(response){
      alert("Unable to save the field:\n " + response.responseText);
    })
  })

});