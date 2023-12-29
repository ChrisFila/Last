Keys = {
  ["ESC"]       = 322,  ["F1"]        = 288,  ["F2"]        = 289,  ["F3"]        = 170,  ["F5"]  = 166,  ["F6"]  = 167,  ["F7"]  = 168,  ["F8"]  = 169,  ["F9"]  = 56,   ["F10"]   = 57, 
  ["~"]         = 243,  ["1"]         = 157,  ["2"]         = 158,  ["3"]         = 160,  ["4"]   = 164,  ["5"]   = 165,  ["6"]   = 159,  ["7"]   = 161,  ["8"]   = 162,  ["9"]     = 163,  ["-"]   = 84,   ["="]     = 83,   ["BACKSPACE"]   = 177, 
  ["TAB"]       = 37,   ["Q"]         = 44,   ["W"]         = 32,   ["E"]         = 38,   ["R"]   = 45,   ["T"]   = 245,  ["Y"]   = 246,  ["U"]   = 303,  ["P"]   = 199,  ["["]     = 116,  ["]"]   = 40,   ["ENTER"]   = 18,
  ["CAPS"]      = 137,  ["A"]         = 34,   ["S"]         = 8,    ["D"]         = 9,    ["F"]   = 23,   ["G"]   = 47,   ["H"]   = 74,   ["K"]   = 311,  ["L"]   = 182,
  ["LEFTSHIFT"] = 21,   ["Z"]         = 20,   ["X"]         = 73,   ["C"]         = 26,   ["V"]   = 0,    ["B"]   = 29,   ["N"]   = 249,  ["M"]   = 244,  [","]   = 82,   ["."]     = 81,
  ["LEFTCTRL"]  = 36,   ["LEFTALT"]   = 19,   ["SPACE"]     = 22,   ["RIGHTCTRL"] = 70, 
  ["HOME"]      = 213,  ["PAGEUP"]    = 10,   ["PAGEDOWN"]  = 11,   ["DELETE"]    = 178,
  ["LEFT"]      = 174,  ["RIGHT"]     = 175,  ["UP"]        = 27,   ["DOWN"]      = 173,
  ["NENTER"]    = 201,  ["N4"]        = 108,  ["N5"]        = 60,   ["N6"]        = 107,  ["N+"]  = 96,   ["N-"]  = 97,   ["N7"]  = 117,  ["N8"]  = 61,   ["N9"]  = 118
}
 


local menuIsOpen = false
local contacts = {}
local messages = {}
local gmessages = {}
local groups = {}
local myPhoneNumber = ''
local ignoreFocus = false
local takePhoto = false
local TokoVoipID = nil
local CameraO = false
local flas = false
local PhoneInCall = {}
local disableKeys = false
local flightmode = false








--====================================================================================

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()

end)




RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

end)




--====================================================================================
--  
--====================================================================================


RegisterKeyMapping('TooglePhone', 'Open Phone', 'keyboard', 'G');

RegisterCommand("TooglePhone",function()
	TooglePhone()
end)



RegisterNetEvent('gks:use')
AddEventHandler('gks:use', function()
  TooglePhone() 
end)



