--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

FlashSide = {}
FlashSide.newThread = Citizen.CreateThread
FlashSide.newWaitingThread = Citizen.SetTimeout
Citizen.CreateThread, CreateThread, Citizen.SetTimeout, SetTimeout, InvokeNative = nil, nil, nil, nil, nil

Job = nil
Jobs = {}
Jobs.list = {}

FlashSidePrefixes = {
    zones = "^4ZONE",
    err = "^4ERREUR",
    blips = "^4BLIPS",
    npcs = "^4NPCS",
    dev = "^4INFOS",
    sync = "^6SYNC",
    jobs = "^6JOBS",
    succes = "^2SUCCÈS"
}

FlashSide.prefix = function(title, message)
    return ("[^FlashSide^7] (%s^7) %s" .. "^7"):format(title, message)
end