--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local playerRestrictedBuckets = 5000

FlashSide.netRegisterAndHandle("setBucket", function(bucketID)
    local source = source
    SetPlayerRoutingBucket(source, bucketID)
    FlashSideServerUtils.trace(("Le joueur %s est désormais sur le bucket %s"):format(GetPlayerName(source), bucketID), FlashSidePrefixes.sync)
end)

FlashSide.netRegisterAndHandle("genPlayerBucket", function()
    local source = source
    local bucketID = (playerRestrictedBuckets+source)
    SetPlayerRoutingBucket(source, bucketID)
    FlashSideServerUtils.trace(("Le joueur %s est désormais sur le bucket %s"):format(GetPlayerName(source), bucketID), FlashSidePrefixes.sync)
end)

FlashSide.netRegisterAndHandle("setOnPublicBucket", function()
    local source = source
    SetPlayerRoutingBucket(source, 0)
    FlashSideServerUtils.trace(("Le joueur %s est désormais sur le bucket ^2public"):format(GetPlayerName(source)), FlashSidePrefixes.sync)
end)