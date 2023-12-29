$(function () {
  window.addEventListener("message", function (event) {
    if (event.data.ui) {
      $(".wrapper").addClass("ui");
      $(".carspeed").html(Math.round(event.data.speed) + "");
      $(".fuel_perc").css("width", event.data.fuel + "%");
    } else {
      $(".wrapper").removeClass("ui");
    }
  });
});
