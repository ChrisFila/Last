// LEAK BY STARSDEV
// https://discord.gg/mzfPxEPzcb

$(document).ready(function () {
    window.addEventListener('message', function (event) {
        if (event.data.type === "staffinfo") {
            const staffdata = event.data
            if (staffdata.toggle) {
                $(".staffinfo").css("display", "block");
            } else {
                $(".staffinfo").css("display", "none");
            }
            // if (staffdata.players) {
                $("#si-player").empty() // Clears user-menu the list
                $("#si-player").append(`${staffdata.players}`);
            // } else if (staffdata.staffs) {
                $("#si-staffs").empty() // Clears user-menu the list
                $("#si-staffs").append(`${staffdata.staffs}`);
            // } else if (staffdata.staffsService) {

            // } else if (staffdata.reports) {
                $("#si-reports").empty() // Clears user-menu the list
                $("#si-reports").append(`${staffdata.reports}`);
            // } else if (staffdata.reportsWait) {
                $("#si-reports-wait").empty() // Clears user-menu the list
                $("#si-reports-wait").append(`(${staffdata.reportsWait} en attente)`);
            // }
        }
    });
});
