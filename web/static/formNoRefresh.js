console.log("Hello world");
$(function() {
  console.log("Hello 2");
  $('.error').hide();
  $("#submitButton").click(function() {
    // validate and process form here
    console.log("Hello 3");
    $('.error').hide();
    var kMean = $("#sel1").val();
    var kSD = $("#sel2").val();
    var submit = $("#submitButton");
    submit.prop("disabled", true);
    //alert (dataString);return false;
    $.ajax({
      type: "POST",
      url: "/submit",
      data: $("#SimulationForm").serialize(),
      success: function(data) {
        submit.prop("disabled", false);
        console.log(data);
        plotData(data);
      }
    });
    return false;

  });
});
