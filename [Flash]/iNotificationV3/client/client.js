Tools.registerClientEvent('iNotificationV3:showNotification', (message, duration=5,location="left") => {
    Notification(undefined, undefined, undefined, message, duration, location);
    
});

Tools.registerClientEvent('iNotificationV3:showAdvancedNotification', (title, subtitle, message, icon, duration=5, location="left") => {
    Notification(title, subtitle, message, icon, duration, location)
});

Tools.registerClientEvent('iNotificationV3:showHelpNotfication', (message, duration=5, location="left") => {
    HelpNotification(undefined,undefined,message, duration, location)
});

Tools.registerClientEvent('iNotificationV3:showAdvancedHelpNotfication', (title, message, icon, duration=5, location="left") => {
    HelpNotification(title, icon, message, duration, location)
});


function Notification(title, subtitle, message, icon, duration,location) {
    SendNUIMessage({
        action: 'Notification',
        data: {
            title: "Notification",
            subtitle: subtitle,
            icon: icon,
            body: message,
            duration: duration,
            location : location
        }
    });
}

function HelpNotification(title, icon, message, duration,location) {
    SendNUIMessage({
        action: 'HelpNotification',
        data: {
            title: title,
            icon: icon,
            body: message,
            duration: duration,
            location : location
        }
    });
}