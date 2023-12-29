FlashSide = {}
FlashSide.newThread = Citizen.CreateThread
FlashSide.newWaitingThread = Citizen.SetTimeout
--Citizen.CreateThread, CreateThread, Citizen.SetTimeout, SetTimeout, InvokeNative = nil, nil, nil, nil, nil

Job = nil
Jobs = {}
Jobs.list = {}

FlashSidePrefixes = {
    zones = "^1ZONE",
    err = "^1ERREUR",
    blips = "^1BLIPS",
    npcs = "^1NPCS",
    dev = "^6INFOS",
    sync = "^6SYNC",
    jobs = "^6JOBS",
    succes = "^2SUCCÈS"
}

FlashSide.hash = function(notHashedModel)
    return GetHashKey(notHashedModel)
end

FlashSide.prefix = function(title, message)
    return ("[^6FlashSide^0] (%s^0) %s" .. "^0"):format(title, message)
end

local registredEvents = {}
local function isEventRegistred(eventName)
    for k,v in pairs(registredEvents) do
        if v == eventName then return true end
    end
    return false
end

FlashSide.netRegisterAndHandle = function(eventName, handler)
    print('REGISTER DE l\'EVENT '..eventName)
    local event = "FlashSide:" .. FlashSide.hash(eventName)
    if not isEventRegistred(event) then
        RegisterNetEvent(event)
        table.insert(registredEvents, event)
    end
    AddEventHandler(event, handler)
end


FlashSide.netRegister = function(eventName)
    local event = "FlashSide:" .. FlashSide.hash(eventName)
    RegisterNetEvent(event)
end


FlashSide.netHandle = function(eventName, handler)
    local event = "FlashSide:" .. FlashSide.hash(eventName)
    AddEventHandler(event, handler)
end


FlashSide.netHandleBasic = function(eventName, handler)
    AddEventHandler(eventName, handler)
end

FlashSide.second = function(from)
    return from*1000
end

FlashSide.toInternal = function(eventName, ...)
    TriggerEvent("FlashSide:" .. FlashSide.hash(eventName), ...)
end