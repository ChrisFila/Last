/*
 * Copyright (c) 2023 ADN's. All right reserved.
 */


window.addEventListener("message", function(event) {
    var action = event.data.action;
    var data = event.data.data;
    switch (action) {
        case "Notification":
            var exist = NotificationExists(format(data.body));
            if (!exist) {
                Notification(data.title, data.subtitle, data.icon, data.body, data.duration, data.location);
            } else {
                this.clearTimeout(exist.dataset.to1);
                this.clearTimeout(exist.dataset.to2);
                this.clearTimeout(exist.dataset.to3);
                exist.querySelector(".time-bar").style = "none";
                exist.querySelector(".vertical-time-bar").style = "none";
                exist.querySelector(".time-bar").style.width = "100%";
                exist.querySelector(".vertical-time-bar").style.height = "100%";
                exist.dataset.to3 = this.setTimeout(() => {
                    // exist.querySelector(".time-bar").style.animation = "width_kill " + data.duration + "s linear";
                    // exist.querySelector(".vertical-time-bar").style.animation = "height_kill " + data.duration + "s linear";
                    exist.dataset.to1 = this.setTimeout(() => {
                        exist.style.animation = "hide 0.5s ease-in-out forwards";
                        exist.dataset.to2 = this.setTimeout(() => {
                            exist.remove();
                        }, 500);
                    }, data.duration * 1000);
                }, 10);   
            }
            break;
        case "HelpNotification":
            var exist = HelpNotificationExists(format(data.body));
            if (!exist) {
                HelpNotification(data.title, data.icon, data.body, data.duration, data.location);
            } else {
                this.clearTimeout(exist.dataset.to1);
                this.clearTimeout(exist.dataset.to2);
                this.clearTimeout(exist.dataset.to3);
                exist.querySelector(".time-bar").style = "none";
                exist.querySelector(".time-bar").style.width = "100%";
                exist.dataset.to3 = this.setTimeout(() => {
                    // exist.querySelector(".time-bar").style.animation = "width_kill " + data.duration + "s linear";
                    exist.dataset.to1 = this.setTimeout(() => {
                        exist.style.animation = "hide 0.5s ease-in-out forwards";
                        exist.dataset.to2 = this.setTimeout(() => {
                            exist.remove();
                        }, 500);
                    }, data.duration * 1000);
                }, 10);   
            }
            break;
        default:
            console.log("Unknown action: " + action);
            break;
    }


});
