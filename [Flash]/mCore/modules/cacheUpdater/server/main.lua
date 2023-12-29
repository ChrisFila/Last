--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

FlashSideSCache = {}

FlashSideSCache.caches = {}
FlashSideSCache.relativesDb = {}

FlashSideSCache.getCache = function(index)
    return FlashSideSCache.caches[index] or {}
end

FlashSideSCache.addCacheRule = function(index, sqlTable, updateFrequency)
    FlashSideSCache.caches[index] = {}
    FlashSideSCache.relativesDb[sqlTable] = { index = index, interval = updateFrequency }
    FlashSideServerUtils.trace(("Ajout d'une règle de cache: ^2%s ^7sur ^3%s"):format(index,sqlTable), FlashSidePrefixes.sync)
end

FlashSideSCache.removeCacheRule = function(sql)
    FlashSideSCache.caches[FlashSideSCache.relativesDb[sql]] = nil
    FlashSide.cancelTaskNow(FlashSideSCache.relativesDb[sql].processId)
    FlashSideServerUtils.trace(("Retrait d'une règle de cache: ^2%s"):format(FlashSideSCache.relativesDb[sql].index), FlashSidePrefixes.sync)
    FlashSideSCache.relativesDb[sql] = nil
end

FlashSide.netHandle("esxloaded", function()
    while true do
        for sqlTable, infos in pairs(FlashSideSCache.relativesDb) do
            if not infos.processId then
                infos.processId = FlashSide.newRepeatingTask(function()
                    MySQL.Async.fetchAll(("SELECT * FROM %s"):format(sqlTable), {}, function(result)
                        if FlashSideSCache.caches[infos.index] ~= nil then
                            FlashSideSCache.caches[infos.index] = result
                        end
                    end)
                end, nil, 0, infos.interval)
            end
        end
        Wait(FlashSide.second(1))
    end
end)

