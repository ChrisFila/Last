
personal = {
    pedId = function()
        return PlayerPedId()
    end,

    headingped = function()
        return GetEntityHeading(personal.pedId())
    end
}

local PlayerProps = {}

Sotek = {
	pointing = false,
	handsUp = false,
	crouched = false
}

local mainMenu = RageUI.CreateMenu("", "~r~Animation")

local walk = RageUI.CreateSubMenu(mainMenu, "", "~r~Démarches")
local sexe = RageUI.CreateSubMenu(mainMenu, " ", "~r~+21")
local danse = RageUI.CreateSubMenu(mainMenu, " ", "~r~Danses")
local poses = RageUI.CreateSubMenu(mainMenu,"","~r~Poses")
local sit = RageUI.CreateSubMenu(mainMenu,"","~r~S'asseoir/Tomber")
local works = RageUI.CreateSubMenu(mainMenu,"","~r~Métier")
local gang = RageUI.CreateSubMenu(mainMenu,"","~r~Gang")
local sport = RageUI.CreateSubMenu(mainMenu,"","~r~Sport")
local frap = RageUI.CreateSubMenu(mainMenu,'', "~r~ Frapper ") 
local actions = RageUI.CreateSubMenu(mainMenu,'', "~r~ Actions ") 
local salue = RageUI.CreateSubMenu(mainMenu,"", "~r~Salue")
local props = RageUI.CreateSubMenu(mainMenu , "", "~r~Emote disponible")


