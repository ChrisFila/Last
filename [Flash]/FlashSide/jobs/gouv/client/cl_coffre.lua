local mainMenu = RageUI.CreateMenu("", "Quel actions voulez vous faire")
local PutMenu = RageUI.CreateSubMenu(mainMenu,"", "Choisissez l'objet à déposer")
local GetMenu = RageUI.CreateSubMenu(mainMenu,"", "Choisissez l'objet à prendre")

local open = false

mainMenu:DisplayGlare(false)
mainMenu.Closed = function()
    open = false
end

all_items = {}

    
function OpenChestGouv() 
    if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
        RageUI.IsVisible(mainMenu, function()


            RageUI.Button("Prendre un objet", " ", {RightLabel = "→"}, true, {onSelected = function()
                getStockGouv()
            end},GetMenu);

            RageUI.Button("Déposer un objet", " ", {RightLabel = "→"}, true, {onSelected = function()
                getInventoryGouv()
            end},PutMenu);
            

        end)

        RageUI.IsVisible(GetMenu, function()
            
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, " ", {RightLabel = "~r~x"..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput('', '','', 100)
                    count = tonumber(count)
                    if count <= v.nb then
                        TriggerServerEvent("gouv:takeStockItems",v.item, count)
                    else
                        ESX.ShowNotification("~r~Vous n'en avez pas assez sur vous")
                    end
                    getStockGouv()
                end});
            end

        end)

        RageUI.IsVisible(PutMenu, function()
            
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, " ", {RightLabel = "~r~x"..v.nb}, true, {onSelected = function()
                    local count = KeyboardInput('', '','', 100)
                    count = tonumber(count)
                    TriggerServerEvent("gouv:putStockItems",v.item, count)
                    getInventoryGouv()
                end});
            end
            

       end)


        Wait(0)
    end
 end)
 end
 end


