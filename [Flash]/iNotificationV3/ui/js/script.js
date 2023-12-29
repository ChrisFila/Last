
/*
 * Copyright (c) 2023 ADN's. All right reserved.
 */

function Notification(title, subtitle, icon, body, duration,location) {
    // Create a new notification
    var notif = document.createElement("div");
    var content = document.createElement("div");
    var timebar = document.createElement("div");
    notif.className = "notification";
    content.className = "content";
    timebar.className = "time-bar";

    // Create content of notification
    var verticaltimebar = document.createElement("div");
    var info = document.createElement("div");
    verticaltimebar.className = "vertical-time-bar";
    info.className = "info";

    // Create info of notification
    if (isDefined(icon) || isDefined(title) || isDefined(subtitle)) {
        var div_title = document.createElement("div");
        div_title.className = "title";
        info.appendChild(div_title);
    }

    var text = document.createElement("p");
    text.innerHTML = format(body);
    info.appendChild(text);


    // Create title of notification
    if (isDefined(icon)) {
        var image = document.createElement("img");
        image.src = "assets/images/message.png";
        div_title.appendChild(image);
    }
    if (isDefined(title) || isDefined(subtitle)) {
        var div_text = document.createElement("div");
        div_text.className = "text";
        div_title.appendChild(div_text);
    }


    // Create text of notification
    if (isDefined(title)) {
        var p_title = document.createElement("p");
        p_title.innerHTML = format(title);
        div_text.appendChild(p_title);
    }
    if (isDefined(subtitle)) {
        var p_subtitle = document.createElement("p");
        p_subtitle.className = "subtitle";
        p_subtitle.innerHTML = format(subtitle);
        div_text.appendChild(p_subtitle);
    }

    // Append content to notification
    content.appendChild(verticaltimebar);
    content.appendChild(info);
    notif.appendChild(content);
    notif.appendChild(timebar);

    var REF;
    switch (location) {
        case "right":
            REF = REF_NOTIFICATION_CONTAINER_RIGHT;
            break;
        case "left":
            REF = REF_NOTIFICATION_CONTAINER_LEFT;
            break;
        case "middle":
            REF = REF_NOTIFICATION_CONTAINER_MIDDLE;
            break;
        default:
            REF = REF_NOTIFICATION_CONTAINER_LEFT;
            break;
    }

    REF.appendChild(notif);
    notif.style.animation = "show 0.5s ease-in-out forwards";
    timebar.style.animation = "width_kill " + duration + "s linear";
    verticaltimebar.style.animation = "height_kill " + duration + "s linear";
    
    notif.dataset.to1 = setTimeout(function() {
        notif.style.animation = "hide 0.5s ease-in-out forwards";
        notif.dataset.to2 = setTimeout(function() {
            REF.removeChild(notif);
        }, 500);

    }, duration * 1000);
}

function HelpNotification(title, icon, body, duration,location) {

    var helpnotif = document.createElement("div");
    helpnotif.className = isDefined(duration) ? "helpnotification timed" : "helpnotification";

    if (isDefined(icon) || isDefined(title)) {
        var info = document.createElement("div");
        info.className = "info";

        if (isDefined(icon)) {
            var image = document.createElement("img");
            image.src = GTA_PICTURE(icon) ? GTA_PICTURE(icon) : icon;
            info.appendChild(image);
        }

        if (isDefined(title)) {
            var p_title = document.createElement("p");
            p_title.innerHTML = format(title);
            info.appendChild(p_title);
        }
        helpnotif.appendChild(info);
    }

    var text = document.createElement("p");
    text.innerHTML = format(body);
    helpnotif.appendChild(text);

    if (isDefined(duration)) {
        var timebar = document.createElement("div");
        timebar.className = "time-bar";
        timebar.style.animation = "width_kill " + duration + "s linear";
        helpnotif.appendChild(timebar);
    }


    var REF;
    switch (location) {
        case "right":
            REF = REF_HELPNOTIFICATION_CONTAINER_RIGHT;
            break;
        case "left":
            REF = REF_HELPNOTIFICATION_CONTAINER_LEFT;
            break;
        case "middle":
            REF = REF_HELPNOTIFICATION_CONTAINER_MIDDLE;
            break;
        default:
            REF = REF_HELPNOTIFICATION_CONTAINER_LEFT;
            break;
    }

    REF.appendChild(helpnotif);
    helpnotif.style.animation = "show 0.5s ease-in-out forwards";

    helpnotif.dataset.to1 = setTimeout(function () {
        helpnotif.style.animation = "hide 0.5s ease-in-out forwards";
        helpnotif.dataset.to2 = setTimeout(function () {
            REF.removeChild(helpnotif);
        }, 500);

    }, duration * 1000);

}




function NotificationExists(text) {
    var notifications = document.querySelectorAll(".notification");
    for (var i = 0; i < notifications.length; i++) {
        var len = notifications[i].querySelectorAll(".info p").length;
        if (notifications[i].querySelectorAll(".info p")[len-1].innerHTML == text) {
            return notifications[i];
        }
    }
    return null;
}

function HelpNotificationExists(text) {
    var helpnotifications = document.querySelectorAll(".helpnotification");
    for (var i = 0; i < helpnotifications.length; i++) {
        var len = helpnotifications[i].querySelectorAll("p").length;
        if (helpnotifications[i].querySelectorAll("p")[len-1].innerHTML == text) {
            return helpnotifications[i];
        }
    }
    return null;
}




function isDefined(param) {
    return typeof param !== "undefined" && param !== null;
}

function format(text) {
    var everColoring = false;
    var currentColor = "";
    var currentColorr = "";
    var finalText = "";
    for (var i = 0; i < text.length; i++) {
        if(text[i] === "\n"){
            finalText += "<br />"
        }
        if(text[i] === "~n~"){
            finalText += "<br />"
        }
        if(text[i] === "~"){
            var INFO = '';
            i++;
            while (text[i] != "~") {
                INFO += text[i];
                i++;
            }
            if (isDefined(Text_color[INFO])){
                currentColor = Text_color[INFO];
                if (!everColoring) {
                    finalText += "<span style=\"color: " + currentColor + "\">";
                    everColoring = true;
                } else {
                    finalText += "</span><span style=\"color: " + currentColor + "\">";
                }
            } else if(isDefined(Fonts_modifiers[INFO])){
                currentColor = Fonts_modifiers[INFO];
                if (!everColoring) {
                    finalText += "<span style=\"" + currentColor + "\">";
                    everColoring = true;
                } else {
                    finalText += "</span><span style=\"" + currentColor + "\">";
                }
            } else if(isDefined(Keys[INFO])){
                finalText += "<span class=\"key\">" + Keys[INFO] + "</span>";
            }
        } else {
            finalText += text[i];
        }
    }
    if (everColoring) {
        finalText += "</span>";
    }
    return finalText;
}

function GTA_PICTURE(id) {
    if (isDefined(Picture[id])) {
        return "assets/images/" + Picture[id];
    } else {
        return false;
    }
}