function OpenMenu()
	if open then
		open = false
		
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true
		RageUI.Visible(mainMenu, true)
		Citizen.CreateThread(function()
			while open do
				RageUI.IsVisible(mainMenu, function()

                    RageUI.Button("Annuler l'emote", false, {}, true , {
                        onSelected= function()
                            Ptfx = false
                            local ped = GetPlayerPed(-1)
                            if ped then
                                DestroyAllProps()
                                ClearPedTasksImmediately(ped);
                                ResetPedMovementClipset(PlayerPedId())
                            end
                        end
                    })
                    RageUI.Button("Emotes avec objet", false, {RightLabel = ">"}, true , {}, props)
                    RageUI.Button("Les démarches", false , {RightLabel = ">"} , true , {}, walk)
                    RageUI.Button("Danses", false , {RightLabel = ">"} , true , {}, danse)
                    RageUI.Button("Action", false , {RightLabel = ">"} , true , {}, actions)
                    RageUI.Button("Salue", false , {RightLabel = ">"} , true , {}, salue)
                    RageUI.Button("S'asseoir/Tomber", false , {RightLabel = ">"} , true , {}, sit)
                    RageUI.Button("Poses", false , {RightLabel = ">"} , true , {}, poses)
                    RageUI.Button("Frapper", false , {RightLabel = ">"} , true , {}, frap)
                    RageUI.Button("Sport", false , {RightLabel = ">"} , true , {}, sport)
                    RageUI.Button("Métier", false , {RightLabel = ">"} , true , {}, works)
                    RageUI.Button("Gang", false , {RightLabel = ">"} , true , {}, gang)
                    RageUI.Button("+21", false , {RightLabel = ">"} , true , {}, sexe)

				end)

            RageUI.IsVisible(props,function()
                for kCat, vCat in pairs(PropsEmote) do
                    for k, v in pairs(vCat.simple) do
                        if v.name == "Faite pleuvoir" or v.name == "Caméra" or v.name  == "Spray au champagne"then 
                        
                            renderanimonePtfs(v.name,v.command ,v.value, v.anim,v.loop,v.Prop,v.PropBone, v.PropPlacement,v.PtfxName,v.PtfxAsset,v.PtfxPlacement)
                        else
                            
                            renderanimoneprops(v.name,v.command ,v.value, v.anim,v.loop,v.Prop,v.PropBone, v.PropPlacement)
                        end
                    end
                end
            end)
            RageUI.IsVisible(sexe,function()
                for k, v in pairs(Sexe) do
                    renderanim(v.name,v.command ,v.value, v.anim,v.loop)
                end
            end)
            RageUI.IsVisible(walk,function()
                for k, v in pairs(Walk) do
                    renderwalk(v.label,v.value)
                end

            end)
            RageUI.IsVisible(actions,function()
                for kCat, vCat in pairs(Actions) do
                    RageUI.Separator(vCat.type)
                    for vAct, vAct in pairs(vCat.actions) do
                        if vAct.Prop ~= nil then
                            renderanimoneprops(vAct.name,vAct.command ,vAct.value, vAct.anim,vAct.loop,vAct.Prop,vAct.PropBone,vAct.PropPlacement)
                        else
                            renderanim(vAct.name,vAct.command, vAct.value,vAct.anim, vAct.loop)
                        end
                    end
                end
            end)
            RageUI.IsVisible(salue,function()
                for kCat, vCat in pairs(Salue) do
                    RageUI.Separator(vCat.type)
                    for vSal, vSal in pairs(vCat.salue) do
                        renderanim(vSal.name,vSal.command,vSal.value,vSal.anim, vSal.loop)
                    end
                end
            end)
            RageUI.IsVisible(frap,function()
                for kCat, vCat in pairs(Frapper) do
                    RageUI.Separator(vCat.type)
                    for vFrap, vFrap in pairs(vCat.frapper) do
                        renderanim(vFrap.name,vFrap.command,vFrap.value,vFrap.anim, vFrap.loop)
                    end
                end
            end)
            RageUI.IsVisible(danse,function()
                for kCat, vCat in pairs(Musique) do
                    RageUI.Separator(vCat.Inst)

                    for kInstr, vInstr in pairs(vCat.instruments) do
                        if vInstr.name == "Guitare" or vInstr.name == "Guitare 2" or vInstr.name == "Guitare électrique" or vInstr.name == "Guitare électrique 2" then 
                            renderanimoneprops(vInstr.name,vInstr.command ,vInstr.value, vInstr.anim,vInstr.loop,vInstr.Prop,vInstr.PropBone,vInstr.PropPlacement)

                        else
                            renderanim(vInstr.name,vInstr.command,vInstr.value,vInstr.anim, vInstr.loop)
                        end
                    end
                    RageUI.Separator(vCat.type)
                    for kDanse, vDanse in pairs(vCat.danses) do
                        renderanim(vDanse.name,vDanse.command,vDanse.value,vDanse.anim, vDanse.loop)
                    end
                    RageUI.Separator(vCat.type2)
                    for kDanse, vDanse in pairs(vCat.dansesf) do
                        renderanim(vDanse.name,vDanse.command,vDanse.value,vDanse.anim, vDanse.loop)
                    end
                    RageUI.Separator(vCat.type10)
                    for kDanseH, vDanseH in pairs(vCat.horseDanse) do
                        renderanimoneprops(vDanseH.name,vDanseH.command ,vDanseH.value, vDanseH.anim,vDanseH.loop,vDanseH.Prop,vDanseH.PropBone,vDanseH.PropPlacement)
                    end
                    RageUI.Separator(vCat.type11)
                    for kDanseGl, vDanseGl in pairs(vCat.glowstickdanse) do
                        renderanimtwoprops(vDanseGl.name,vDanseGl.command ,vDanseGl.value, vDanseGl.anim,vDanseGl.loop,vDanseGl.Prop,vDanseGl.PropBone,vDanseGl.PropPlacement,vDanseGl.SecondProp,vDanseGl.SecondPropBone,vDanseGl.SecondPropPlacement)
                    end
                    RageUI.Separator(vCat.type3)
                    for kDanselente, vDanselente in pairs(vCat.danseslente) do
                        renderanim(vDanselente.name,vDanselente.command,vDanselente.value,vDanselente.anim, vDanselente.loop)
                    end
                    RageUI.Separator(vCat.type4)
                    for kDanseidiot, vDanseidiot in pairs(vCat.dansesidiot) do
                        renderanim(vDanseidiot.name,vDanseidiot.command,vDanseidiot.value,vDanseidiot.anim, vDanseidiot.loop)
                    end
                    RageUI.Separator(vCat.type5)
                    for kDansetimide, vDansetimide in pairs(vCat.dansestimide) do
                        renderanim(vDansetimide.name,vDansetimide.command,vDansetimide.value,vDansetimide.anim, vDansetimide.loop)
                    end
                    RageUI.Separator(vCat.type6)
                    for kDansehaut,vDansehaut in pairs(vCat.danseshaut) do 
                        renderanim(vDansehaut.name,vDansehaut.command,vDansehaut.value,vDansehaut.anim,vDansehaut.loop)
                    end
                end
            end)
            RageUI.IsVisible(poses,function()
                for kCat, vCat in pairs(Poses) do
                    RageUI.Separator(vCat.type)
                    for kBC, vBC in pairs(vCat.brascroise) do
                        renderanim(vBC.name,vBC.command,vBC.value,vBC.anim,vBC.loop)
                    end
                    RageUI.Separator(vCat.type2)
                    for kIna, vIna in pairs(vCat.inactif) do
                        renderanim(vIna.name,vIna.command,vIna.value,vIna.anim,vIna.loop)
                    end
                    RageUI.Separator(vCat.type3)
                    for kWait, vWait in pairs(vCat.wait) do
                        renderanim(vWait.name,vWait.command,vWait.value,vWait.anim,vWait.loop)
                    end
                    RageUI.Separator(vCat.type4)
                    for kPens, vPens in pairs(vCat.penser) do
                        renderanim(vPens.name,vPens.command,vPens.value,vPens.anim,vPens.loop)
                    end
                    
                    RageUI.Separator(vCat.type40)
                    for kP, vP in pairs(vCat.ppp) do
                        renderanim(vP.name,vP.command,vP.value,vP.anim,vP.loop)
                    end
                end
            end)
            RageUI.IsVisible(sit,function()
                for kCat, vCat in pairs(Sits) do
                    RageUI.Separator(vCat.type)
                    for kSit, vSit in pairs(vCat.sits) do
                        if vSit.name == "S'asseoir sur une chaise " then 
                            renderscenario(vSit.name,vSit.command,vSit.scenario)
                        else
                            renderanim(vSit.name,vSit.command,vSit.value,vSit.anim,vSit.loop)
                        end
                    end
                    RageUI.Separator(vCat.type2)
                    for kFall, vFall in pairs(vCat.tomber) do
                        renderanim(vFall.name,vFall.command,vFall.value,vFall.anim,vFall.loop)
                    end
                end
            end)
            RageUI.IsVisible(works,function()
                for kCat, vCat in pairs(Works) do
                    RageUI.Separator(vCat.type)
                    for kCops, vCops in pairs(vCat.cops) do
                        if vCops.name == "Mains sur la ceinture"  then
                            renderscenario2(vCops.name,vCops.command,vCops.scenario)
                        elseif vCops.name == "Circulation" then 
                            renderscenario2(vCops.name,vCops.command,vCops.scenario)
                        elseif vCops.name == "Garde" then 
                            renderscenario2(vCops.name,vCops.command,vCops.scenario)
                        elseif vCops.name == "Balise de flic" then 
                            renderscenario2(vCops.name,vCops.command,vCops.scenario)
                        elseif vCops.name == "Presse-papiers"  then 
                            renderscenario2(vCops.name,vCops.command,vCops.scenario)
                        elseif vCops.name == "Jumelle" then
                            renderscenario2(vCops.name,vCops.command,vCops.scenario) 
                        elseif vCops.name == "Presse-papiers 2" then 
                            renderanimoneprops(vCops.name,vCops.command ,vCops.value, vCops.anim,vCops.loop,vCops.Prop,vCops.PropBone, vCops.PropPlacement)
                        elseif vCops.name == "Bloc-notes" then 
                            renderanimtwoprops(vCops.name,vCops.command ,vCops.value, vCops.anim,vCops.loop,vCops.Prop,vCops.PropBone, vCops.PropPlacement, vCops.SecondProp,vCops.SecondPropBone,vCops.SecondPropPlacement)
                        else
                            renderanim(vCops.name,vCops.command,vCops.value,vCops.anim,vCops.loop)
                        end
                    end
                    RageUI.Separator(vCat.type2)
                    for kMeca, vMeca in pairs(vCat.mechanic) do
                        if vMeca.name == "Nettoyer" then 
                            renderanimoneprops(vMeca.name,vMeca.command ,vMeca.value, vMeca.anim,vMeca.loop,vMeca.Prop,vMeca.PropBone, vMeca.PropPlacement)

                        elseif vMeca.name == "Nettoyer 2" then 
                            renderanimoneprops(vMeca.name,vMeca.command ,vMeca.value, vMeca.anim,vMeca.loop,vMeca.Prop,vMeca.PropBone, vMeca.PropPlacement)
                        else
                            renderanim(vMeca.name,vMeca.command,vMeca.value,vMeca.anim,vMeca.loop)
                        end
                    end
                    RageUI.Separator(vCat.type3)
                    for kEms, vEms in pairs(vCat.ems) do
                        renderanim(vEms.name,vEms.command,vEms.value,vEms.anim,vEms.loop)
                    end
                    RageUI.Separator(vCat.type4)
                    for kDj, vDj in pairs(vCat.dj) do
                        renderanim(vDj.name,vDj.command,vDj.value,vDj.anim,vDj.loop)
                    end
                end
            end)

            RageUI.IsVisible(gang,function()					
                for kCat, vCat in pairs(Gang) do
                    RageUI.Separator(vCat.type)
                    for kGang, vGang in pairs(vCat.gang) do
                        renderanim(vGang.name,vGang.command,vGang.value,vGang.anim,vGang.loop)
                    end
                end
            end)
            RageUI.IsVisible(sport,function()			
                for kCat, vCat in pairs(Sport) do
                    RageUI.Separator(vCat.type)
                    for kBoxe, vBoxe in pairs(vCat.box) do
                        renderanim(vBoxe.name,vBoxe.command,vBoxe.value,vBoxe.anim,vBoxe.loop)
                    end
                    RageUI.Separator(vCat.type4)
                    for kTK, vTK in pairs(vCat.karate) do
                        renderanim(vTK.name,vTK.command,vTK.value,vTK.anim,vTK.loop)
                    end
                    RageUI.Separator(vCat.type2)
                    for kGolf, vGolf in pairs(vCat.golf) do
                        renderanim(vGolf.name,vGolf.command,vGolf.value,vGolf.anim,vGolf.loop)
                    end
                    RageUI.Separator(vCat.type3)
                    for kJog, vJog in pairs(vCat.jog) do
                        if vJog.name == "Jogging" then 
                            renderscenario2(vJog.name,vJog.command,vJog.scenario)
                        else
                            renderanim(vJog.name,vJog.command,vJog.value,vJog.anim,vJog.loop)
                        end
                    end
                    RageUI.Separator(vCat.type10)
                    for kEti, vEti in pairs(vCat.etirement) do
                        renderanim(vEti.name,vEti.command,vEti.value,vEti.anim,vEti.loop)
                    end

                end
            end)
            Wait(0)
            end
        end)
    end