CreateThread(function()
  while true do
      if disableKeys then
          Wait(0)
          DisableControlAction(0, 0, true)    -- Next Camera
          DisableControlAction(0, 1, true)    -- Look Left/Right
          DisableControlAction(0, 2, true)    -- Look up/Down
          DisableControlAction(0, 16, true)   -- Next Weapon
          DisableControlAction(0, 17, true)   -- Select Previous Weapon
          DisableControlAction(0, 18, true)   -- Attack            
          DisableControlAction(0, 22, true)   -- Jump
          DisableControlAction(0, 24, true)   -- Attack
          DisableControlAction(0, 25, true)   -- Aim
          DisableControlAction(0, 26, true)   -- Look Behind
          DisableControlAction(0, 36, true)   -- Input Duck/Sneak
          DisableControlAction(0, 37, true)   -- Weapon Wheel
          DisableControlAction(0, 44, true)   -- Cover
          DisableControlAction(0, 45, true)   -- Cover
          DisableControlAction(0, 47, true)   -- Detonate
          DisableControlAction(0, 55, true)   -- Dive
          DisableControlAction(0, 69, true)   -- Attack            
          DisableControlAction(0, 75, true)   -- Exit Vehicle
          DisableControlAction(0, 76, true)   -- Vehicle Handbrake
          DisableControlAction(0, 81, true)   -- Next Radio (Vehicle)
          DisableControlAction(0, 82, true)   -- Previous Radio (Vehicle)
          DisableControlAction(0, 91, true)   -- Passenger Aim (Vehicle)
          DisableControlAction(0, 92, true)   -- Passenger Attack (Vehicle)
          DisableControlAction(0, 99, true)   -- Select Next Weapon (Vehicle)
          DisableControlAction(0, 106, true)  -- Control Override (Vehicle)
          DisableControlAction(0, 114, true)  -- Fly Attack (Flying)
          DisableControlAction(0, 115, true)  -- Next Weapon (Flying)
          DisableControlAction(0, 121, true)  -- Fly Camera (Flying)
          DisableControlAction(0, 122, true)  -- Control OVerride (Flying)
          DisableControlAction(0, 135, true)  -- Control OVerride (Sub)
          DisableControlAction(0, 142, true)   -- Attack
          DisableControlAction(0, 144, true)   -- Attack            
          DisableControlAction(0, 200, true)  -- Pause Menu
          DisableControlAction(0, 223, true)   -- Attack
          DisableControlAction(0, 229, true)   -- Attack    
          DisableControlAction(0, 237, true)   -- Attack            
       --   DisableControlAction(0, 245, true)  -- Chat
          DisableControlAction(0, 257, true)   -- Attack    
          DisableControlAction(0, 329, true)   -- Attack
          DisableControlAction(0, 346, true)   -- Attack            

          DisableControlAction(0, 289, true) -- Inventory
          DisableControlAction(0, 311, true) -- Inventory
          DisableControlAction(0, 303, true) -- Inventory
          DisableControlAction(0, 182, true) -- Inventory
      else
          Wait(200)
      end
  end
end)

AddEventHandler('gksphone:disableControlActions', function(bool)
  disableKeys = bool
end)

RegisterNUICallback('focusphone', function(data, cb)
  if menuIsOpen then
    SetNuiFocusKeepInput(data.focusphone)
  end
end)



function TooglePhone() 
  ESX.TriggerServerCallback('gksphone:phone-check', function(durum)
    if durum ~= nil then
      changePhoneType(durum)
      menuIsOpen = not menuIsOpen
      SendNUIMessage({show = menuIsOpen})
      if menuIsOpen == true then 
        PhonePlayIn()
        SetCursorLocation(0.9, 0.922)
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        TriggerEvent('gksphone:disableControlActions', true)
  
      else
        flas = false
        ignoreFocus = false
        PhonePlayOut()
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
        TriggerEvent('camera:stop', false)
        TriggerEvent('gksphone:disableControlActions', false)
        TriggerEvent('gksphone:faketakestop')
        SendNUIMessage({event = 'imageclose'})
      end
    else
      ESX.ShowNotification(_U('no_item'))
    end
  end)
end

RegisterNUICallback('closePhone', function(data, cb)

  menuIsOpen = false
  ignoreFocus = false
  SendNUIMessage({show = false})
  flas = false
  PhonePlayOut()
  SetNuiFocus(false, false)
  SetNuiFocusKeepInput(false)
  TriggerEvent('camera:stop', false)
  TriggerEvent('gksphone:disableControlActions', false)
  cb()
end)




--====================================================================================
--  Gestion des appels fixe
--====================================================================================


