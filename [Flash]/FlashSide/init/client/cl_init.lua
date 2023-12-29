FlashSideClientUtils = {}

FlashSideClientUtils.toServer = function(eventName, ...)
    TriggerServerEvent("FlashSide:" .. FlashSide.hash(eventName), ...)
end