end

--Bouton pour les anims
function renderanim(label,desc, value, anim,loop)
    RageUI.Button(label, "/e ~r~"..desc, {RightLabel = ""}, true, {
        onSelected = function()
            DestroyAllProps()
            Sotek.handsUp = false

            startAnim(value, anim,loop)
        end
    })
end

function renderanimoneprops(label,desc, value, anim,loop, name,bone,PropPlacement)
    RageUI.Button(label, "/e ~r~"..desc, {RightLabel = "(props)"}, true, {
        onSelected = function()
            DestroyAllProps()
            Sotek.handsUp = false

            local PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(PropPlacement)
            
            AddPropToPlayer(name, bone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 )
            startAnim(value, anim,loop)
        end
    })
end

function renderanimtwoprops(label,desc, value, anim,loop, name,bone,PropPlacement,name2,bone2, SecondPlacement)
    RageUI.Button(label, "/e ~r~"..desc, {RightLabel = ""}, true, {
        onSelected = function()
            DestroyAllProps()
            Sotek.handsUp = false
            local PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(PropPlacement)
            local SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6 = table.unpack(SecondPlacement)
            AddPropToPlayer(name, bone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 )
            AddPropToPlayer(name2, bone2, SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6)

            startAnim(value, anim,loop)
        end
    })