RegisterNetEvent("gksphone:notifyFixePhoneChange")
AddEventHandler("gksphone:notifyFixePhoneChange", function(_PhoneInCall)
  PhoneInCall = _PhoneInCall
end)

 
--====================================================================================
--  Events
--====================================================================================
RegisterNetEvent('gksphone:loadingphone')
AddEventHandler('gksphone:loadingphone', function(_myPhoneNumber,  _contacts, allmessages, allgroup, allgmessage)
  myPhoneNumber = _myPhoneNumber
  SendNUIMessage({event = 'updateMyPhoneNumber', myPhoneNumber = myPhoneNumber})

  contacts = _contacts
  SendNUIMessage({event = 'updateContacts', contacts = contacts})
  
  messages = allmessages
  
  SendNUIMessage({event = 'updateMessages', messages = messages})

  groups = allgroup

  SendNUIMessage({event = 'updateGroups', groupss = groups})

  gmessages = allgmessage

  SendNUIMessage({event = 'updateMessageG', gmessages = gmessages})
  
end)

RegisterNetEvent("gksphone:contactList")
AddEventHandler("gksphone:contactList", function(_contacts)
  SendNUIMessage({event = 'updateContacts', contacts = _contacts})
  contacts = _contacts
end)


RegisterNetEvent("gksphone:allMessage")
AddEventHandler("gksphone:allMessage", function(allmessages)
  messages = allmessages
  SendNUIMessage({event = 'updateMessages', messages = allmessages})
end)

RegisterNetEvent("gksphone:receiveMessage")
AddEventHandler("gksphone:receiveMessage", function(message)
  SendNUIMessage({event = 'newMessage', message = message})
  table.insert(messages, message)
  if message.owner == 0 then
    ESX.TriggerServerCallback('gksphone:phone-check', function(durum)
      if durum ~= nil then
        local text = _U('new_one_message')

          text = message.transmitter .. _U('new_message_normal')
          for _,contact in pairs(contacts) do
            if contact.number == message.transmitter then
              text = contact.display .. _U('new_message_normal')
              break
            end
          end

        TriggerEvent('gksphone:notifi', {title = 'Messages', message = text, img= '/html/static/img/icons/messages.png', appinfo = message.transmitter })

        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
        Citizen.Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
        Citizen.Wait(300)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
      end
    end)
  end
end)


--====================================================================================
--  Function client | Contacts
--====================================================================================
function addContact(display, num, avatar) 
    TriggerServerEvent('gksphone:addContact', display, num, avatar)
end

function deleteContact(num) 
    TriggerServerEvent('gksphone:deleteContact', num)
end
--====================================================================================
--  Function client | Messages
--====================================================================================

function deleteMessage(msgId)
  TriggerServerEvent('gksphone:deleteMessage', msgId)
  for k, v in ipairs(messages) do 
    if v.id == msgId then
      table.remove(messages, k)
      SendNUIMessage({event = 'updateMessages', messages = messages})
      return
    end
  end
end

function deleteMessageContact(num)
  TriggerServerEvent('gksphone:deleteMessageNumber', num)
end

function deleteAllMessage()
  TriggerServerEvent('gksphone:deleteAllMessage')
end

function setReadMessageNumber(num)
  TriggerServerEvent('gksphone:setReadMessageNumber', num)
  for k, v in ipairs(messages) do 
    if v.transmitter == num then
      v.isRead = 1
    end
  end
end

function requestAllMessages()
  TriggerServerEvent('gksphone:requestAllMessages')
end

function requestAllContact()
  TriggerServerEvent('gksphone:requestAllContact')
end



--====================================================================================
--  Function client | Appels
--====================================================================================
local aminCall = false
local inCall = false
local dnemeasd = nil

RegisterCommand("pacc", function(source, args, rawCommand)
  if aminCall then
	  SendNUIMessage({ event = "autoAcceptCall", infoCall = dnemeasd, initiator = false, who = 'logdneme'})
  end
end)

