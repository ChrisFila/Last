---@author Pablo Z.
---@version 1.0
--[[
  This file is part of FlashSide RolePlay.
  
  File [main] created at [26/04/2021 18:18]

  Copyright (c) FlashSide RolePlay - All Rights Reserved

  Unauthorized using, copying, modifying and/or distributing of this file,
  via any medium is strictly prohibited. This code is confidential.
--]]

drugsList = {
  {
      name = "Weed",

      harvest = {
          position = { coords = vector3(826.27, 2192.02, 52.4) },
          reward = { item = "weed", count = 1 },
          interval = 2,
      },

      treatment = {
          position = { coords = vector3(-1146.794, 4940.908, 222.26) },
          reward = { item = "weed_pooch", count = 1 },
          requiered = { item = "weed", count = 5 },
          interval = 3,
      },

      sell = {
          position = { coords = vector3(1510.8572998046, 6333.6591796875, 23.923109054566) },
          npc = {
              position = { coords = vector3(1512.18, 6332.26, 24.03), heading = 40.48 },
              model = "a_m_m_rurmeth_01"
          },
          reward = { account = "dirtycash", genReward = function()
              local possibilities = {
                  500
              }
              return possibilities[math.random(1, #possibilities)]
          end },
          requiered = { item = "weed_pooch", count = 1 },
          interval = 5
      }
  },

  {
      name = "Coke",

      harvest = {
          position = { coords = vector3(-106.441, 1910.979, 196.936) },
          reward = { item = "coke", count = 1 },
          interval = 2,
      },

      treatment = {
          position = { coords = vector3(722.438, 4190.06, 41.09) },
          reward = { item = "coke_pooch", count = 1 },
          requiered = { item = "coke", count = 5 },
          interval = 3,
      },

      sell = {
          position = { coords = vector3(1505.6119384766, 6327.5615234375, 24.082513809204) },
          npc = {
              position = { coords = vector3(1504.9111328125, 6325.771484375, 24.082511901856), heading = 344.66 },
              model = "a_m_m_rurmeth_01"
          },
          reward = { account = "dirtycash", genReward = function()
              local possibilities = {
                  600
              }
              return possibilities[math.random(1, #possibilities)]
          end },
          requiered = { item = "coke_pooch", count = 1 },
          interval = 5
      }
  },

  {
      name = "Meth",

      harvest = {
          position = { coords = vector3(1195.62, -3253.07, 7.1) },
          reward = { item = "meth", count = 1 },
          interval = 2,
      },

      treatment = {
          position = { coords = vector3(611.86, -3062.82, 6.07) },
          reward = { item = "meth_pooch", count = 1 },
          requiered = { item = "meth", count = 5 },
          interval = 3,
      },

      sell = {
          position = { coords = vector3(1530.1770019532, 6345.2915039062, 24.07957458496) },
          npc = {
              position = { coords = vector3(1531.932006836, 6346.1206054688, 24.082487106324), heading = 112.5 },
              model = "a_m_m_rurmeth_01"
          },
          reward = { account = "dirtycash", genReward = function()
              local possibilities = {
                  700
              }
              return possibilities[math.random(1, #possibilities)]
          end },
          requiered = { item = "meth_pooch", count = 1 },
          interval = 5
      }
  },

  {
      name = "Opium",

      harvest = {
          position = { coords = vector3(1444.35, 6332.3, 23.96) },
          reward = { item = "opium", count = 1 },
          interval = 2,
      },

      treatment = {
          position = { coords = vector3(2165.724, 3379.376, 46.43) },
          reward = { item = "opium_pooch", count = 1 },
          requiered = { item = "opium", count = 5 },
          interval = 3,
      },

      sell = {
          position = { coords = vector3(1537.644165039, 6325.6083984375, 24.089836120606) },
          npc = {
              position = { coords = vector3(1539.0443115234, 6324.0771484375, 24.06265258789), heading = 28.89 },
              model = "a_m_m_rurmeth_01"
          },
          reward = { account = "dirtycash", genReward = function()
              local possibilities = {
                  800
              }
              return possibilities[math.random(1, #possibilities)]
          end },
          requiered = { item = "opium_pooch", count = 1 },
          interval = 5
      }
  }
}

FlashSideSDrugsManager = {}
FlashSideSDrugsManager.list = {}
FlashSideSDrugsManager.onCooldown = {}

FlashSide.netHandle("esxloaded", function()
    FlashSide.newThread(function()
      Wait(8000)
      for id, drug in pairs(drugsList) do
          FlashSideServerUtils.trace("Register de la drogue "..drug.name.." !", FlashSidePrefixes.zones)
          Drug(drug.harvest.position, drug.treatment.position, drug.sell.position, {harvest = drug.harvest, treatment = drug.treatment, sell = drug.sell})
      end
    end)
end)