end
function renderscenario(label,desc, anim)

RageUI.Button(label, "/e ~r~"..desc, {RightLabel = ""}, true, {
onSelected = function()
    DestroyAllProps()
    Sotek.handsUp = false
    startScenario(anim)
end
})
end


function renderscenario2(label,desc, anim)
RageUI.Button(label, "/e ~r~"..desc, {RightLabel = ""}, true, {
    onSelected = function()
        DestroyAllProps()
        startScenario2(anim)
    end
})
end

function renderanimonePtfs(label,desc, value, anim,loop, name,bone,PropPlacement, name3,asset,PtfxPlacement)
	RageUI.Button(label, "/e ~r~"..desc, {RightLabel = ""}, true, {
		onSelected = function()
			Ptfx = true	 	
			DestroyAllProps()
			ESX.ShowNotification('Appuyer  ~r~ G ~s~sur utiliser l\'attaque spécial.')
			Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, PtfxScale = table.unpack(PtfxPlacement)
			PtfxAsset = asset
			PtfxName = name3
			PtfxPrompt = true
			PtfxThis(PtfxAsset)
			PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(PropPlacement)
			AddPropToPlayer(name, bone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 )
			startAnim(value, anim,loop)
		end
	})
end

function PtfxStart()
    if PtfxNoProp then
      PtfxAt = PlayerPedId()
    else
      PtfxAt = prop
    end
    UseParticleFxAssetNextCall(PtfxAsset)
    Ptfx = StartNetworkedParticleFxLoopedOnEntityBone(PtfxName, PtfxAt, Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, GetEntityBoneIndexByName(PtfxName, "VFX"), 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)
    SetParticleFxLoopedColour(Ptfx, 1.0, 1.0, 1.0)
    table.insert(PlayerParticles, Ptfx)
