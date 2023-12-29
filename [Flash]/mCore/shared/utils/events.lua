--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---toInternal
---@public
---@return void
FlashSide.toInternal = function(eventName, ...)
    TriggerEvent("FlashSide:" .. FlashSide.hash(eventName), ...)
end

local registredEvents = {}
local function isEventRegistred(eventName)
    for k,v in pairs(registredEvents) do
        if v == eventName then return true end
    end
    return false
end
---netRegisterAndHandle
---@public
---@return void
FlashSide.netRegisterAndHandle = function(eventName, handler)
    local event = "FlashSide:" .. FlashSide.hash(eventName)
    if not isEventRegistred(event) then
        RegisterNetEvent(event)
        table.insert(registredEvents, event)
    end
    AddEventHandler(event, handler)
end

---netRegister
---@public
---@return void
FlashSide.netRegister = function(eventName)
    local event = "FlashSide:" .. FlashSide.hash(eventName)
    RegisterNetEvent(event)
end

---netHandle
---@public
---@return void
FlashSide.netHandle = function(eventName, handler)
    local event = "FlashSide:" .. FlashSide.hash(eventName)
    AddEventHandler(event, handler)
end

---netHandleBasic
---@public
---@return void
FlashSide.netHandleBasic = function(eventName, handler)
    AddEventHandler(eventName, handler)
end

---hash
---@public
---@return any
FlashSide.hash = function(notHashedModel)
    return GetHashKey(notHashedModel)
end

---second
---@public
---@return number
FlashSide.second = function(from)
    return from*1000
end