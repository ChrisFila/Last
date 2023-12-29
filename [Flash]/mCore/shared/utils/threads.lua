--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

---@public
---@type number
local tasks = 0

---@public
---@type table
local activeTasks = {}

---repeatingTask
---@public
---@return number
FlashSide.newRepeatingTask = function(onRun, onFinished, delay, interval)
    tasks = tasks + 1
    local taskID = tasks
    activeTasks[taskID] = true
    if delay > 0 then
        Wait(delay)
    end
    FlashSide.newThread(function()
        while activeTasks[taskID] do
            onRun()
            if interval > 0 then
                Wait(interval)
            end
        end
        onFinished()
    end)
    return taskID
end

---cancelTaskNow
---@public
---@return void
---@param taskID number
FlashSide.cancelTaskNow = function(taskID)
    if not activeTasks[taskID] then return end
    activeTasks[taskID] = nil
end