end
function PtfxStop()
	for a,b in pairs(PlayerParticles) do
	  StopParticleFxLooped(b, false)
	  table.remove(PlayerParticles, a)
	end
end
function PtfxThis(asset)
	while not HasNamedPtfxAssetLoaded(asset) do
	  RequestNamedPtfxAsset(asset)
	  Wait(10)
	end
	UseParticleFxAssetNextCall(asset)
end

function FPtfx()
	Citizen.CreateThread(function()
		while Ptfx do	
		  if PtfxPrompt then
			if IsControlPressed(1, 47) then
			  PtfxStart()
			  Wait(300)
			  PtfxStop()
			end
		  end
		  Citizen.Wait(1)
		end
	end)
end

function renderwalk(label,value)
    RageUI.Button(label, false, {RightLabel = ""}, true, {
        onSelected = function()
            Sotek.handsUp = false
            startAttitude(value)
        end
    })
    end

    function LoadPropDict(model)
        while not HasModelLoaded(GetHashKey(model)) do
          RequestModel(GetHashKey(model))
          Wait(10)
        end
    end
      
    function DestroyAllProps()
        for _,v in pairs(PlayerProps) do
          DeleteEntity(v)
        end
        PlayerHasProp = false
    end
    function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
        local Player = personal.pedId()
        local x,y,z = table.unpack(GetEntityCoords(Player))
      
        if not HasModelLoaded(prop1) then
          LoadPropDict(prop1)
        end
      
        prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
        AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
        table.insert(PlayerProps, prop)
        PlayerHasProp = true
        SetModelAsNoLongerNeeded(prop1)
      end
    function startAttitude(anim)
        ESX.Streaming.RequestAnimSet(anim, function()
            SetPedMotionBlur(personal.pedId(), false)
            SetPedMovementClipset(personal.pedId(), anim, true)
            RemoveAnimSet(anim)
        end)
    end
    function startAnim(lib, anim,loop)
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 2.0, 2.0, 9999999999, loop, 0, false, false, false)
            end)
    end
    function startScenario(anim)
            PlayerPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5);
            TaskStartScenarioAtPosition(GetPlayerPed(-1), anim, PlayerPos['x'], PlayerPos['y'], PlayerPos['z'], GetEntityHeading(PlayerPedId()), 0, 1, false)
    end 
        
    function startScenario2(anim)
            TaskStartScenarioInPlace(GetPlayerPed(-1), anim, 0, true)
    end 

    function startPointing(plyPed)	
        ESX.Streaming.RequestAnimDict('anim@mp_point', function()
            SetPedConfigFlag(plyPed, 36, 1)
            TaskMoveNetworkByName(plyPed, 'task_mp_pointing', 0.5, 0, 'anim@mp_point', 24)
            RemoveAnimDict('anim@mp_point')
        end)
    end
    
    function stopPointing()
        local plyPed = personal.pedId()
        RequestTaskMoveNetworkStateTransition(plyPed, 'Stop')
    
        if not IsPedInjured(plyPed) then
            ClearPedSecondaryTask(plyPed)
        end
    
        SetPedConfigFlag(plyPed, 36, 0)
        ClearPedSecondaryTask(plyPed)
        pointing = false
    end
    
    function crouchandpointing(default)
        Citizen.CreateThread(function()
            while default do
                
                Citizen.Wait(100)
                if Sotek.crouched or Sotek.handsUp or Sotek.pointing then
                    if not IsPedOnFoot(PlayerPedId()) then
                        ResetPedMovementClipset(plyPed, 0)
                        stopPointing()
                        Sotek.crouched, Sotek.handsUp, Sotek.pointing = false, false, false
                    elseif Sotek.pointing then
                        local ped = PlayerPedId()
                        local camPitch = GetGameplayCamRelativePitch()
        
                        if camPitch < -70.0 then
                            camPitch = -70.0
                        elseif camPitch > 42.0 then
                            camPitch = 42.0
                        end
        
                        camPitch = (camPitch + 70.0) / 112.0
        
                        local camHeading = GetGameplayCamRelativeHeading()
                        local cosCamHeading = Cos(camHeading)
                        local sinCamHeading = Sin(camHeading)
        
                        if camHeading < -180.0 then
                            camHeading = -180.0
                        elseif camHeading > 180.0 then
                            camHeading = 180.0
                        end
        
                        camHeading = (camHeading + 180.0) / 360.0
                        local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                        local rayHandle, blocked = GetShapeTestResult(StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7))
        
                        SetTaskMoveNetworkSignalFloat(ped, 'Pitch', camPitch)
                        SetTaskMoveNetworkSignalFloat(ped, 'Heading', (camHeading * -1.0) + 1.0)
                        SetTaskMoveNetworkSignalBool(ped, 'isBlocked', blocked)
                        SetTaskMoveNetworkSignalBool(ped, 'isFirstPerson', N_0xee778f8c7e1142e2(N_0x19cafa3c87f7c2ff()) == 4)
                    end
                end
            end
        end)
    end
    AddEventHandler("ClearEmote", function()
        EmoteCancel()
    end)
    
    function EmoteCancel()
        PtfxPrompt = false
        PtfxStop()
        ClearPedTasks(GetPlayerPed(-1))
        DestroyAllProps()
        ResetPedMovementClipset(PlayerPedId())
    end