RegisterCommand("prej", function(source, args, rawCommand)
  TriggerServerEvent('gksphone:rejectCall', dnemeasd)
  aminCall = false
  dnemeasd = nil
  PhonePlayOut()
end)

RegisterNetEvent("gksphone:waitingCall")
AddEventHandler("gksphone:waitingCall", function(infoCall, initiator, who)
  ESX.TriggerServerCallback('gksphone:phone-check', function(durum)
    if durum ~= nil and flightmode == false then
      SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator, who = who})
      if initiator == true then
        PhonePlayCall()
        if menuIsOpen == false then
          TooglePhone()
        end
      end
    end
  end)
end)

RegisterNetEvent("gksphone:waitingCallto")
AddEventHandler("gksphone:waitingCallto", function(infoCall, initiator, who)
  ESX.TriggerServerCallback('gksphone:phone-check', function(durum)
    if durum ~= nil and flightmode == false then
      if who == 'call' then
        aminCall = true
        dnemeasd = infoCall
      end
      SendNUIMessage({event = 'waitingCall', infoCall = infoCall, initiator = initiator, who = who})
      TriggerEvent('gksphone:notifi', {title = 'Call', message = _U('phone_ring'), img= '/html/static/img/icons/call.png' })
    end
  end)
end)

RegisterNetEvent("gksphone:acceptCall")
AddEventHandler("gksphone:acceptCall", function(infoCall, initiator)
  if inCall == false then
    inCall = true
    if Config.UseMumbleVoIP then
      exports["mumble-voip"]:SetCallChannel(infoCall.id+1)
    elseif Config.PMAVoice then
      exports["pma-voice"]:setCallChannel(infoCall.id+1)
    elseif Config.UseTokoVoIP then
      exports.tokovoip_script:addPlayerToRadio(infoCall.id + 1000)
      TokoVoipID = infoCall.id + 1000
    else
      NetworkSetVoiceChannel(infoCall.id + 1)
      NetworkSetTalkerProximity(0.0)
    end
  end
  PhonePlayCall()
  SendNUIMessage({event = 'acceptCall', infoCall = infoCall, initiator = initiator})
end)

RegisterNetEvent("gksphone:rejectCall")
AddEventHandler("gksphone:rejectCall", function(infoCall)
  if inCall == true then
    inCall = false
    if Config.UseMumbleVoIP then
      exports["mumble-voip"]:SetCallChannel(0)
    elseif Config.PMAVoice then
      exports["pma-voice"]:removePlayerFromCall(0)
    elseif Config.UseTokoVoIP then
      exports.tokovoip_script:removePlayerFromRadio(TokoVoipID)
      TokoVoipID = nil
    else
      Citizen.InvokeNative(0xE036A705F989E049)
      NetworkSetTalkerProximity(2.5)
    end
  end
  aminCall = false
  dnemeasd = nil
  PhonePlayText()
  SendNUIMessage({event = 'rejectCall', infoCall = infoCall})
end)


RegisterNetEvent("gksphone:historiqueCall")
AddEventHandler("gksphone:historiqueCall", function(historique)
  SendNUIMessage({event = 'historiqueCall', historique = historique})
end)


function startCall (phone_number, who, extraData)
  TriggerServerEvent('gksphone:startCall', phone_number, who, extraData)
end

function acceptCall (infoCall, rtcAnswer)
  TriggerServerEvent('gksphone:acceptCall', infoCall, rtcAnswer)
end

function rejectCall(infoCall)
  TriggerServerEvent('gksphone:rejectCall', infoCall)
end

function ignoreCall(infoCall)
  TriggerServerEvent('gksphone:ignoreCall', infoCall)
end

function requestHistoriqueCall() 
  TriggerServerEvent('gksphone:getHistoriqueCall')
end

function appelsDeleteHistorique (num)
  TriggerServerEvent('gksphone:appelsDeleteHistorique', num)
end

function appelsDeleteAllHistorique ()
  TriggerServerEvent('gksphone:appelsDeleteAllHistorique')
