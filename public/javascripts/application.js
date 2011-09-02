$(function() {
  $("#credit_card input, #credit_card select").attr("disabled", false);

  $("form:has(#credit_card)").submit(function() {
    var form = this;
    $("#payment_submit").attr("disabled", true);
    $("#credit_card input, #credit_card select").attr("name", "");

    if (!$("#credit_card").is(":visible")) {
      $("#credit_card input, #credit_card select").attr("disabled", true);
      return true;
    }
    
    var card = {
      number:   $("#credit_card_number").val(),
      expMonth: $("#_expiry_date_2i").val(),
      expYear:  $("#_expiry_date_1i").val(),
      cvc:      $("#cvv").val()
    };

    Stripe.createToken(card, function(status, response) {
      if (status === 200) {
        $("#payment_last_4_digits").val(response.card.last4);
        $("#payment_stripe_token").val(response.id);
        form.submit();
      } else {
        $("#stripe_error_message").text(response.error.message);
        $("#credit_card_errors").show();
        $("#payment_submit").attr("disabled", false);
      }
    });

    return false;
  });
  
  $("#change_card a").click(function() {
    $("#change_card").hide();
    $("#credit_card").show();
    $("#credit_card_number").focus();
    return false;
  });

});