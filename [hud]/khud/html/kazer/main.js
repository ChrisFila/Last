var rgbStart = [139, 195, 74], rgbEnd = [183, 28, 28];
function setValue(t, a) {
  $("#" + t + " span").html(a);
}
function updateStatus(t) {
  var a = t[0], e = t[1], n = t[2];
  $("#hunger .bg").css("height", a.percent + "%"), $("#water .bg").css("height", e.percent + "%"), $("#drunk .bg").css("height", n.percent + "%"), n.percent, $("#drunk").show();
}
function setTalking(t) {
  t ? $("#voice").css("border", "3px solid #ff0000") : $("#voice").css("border", "none");
}
function colourGradient(t, a, e) {
  var n = (2 * t - 1 + 1) / 2, s = 1 - n;
  return [parseInt(a[0] * n + e[0] * s), parseInt(a[1] * n + e[1] * s), parseInt(a[2] * n + e[2] * s)];
}
$(function () {
  window.addEventListener("message", function (t) {
    "setValue" == t.data.action ? ("job" == t.data.key && setJobIcon(t.data.icon), setValue(t.data.key, t.data.value)) : "updateStatus" == t.data.action ? updateStatus(t.data.status) : "setTalking" == t.data.action ? setTalking(t.data.value) : "toggle" == t.data.action && (t.data.show ? $("#ui").show() : $("#ui").hide());
  });
});
