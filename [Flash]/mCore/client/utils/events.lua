--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

FlashSideClientUtils = {}

FlashSideClientUtils.toServer = function(eventName, ...)
    TriggerServerEvent("FlashSide:" .. FlashSide.hash(eventName), ...)
end