Keys.Register('K', 'K', 'Menu Animation', function()
	OpenMenu()
end)

Keys.Register('X', 'X', 'Annuler l\'emote', function()
	Ptfx = false
	local ped = GetPlayerPed(-1)

	if Sotek.handsUp then 
		ClearPedSecondaryTask(personal.pedId())
	else	
		DestroyAllProps()
		ClearPedTasks(ped);
		ResetPedMovementClipset(PlayerPedId())
		Ptfx = false

	end
	Ptfx = false
end)
Keys.Register('Y', 'Y', 'Lever les mains', function()
	local plyPed = personal.pedId()

	if (DoesEntityExist(plyPed)) and not (IsEntityDead(plyPed)) and (IsPedOnFoot(plyPed)) then
		if Sotek.pointing then
			Sotek.pointing = false
		end

		Sotek.handsUp = not Sotek.handsUp

		if Sotek.handsUp then
			ESX.Streaming.RequestAnimDict('random@mugging3', function()
				TaskPlayAnim(plyPed, 'random@mugging3', 'handsup_standing_base', 8.0, -8, -1, 49, 0, 0, 0, 0)
				RemoveAnimDict('random@mugging3')
			end)
		else
			ClearPedSecondaryTask(plyPed)
		end
	end
end)


Keys.Register('B', 'B', 'Pointer du doigt', function()
	local plyPed = personal.pedId()
	if (DoesEntityExist(plyPed)) and (not IsEntityDead(plyPed)) and (IsPedOnFoot(plyPed)) then
		if Sotek.handsUp then
			Sotek.handsUp = false
		end

		Sotek.pointing = not Sotek.pointing

		if Sotek.pointing then
			startPointing(plyPed)
			crouchandpointing(true)
		else
			stopPointing(plyPed)
			crouchandpointing(false)
		end
	end
end)

Keys.Register('LCONTROL', 'LCONTROL', 'S\'accroupir', function()
	local plyPed = PlayerPedId()
	DisableControlAction(1, 36, true)

	if (DoesEntityExist(plyPed)) and (not IsEntityDead(plyPed)) and (IsPedOnFoot(plyPed)) then
		Sotek.crouched = not Sotek.crouched

		if Sotek.crouched then 
			crouchandpointing(true)

			ESX.Streaming.RequestAnimSet('move_ped_crouched', function()
				SetPedMovementClipset(plyPed, 'move_ped_crouched', 0.25)
				RemoveAnimSet('move_ped_crouched')
			end)
		else
			crouchandpointing(false)
			ResetPedMovementClipset(plyPed, 0)
		end
	end
end)