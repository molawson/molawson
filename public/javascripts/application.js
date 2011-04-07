$(function() {
  $("#post_title").bind("keyup", function() {
    var slug = "&nbsp;";
    var input_value = $(this).val();
    if (input_value) {
      slug = $(this).val().toLowerCase().replace(/\s/g , "-");      
    }
    // $("#post_slug_viewer").html(slug);
    $("#post_slug").val(slug);
  });
});