end
  

--====================================================================================
--  Event NUI - Appels
--====================================================================================

RegisterNUICallback('startCall', function (data, cb)
  startCall(data.numero, data.who, data.extraData)
  cb()
end)

RegisterNUICallback('acceptCall', function (data, cb)
  acceptCall(data.infoCall, data.rtcAnswer)
  cb()
end)
RegisterNUICallback('rejectCall', function (data, cb)
  rejectCall(data.infoCall)
  cb()
end)

RegisterNUICallback('ignoreCall', function (data, cb)
  ignoreCall(data.infoCall)
  cb()
end)



--====================================================================================
--  Gestion des evenements NUI
--==================================================================================== 
RegisterNUICallback('log', function(data, cb)
  --print(data)
  cb()
end)
RegisterNUICallback('focus', function(data, cb)
  cb()
end)
RegisterNUICallback('blur', function(data, cb)
  cb()
end)

--====================================================================================
--  Event - Messages
--====================================================================================
RegisterNUICallback('getMessages', function(data, cb)
  cb(json.encode(messages))
end)
RegisterNUICallback('sendMessages', function(data, cb)
  if data.message == '%pos%' then
    local myPos = GetEntityCoords(PlayerPedId())
    data.message = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
  end
  TriggerServerEvent('gksphone:sendMessages', data.phoneNumber, data.message)
end)
RegisterNUICallback('deleteMessage', function(data, cb)
  deleteMessage(data.id)
  cb()
end)
RegisterNUICallback('deleteMessageNumber', function (data, cb)
  deleteMessageContact(data.number)
  cb()
end)
RegisterNUICallback('deleteAllMessage', function (data, cb)
  deleteAllMessage()
  cb()
end)
RegisterNUICallback('setReadMessageNumber', function (data, cb)
  setReadMessageNumber(data.number)
  cb()
end)

--====================================================================================
--  Group - Messages
--====================================================================================

RegisterNUICallback('createGroupMessage', function(data, cb)
  TriggerServerEvent('gksphone:creategroup', data.groupname, data.gimage, data.contacts, data.number)
end)

RegisterNUICallback('updategroup', function(data, cb)
  TriggerServerEvent('gksphone:updategroup', data.id, data.contacts, data.number)
end)

RegisterNUICallback('deletegrup', function(data, cb)
  TriggerServerEvent('gksphone:deletegroup', data.id, data.contacts)
end)

RegisterNUICallback('newpeople', function(data, cb)
  TriggerServerEvent('gksphone:newpeople', data.id, data.contacts)
end)

RegisterNetEvent('gksphone:creategroup')
AddEventHandler('gksphone:creategroup', function(allgroup, group)

  groups = allgroup
 
  SendNUIMessage({ event = "createGroup", groups = groups})

  TriggerEvent('gksphone:notifi', {title = 'Messages', message = group .._U('group_created'), img= '/html/static/img/icons/messages.png' })
  
end)

RegisterNetEvent('gksphone:creategroupsrc')
AddEventHandler('gksphone:creategroupsrc', function(allgroup)

  groups = allgroup
 
  SendNUIMessage({ event = "createGroup", groups = groups})
  
end)

RegisterNetEvent('gksphone:updatenewpeoppel')
AddEventHandler('gksphone:updatenewpeoppel', function(allgroup, allgmessage)

  groups = allgroup

  SendNUIMessage({event = 'updateGroups', groupss = groups})

  gmessages = allgmessage

  SendNUIMessage({event = 'updateMessageG', gmessages = gmessages})
  
end)

RegisterNetEvent('gksphone:updategroup')
AddEventHandler('gksphone:updategroup', function(allgroup, allgmessage)

  groups = allgroup

  SendNUIMessage({event = 'updateGroups', groupss = groups})

  gmessages = allgmessage

  SendNUIMessage({event = 'updateMessageG', gmessages = gmessages})
  
end)

