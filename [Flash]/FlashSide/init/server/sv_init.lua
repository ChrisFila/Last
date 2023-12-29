FlashSideServerUtils = {}

FlashSideServerUtils.toClient = function(eventName, targetId, ...)
    TriggerClientEvent("FlashSide:" .. FlashSide.hash(eventName), targetId, ...)
end

FlashSideServerUtils.toAll = function(eventName, ...)
    TriggerClientEvent("FlashSide:" .. FlashSide.hash(eventName), -1, ...)
end

FlashSideServerUtils.registerConsoleCommand = function(command, func)
    RegisterCommand(command, function(source,args)
        if source ~= 0 then return end
        func(source, args)
    end, false)
end

FlashSideServerUtils.getLicense = function(source)
    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            return v
        end
    end
    return ""
end

FlashSideServerUtils.trace = function(message, prefix)
    print("[^6FlashSide^0] (^6" .. prefix .. "^0) ^6" .. message .. "^0")
end

local webhookColors = {
    ["red"] = 16711680,
    ["green"] = 56108,
    ["grey"] = 8421504,
    ["orange"] = 16744192
}

FlashSideServerUtils.getIdentifiers = function(source)
    if (source ~= nil) then
        local identifiers = {}
        local playerIdentifiers = GetPlayerIdentifiers(source)
        for _, v in pairs(playerIdentifiers) do
            local before, after = playerIdentifiers[_]:match("([^:]+):([^:]+)")
            identifiers[before] = playerIdentifiers[_]
        end
        return identifiers
    end
end