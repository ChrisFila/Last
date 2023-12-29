Map = {

        {name="Salon de Tatouage",color=1, id=75,ZoneBlip = false, Position = vector3(-1153.9765625,-1425.6508789063,4.9544591903687)},

        {name="~r~Entreprise ~r~|~w~ Concessionnaire Voitures",color=0, id=227,ZoneBlip = false, Position = vector3(-33.777, -1102.021, 25.422)},
        {name="~r~Entreprise |~w~ Bahamas",color=7, id=279,ZoneBlip = false, Position = vector3(-1391.3, -583.31, 30.23)},
        {name="~r~Entreprise |~w~ Vanilla Unicorn",color=8, id=121,ZoneBlip = false, Position = vector3(133.4, -1306.14, 29.15)},
        {name="~r~Entreprise |~w~ Vigneron",color=19, id=85,ZoneBlip = false, Position = vector3(-1912.21, 2073.41, 140.39)},
        {name="~r~Entreprise |~w~ Benny\'s",color=5, id=446,ZoneBlip = false, Position = vector3(-204.08, -1331.11, 34.89)},
        {name = "~r~Entreprise ~r~|~s~ Uber Eat", color = 2, id = 616, ZoneBlip = false, Position = vector3(45.0, -1000, 29.5)},
        {name = "~r~Entreprise ~r~|~s~ Burgershot", color = 6, id = 536, ZoneBlip = false, Position = vector3(-1193.72, -892.76, 14)},
        {name = "~r~Entreprise ~r~|~s~ Galaxy Club", color = 7, id = 304, ZoneBlip = false, Position = vector3(353.46, 299.16, 104.04)},
        {name = "~r~Entreprise ~r~|~s~ Tequila-la", color = 5, id = 93, ZoneBlip = false, Position = vector3(-564.13, 273.89, 83.02)},
        {name="~r~Entreprise |~w~ LS Custom",color=5, id=446,ZoneBlip = false, Position = vector3(-332.49, -128.04, 39.01)},

        {name="~r~Etat ~s~| Hôpital",color=24, id=403,ZoneBlip = true, Position = vector3(299.1196, -598.35, 43.284)},
        {name="~r~Etat ~s~| Gouvernement",color=0, id=419,ZoneBlip = false, Position = vector3(-546.73553, -202.9565, 47.41)},
        {name="~r~Etat ~r~|~s~ Poste de police [LSPD]",color=53, id=60,ZoneBlip = true, Position = vector3(438.79, -981.99, 30.69)},
        {name="~r~Etat ~r~|~s~ Poste de police [LSSD]",color=25, id=60,ZoneBlip = false, Position = vector3(364.0, -1607.32, 29.29)},

        {name="~g~Interim |~w~ Chantier",color=44, id=566,ZoneBlip = false, Position = vector3(-509.94, -1001.59, 22.55)},
        {name="~g~Interim |~w~ Mine",color=70, id=477,ZoneBlip = false, Position = vector3(2831.689, 2798.311, 56.49803)},
        {name="~g~Interim |~w~ Orange",color=47, id=12,ZoneBlip = false, Position = vector3(2304.62, 5035.64, 44.23)},
        {name="~g~Interim |~w~ Bucheron",color=21, id=477,ZoneBlip = false, Position = vector3(-570.853, 5367.214, 70.21643)},

    }

    --{name="",color=0, id=419,ZoneBlip = false, Position = vector3()},
    
    Citizen.CreateThread(function()
        for k,v in pairs(Map) do
            local blip = AddBlipForCoord(v.Position) 
            SetBlipSprite (blip, v.id)
            SetBlipDisplay(blip, 6)
            SetBlipScale  (blip, 0.6)
            SetBlipColour (blip, v.color)
            SetBlipAsShortRange(blip, true)
              BeginTextCommandSetBlipName("STRING") 
              AddTextComponentString(v.name)
            EndTextCommandSetBlipName(blip)
            if v.ZoneBlip then
                local zoneblip = AddBlipForRadius(v.Position, 800.0)
            SetBlipSprite(zoneblip,1)
            SetBlipColour(zoneblip, v.color)
            SetBlipAlpha(zoneblip,100)
            end
        end
    end)