RegisterNetEvent('gksphone:deletegroup')
AddEventHandler('gksphone:deletegroup', function(allgroup, allgmessage)

  groups = allgroup

  SendNUIMessage({event = 'updateGroups', groupss = groups})

  gmessages = allgmessage

  SendNUIMessage({event = 'updateMessageG', gmessages = gmessages})
  TriggerEvent('gksphone:notifi', {title = 'Messages', message = _U('group_deleted'), img= '/html/static/img/icons/messages.png' })
end)

RegisterNUICallback('sendGMessage', function(data, cb)
  if data.messages == '%pos%' then
    local myPos = GetEntityCoords(PlayerPedId())
    data.messages = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
  end
  TriggerServerEvent('gksphone:sendgroupmessage', data.groupid, data.groupname, data.messages, data.contacts, data.number)
end)

RegisterNetEvent('gksphone:csendgroupmessage')
AddEventHandler('gksphone:csendgroupmessage', function(allgmessage)
  


  table.insert(gmessages, allgmessage)

  SendNUIMessage({event = 'updateMessageG', gmessages = gmessages})


end)

RegisterNetEvent('gksphone:csendgroupmessagesrc')
AddEventHandler('gksphone:csendgroupmessagesrc', function(allgmessage)


  table.insert(gmessages, allgmessage)
  SendNUIMessage({event = 'updateMessageG', gmessages = gmessages})

end)
--====================================================================================
--  Event - Contacts
--====================================================================================
RegisterNUICallback('addContact', function(data, cb) 
  TriggerServerEvent('gksphone:addContact', data.display, data.phoneNumber, data.avatar)
end)
RegisterNUICallback('updateContact', function(data, cb)
  TriggerServerEvent('gksphone:updateContact', data.id, data.display, data.phoneNumber, data.avatar)
end)
RegisterNUICallback('avatarChange', function(data, cb)
  TriggerServerEvent('gksphone:avatarChange', data.avatar_url)
end)
RegisterNUICallback('deleteContact', function(data, cb)
  TriggerServerEvent('gksphone:deleteContact', data.id)
end)
RegisterNUICallback('getContacts', function(data, cb)
  cb(json.encode(contacts))
end)
RegisterNUICallback('setGPS', function(data, cb)
  SetNewWaypoint(tonumber(data.x), tonumber(data.y))
  TriggerEvent('gksphone:notifi', {title = 'GPS', message = 'GPS Location has been set', img= '/html/static/img/icons/maps.png' })
  cb()
end)
RegisterNUICallback('getPhoneAvatar', function(data, cb)
  ESX.TriggerServerCallback('gksphone:getAvatar', function(avatarr)
    SendNUIMessage({event = 'phone_avatar', avatarr = avatarr})
  end)
end)


RegisterNUICallback('callEvent', function(data, cb)
  local eventName = data.eventName or ''
  if string.match(eventName, 'gksphone') then
    if data.data ~= nil then 
      TriggerEvent(data.eventName, data.data)
    else
      TriggerEvent(data.eventName)
    end
  else
    print('Event not allowed')
  end
  cb()
end)

RegisterNUICallback('deleteALL', function(data, cb)
  TriggerServerEvent('gksphone:deleteALL')
  cb()
end)

RegisterNUICallback('faketakestop', function(data, cb)
  takePhoto = false
  SetNuiFocus(true, true)
  TriggerEvent('gksphone:disableControlActions', true)
	DestroyMobilePhone()
	CellCamActivate(false, false)
  TriggerEvent('camera:stop', false)
  PhonePlayIn()
end)

RegisterNetEvent('gksphone:faketakestop')
AddEventHandler('gksphone:faketakestop', function()

  takePhoto = false
	DestroyMobilePhone()
	CellCamActivate(false, false)
  TriggerEvent('camera:stop', false)

end)

