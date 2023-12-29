local kmh = 3.6
local mph = 2.23693629
local carspeed = 0
driftmode = false -- on/off speed
local speed = kmh -- or mph
local drift_speed_limit = 150.0 

-- Thread
Citizen.CreateThread(function()
	while true do
		if IsPedInAnyVehicle(GetPed(), false) and driftmode then
			Citizen.Wait(1)
		else
			Wait(1500)
		end

		if driftmode then
			if IsPedInAnyVehicle(GetPed(), false) then
				CarSpeed = GetEntitySpeed(GetCar()) * speed
				if GetPedInVehicleSeat(GetCar(), -1) == GetPed() then
					if CarSpeed <= drift_speed_limit then  
						if IsControlPressed(1, 21) then
							SetVehicleReduceGrip(GetCar(), true)
						else
							SetVehicleReduceGrip(GetCar(), false)
						end
					end
				end
			end
		end
	end
end)


-- Function
function GetPed() return GetPlayerPed(-1) end
function GetCar() return GetVehiclePedIsIn(GetPlayerPed(-1),false) end