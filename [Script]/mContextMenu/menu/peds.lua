function _Peds()
    Action_Config = {
        Peds = {
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = false,
                CloseOnClick = false,
                Label = ("ID : %s"):format(LastEntityHit or "Inconnu"),
                OnClick = function()end,
            },
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = false,
                CloseOnClick = true,
                OnClick = function()
                    DeleteEntity(LastEntityHit)
                end,
                Label = "Supprimer",
            },
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = false,
                CloseOnClick = true,
                OnClick = function()
                    Target:MouveEntity(LastEntityHit)
                end,
                Label = "Déplacé",
            },
            {
                Type = "buttom",
                IsRestricted = true,
                Blocked = false,
                CloseOnClick = false,
                OnClick = function()
                    model = GetEntityModel(LastEntityHit)
                    SetPlayerModel(PlayerId(), model)
                    SetPedDefaultComponentVariation(PlayerPedId())
                end,
                Label = "Prendre l'aparence",
            },
            {
                Type = "buttom",
                Label = "Téléporté sur lui",
                CloseOnClick = false,
                Blocked = false,
                IsRestricted = true,
                OnClick = function()
                    SetEntityCoords(PlayerPedId(), GetEntityCoords(LastEntityHit))
                end,
            },
            {
                Type = "buttom",
                Label = "Téléporté à moi",
                Blocked = false,
                CloseOnClick = false,
                IsRestricted = true,
                OnClick = function()
                    SetEntityCoords(LastEntityHit, GetEntityCoords(PlayerPedId()))
                end,
            },
            {
                Type = "buttom",
                Label = "Apaiser",
                Blocked = false,
                CloseOnClick = false,
                IsRestricted = true,
                OnClick = function()
                    ClearPedTasksImmediately(LastEntityHit)
                end,
            },
            {
                Type = "buttom",
                Label = "Changer la tenue",
                Blocked = false,
                CloseOnClick = false,
                IsRestricted = true,
                OnClick = function()
                    SetPedRandomComponentVariation(LastEntityHit, true)
                end,
            },
            {
                Type = "buttom",
                Label = "Faire fuir",
                Blocked = false,
                CloseOnClick = false,
                IsRestricted = true,
                OnClick = function()
                    TaskSmartFleePed(LastEntityHit, PlayerPedId(), 100.0, -1, false, false)
                end,
            },
            {
                Type = "buttom",
                Label = "Rendre invincible",
                Blocked = false,
                CloseOnClick = false,
                IsRestricted = true,
                OnClick = function()
                    SetEntityInvincible(LastEntityHit, true)
                end,
            },
            {
                Type = "buttom",
                Label = "Rendre immobile",
                Blocked = false,
                CloseOnClick = false,
                IsRestricted = true,
                OnClick = function()
                    FreezeEntityPosition(LastEntityHit, true)
                end,
            },
            {
                Type = "buttom",
                Label = "Rendre mobile",
                Blocked = false,
                CloseOnClick = false,
                IsRestricted = true,
                OnClick = function()
                    FreezeEntityPosition(LastEntityHit, false)
                end,
            },
            {
                Type = "buttom-submenu",
                Label = "Animations",
                Blocked = false,
                IsRestricted = false,
                CloseOnClick = true,
                Action = {
                    {
                        'Donner une claque',
                        function()
                            pram = {
                                ['Requester'] = {
                                    ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'plyr_takedown_front_slap', ['Flags'] = 0,
                                },
                                ['Accepter'] = {
                                    ['Type'] = 'animation', ['Dict'] = 'melee@unarmed@streamed_variations', ['Anim'] = 'victim_takedown_front_slap', ['Flags'] = 0, ['Attach'] = {
                                        ['Bone'] = 9816,
                                        ['xP'] = 0.05,
                                        ['yP'] = 1.15,
                                        ['zP'] = -0.05,
                                    
                                        ['xR'] = 0.0,
                                        ['yR'] = 0.0,
                                        ['zR'] = 180.0,
                                    }
                                }
                            }
                            ClearPedTasksImmediately(LastEntityHit)
                            ClearPedTasksImmediately(PlayerPedId())
                            RequestAnimDict(pram['Requester']['Dict'])
                            while not HasAnimDictLoaded(pram['Requester']['Dict']) do
                                print("Chargement de l'animation en cours...")
                                Citizen.Wait(0)
                            end
                            AttachEntityToEntity(PlayerPedId(), LastEntityHit, GetPedBoneIndex(LastEntityHit, pram['Accepter']['Attach']['Bone']), pram['Accepter']['Attach']['xP'], pram['Accepter']['Attach']['yP'], pram['Accepter']['Attach']['zP'], pram['Accepter']['Attach']['xR'], pram['Accepter']['Attach']['yR'], pram['Accepter']['Attach']['zR'], true, true, false, true, 1, true)
                            TaskPlayAnim(PlayerPedId(), pram['Requester']['Dict'], pram['Requester']['Anim'], 8.0, -8.0, -1, pram['Requester']['Flags'], 0, false, false, false)
                            TaskPlayAnim(LastEntityHit, pram['Accepter']['Dict'], pram['Accepter']['Anim'], 8.0, -8.0, -1, pram['Accepter']['Flags'], 0, false, false, false)
                            Citizen.Wait(1000)
                            while IsEntityPlayingAnim(PlayerPedId(), pram['Requester']['Dict'], pram['Requester']['Anim'], 3) do
                                Citizen.Wait(0)
                            end
                            DetachEntity(PlayerPedId(), true, false)
                            ClearPedTasksImmediately(LastEntityHit)
                            ClearPedTasksImmediately(PlayerPedId())
                        end,
                    },
                    {
                        'Serrer la main',
                        function()
                            pram = {
                                ['Requester'] = {
                                    ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_a', ['Flags'] = 0,
                                },
                                ['Accepter'] = {
                                    ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_b', ['Flags'] = 0, ['Attach'] = {
                                        ['Bone'] = 9816,
                                        ['xP'] = 0.075,
                                        ['yP'] = 1.0,
                                        ['zP'] = 0.0,
                        
                                        ['xR'] = 0.0,
                                        ['yR'] = 0.0,
                                        ['zR'] = 180.0,
                                    }
                                }
                            }
                            ClearPedTasksImmediately(LastEntityHit)
                            ClearPedTasksImmediately(PlayerPedId())
                            RequestAnimDict(pram['Requester']['Dict'])
                            while not HasAnimDictLoaded(pram['Requester']['Dict']) do
                                print("Chargement de l'animation en cours...")
                                Citizen.Wait(0)
                            end
                            AttachEntityToEntity(PlayerPedId(), LastEntityHit, GetPedBoneIndex(LastEntityHit, pram['Accepter']['Attach']['Bone']), pram['Accepter']['Attach']['xP'], pram['Accepter']['Attach']['yP'], pram['Accepter']['Attach']['zP'], pram['Accepter']['Attach']['xR'], pram['Accepter']['Attach']['yR'], pram['Accepter']['Attach']['zR'], true, true, false, true, 1, true)
                            TaskPlayAnim(PlayerPedId(), pram['Requester']['Dict'], pram['Requester']['Anim'], 8.0, -8.0, -1, pram['Requester']['Flags'], 0, false, false, false)
                            TaskPlayAnim(LastEntityHit, pram['Accepter']['Dict'], pram['Accepter']['Anim'], 8.0, -8.0, -1, pram['Accepter']['Flags'], 0, false, false, false)
                            Citizen.Wait(1000)
                            while IsEntityPlayingAnim(PlayerPedId(), pram['Requester']['Dict'], pram['Requester']['Anim'], 3) do
                                Citizen.Wait(0)
                            end
                            DetachEntity(PlayerPedId(), true, false)
                            ClearPedTasksImmediately(LastEntityHit)
                            ClearPedTasksImmediately(PlayerPedId())
                        end,
                    },

                },
            },
        },
    }
end