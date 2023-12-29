---@author Pablo Z.
---@version 1.0
--[[
  This file is part of FlashSide RolePlay.
  
  File [main.lua] created at [11/06/2021 13:07]

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

FlashSideCKeysDisabler = {}

FlashSideCKeysDisabler.disableKey = function(key)
    FlashSideCKeysDisabler[key] = true
end

FlashSideCKeysDisabler.enableKey = function(key)
    FlashSideCKeysDisabler[key] = nil
    Wait(150)
    EnableControlAction(0, key, true)
end

FlashSide.netHandle("esxloaded", function()
    FlashSide.newThread(function()
        while true do
            for k,v in pairs(FlashSideCKeysDisabler) do
                DisableControlAction(0, k, true)
            end
            Wait(0)
        end
    end)
end)