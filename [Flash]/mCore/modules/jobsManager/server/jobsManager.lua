---@author Pablo Z.
---@version 1.0
--[[
  This file is part of FlashSide RolePlay.

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

local playersJobsCache = {}

FlashSideSJobsManager = {}
FlashSideSJobsManager.list = {}

---getJob
---@public
---@return Job
FlashSideSJobsManager.getJob = function(job)
    return FlashSideSJobsManager.list[job]
end

FlashSide.netHandleBasic("playerDropped", function(reason)
    playersJobsCache[source] = nil
end)

--[[
FlashSide.netHandle("esxloaded", function()
    MySQL.Async.fetchAll("SELECT * FROM jobs WHERE useCutomSystem = 1", {}, function(result)
        for _,job in pairs(result) do
            if not FlashSideSharedCustomJobs[job.name] then
                print(FlashSide.prefix(FlashSidePrefixes.jobs,("Impossible de charger le job %s"):format(job.label)))
            else
                local society = ("society_%s"):format(job.name)
                TriggerEvent('esx_society:registerSociety', job.name, job.label, society, society, society, {type = 'private'})
                print(FlashSide.prefix(FlashSidePrefixes.jobs,("Chargement du job ^4%s ^7!"):format(job.name)))
                Job(job.name, job.label)
                FlashSideSharedCustomJobs[job.name].onThisJobInit(FlashSideSJobsManager.list[job.name])
            end
        end
    end)
end)
--]]

FlashSide.netRegisterAndHandle("jobInitiated", function(job)
    local source = source
    playersJobsCache[source] = {name = job.name, grade = job.grade_name, isCustom = FlashSideSJobsManager.getJob(job.name) ~= nil}
    if not FlashSideSJobsManager.getJob(job.name) then
        return
    end
    ---@type Job
    local FlashSideJob = FlashSideSJobsManager.getJob(job.name)
    FlashSideJob:subscribe(source, job.grade_name)
end)

FlashSide.netRegisterAndHandle("jobUpdated", function(newJob)
    local source = source
    local previousCache = playersJobsCache[source]
    local newCache = {name = newJob.name, grade = newJob.grade_name, isCustom = FlashSideSJobsManager.getJob(newJob.name) ~= nil}

    if previousCache.name ~= newJob.name then
        -- Changement de job
        ---@type Job
        if previousCache.isCustom then
            local previousJob = FlashSideSJobsManager.getJob(previousCache.name)
            previousJob:unsubscribe(source, previousCache.grade)
        end
        if newCache.isCustom then
            local newFlashSideJob = FlashSideSJobsManager.getJob(newCache.name)
            newFlashSideJob:subscribe(source, newCache.grade)
        end
    else
        if newCache.isCustom then
            if previousCache.grade ~= newCache.grade then
                local FlashSideJob = FlashSideSJobsManager.getJob(newCache.name)
                if previousCache.grade == "boss" then
                    FlashSideJob:alterBossAccess(source, false)
                elseif newCache.grade == "boss" then
                    FlashSideJob:alterBossAccess(source, true)
                end
            end
        end
    end

    playersJobsCache[source] = newCache
end)