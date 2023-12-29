--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local avaibleJobs = {
    "realestateagent"
}

for k,v in pairs(avaibleJobs) do
    Jobs.list[v] = {}
end

FlashSide.netHandle("esxloaded", function()
    FlashSide.newThread(function()
        while true do
            if Jobs.list[Job.name] ~= nil and Jobs.list[Job.name].openMenu ~= nil then
                if IsControlJustPressed(0, 167) then
                    Jobs.list[Job.name].openMenu()
                end
            end
            Wait(0)
        end
    end)
end)