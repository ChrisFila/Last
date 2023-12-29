RegisterCommand('rec', function()
    OpenRockstarMenu()
end)

function OpenRockstarMenu()
    local menu = RageUI.CreateMenu("", "Rockstar Editor")

    RageUI.Visible(menu, not RageUI.Visible(menu))

    while menu do
        Wait(0)
        RageUI.IsVisible(menu, function()
        RageUI.Button('Lancer Record', nil, {}, true, {onSelected = function() 
            if IsRecording() then
                ESX.ShowNotification("You are already recording a clip, you need to stop recording first before you can start recording again!")
            else
                StartRecording(1)
            end  
        end});
        RageUI.Button('Stoper Record', nil, {}, true, {onSelected = function()  
            if not IsRecording() then
                ESX.ShowNotification("You are currently NOT recording a clip, you need to start recording first before you can stop and save a clip.")
            else
                StopRecordingAndSaveClip()
            end 
        end});

        end, function()
        end)

        if not RageUI.Visible(menu) then
            menu = RMenu:DeleteType('menu', true)
        end
    end
end