RegisterNUICallback('faketakePhoto', function(data, cb)
  takePhoto = true
  TriggerEvent('gksphone:disableControlActions', false)
  SetNuiFocus(true, false)
  TriggerEvent('camera:open')
end)



----------------------------------
---------- GESTION APPEL ---------
----------------------------------
RegisterNUICallback('appelsDeleteHistorique', function (data, cb)
  appelsDeleteHistorique(data.numero)
  cb()
end)
RegisterNUICallback('appelsDeleteAllHistorique', function (data, cb)
  appelsDeleteAllHistorique(data.infoCall)
  cb()
end)


----------------------------------
---------- GESTION VIA WEBRTC ----
----------------------------------


RegisterNUICallback('setIgnoreFocus', function (data, cb)
  ignoreFocus = data.ignoreFocus
  if ignoreFocus == true then
    TriggerEvent('gksphone:disableControlActions', false)
  end
  if ignoreFocus == false then
    TriggerEvent('gksphone:disableControlActions', true)
  end
  cb()
end)



--## FLIGHT MODE ## --

RegisterNUICallback("flightmode", function(data, cb)
	if data then
		flightmode = true
	else
		flightmode = false
	end
	
end)


--## FLASHLIGHT ## --
RegisterNUICallback('FlashLighttt', function(data)

  if data then
    flas = true
    TriggerEvent('gksphone:disableControlActions', false)
  else
    flas = false
    TriggerEvent('gksphone:disableControlActions', true)
  end

end)

CreateThread(function()
  while true do
      if flas or ignoreFocus then
          Wait(0)
          DisableControlAction(0, 0, true)    -- Next Camera
         -- DisableControlAction(0, 1, true)    -- Look Left/Right
         -- DisableControlAction(0, 2, true)    -- Look up/Down
          DisableControlAction(0, 16, true)   -- Next Weapon
          DisableControlAction(0, 17, true)   -- Select Previous Weapon
          DisableControlAction(0, 22, true)   -- Jump
          DisableControlAction(0, 24, true)   -- Attack
          DisableControlAction(0, 25, true)   -- Aim
          DisableControlAction(0, 26, true)   -- Look Behind
          DisableControlAction(0, 36, true)   -- Input Duck/Sneak
          DisableControlAction(0, 37, true)   -- Weapon Wheel
          DisableControlAction(0, 44, true)   -- Cover
          DisableControlAction(0, 45, true)   -- Cover
          DisableControlAction(0, 223, true)   -- Attack
          DisableControlAction(0, 229, true)   -- Attack    
          DisableControlAction(0, 237, true)   -- Attack            
       --   DisableControlAction(0, 245, true)  -- Chat
          DisableControlAction(0, 257, true)   -- Attack    
          DisableControlAction(0, 329, true)   -- Attack
          DisableControlAction(0, 346, true)   -- Attack  

          DisableControlAction(0, 289, true) -- Inventory
          DisableControlAction(0, 311, true) -- Inventory
          DisableControlAction(0, 303, true) -- Inventory
          DisableControlAction(0, 182, true) -- Inventory
      else
          Wait(200)
      end
  end
end)

function RotAnglesToVec(rot)
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end

local letSleep = true
CreateThread(function()
	while true do
		Citizen.Wait(5)
		if flas then
      letSleep = false
      local coords = GetEntityCoords(PlayerPedId())
      local kierunek = GetEntityRotation(PlayerPedId())
      local vec = RotAnglesToVec(kierunek)
      DrawSpotLight(coords.x,coords.y,coords.z,vec.x,vec.y,vec.z,255,255,255,20.0,8.0,10.0,15.0,50.0)	
    else
      letSleep = true	
		end
		if letSleep then Citizen.Wait(1000) end
	end
end)

AddEventHandler('onClientResourceStart', function(res)
  DoScreenFadeIn(300)
  if res == "gksphone" then
    Citizen.Wait(2000)
    TriggerServerEvent('gksphone:playerLoad', GetPlayerServerId(PlayerId()))
  end
end)



