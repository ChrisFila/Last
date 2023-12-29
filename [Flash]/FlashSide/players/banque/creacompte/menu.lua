ESX = nil

CreateThread(function()
    while ESX == nil do 
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Wait(10)
    end
end)

local prenomInput, nameInput, DateInput = nil, nil, nil
local playerPed = PlayerPedId()

local open = false 
local cracompte = RageUI.CreateMenu('', 'CrÉer votre compte Bancaire')
cracompte.Display.Header = true
cracompte.Closed = function()
  open = false
end

local prenom,mdp,nom,dates = nil,nil,nil,nil
local infocomptes = RageUI.CreateMenu('', 'Information Compte Bancaire')
local cdmenus = RageUI.CreateSubMenu(infocomptes, "", "Choisir votre Carte Bancaire")
local persoinfo = RageUI.CreateSubMenu(infocomptes, "", "Information Personnelle")
local modiftype = RageUI.CreateSubMenu(infocomptes, "", "Modification sur le compte")
local mdpmodif = RageUI.CreateSubMenu(infocomptes, "", "Gestion du Mot de Passe")
local transac = RageUI.CreateSubMenu(infocomptes, "", "Historique des Transactions")
infocomptes.Display.Header = true
infocomptes.Closed = function()
  openinfo = false
end

function InfoCompte()
     if openinfo then 
        openinfo = false
        RageUI.Visible(infocomptes, false)
        return
     else
      openinfo = true 
         RageUI.Visible(infocomptes, true)
         CreateThread(function()
         while openinfo do 

          RageUI.IsVisible(infocomptes,function()


            RageUI.Button("Information du compte", nil, {RightLabel = "→→"}, true , {
              onSelected = function()
                myidentity = nil
                getidentitymec()
                mytypecompte = nil
                gettypecompte()
              end
            },persoinfo)
            RageUI.Button("Faire une demande de Carte Bancaire", nil, {RightLabel = "→→"}, true , {
              onSelected = function()
              end
            },cdmenus)
            RageUI.Button("Modification de niveau de compte", nil, {RightLabel = "→→"}, true , {
              onSelected = function()
              end
            },modiftype)
            RageUI.Button("Gestion du Mot de Passe", nil, {RightLabel = "→→"}, true , {
              onSelected = function()
              end
            },mdpmodif)
            RageUI.Button("Regarder les dernières Transactions", nil, {RightLabel = "→→"}, true , {
              onSelected = function()
              end
            },transac)
            RageUI.Button("~r~Supprimer mon compte bancaire", nil, {RightBadge = RageUI.BadgeStyle.Alert}, true , {
              onSelected = function()
                local deletecompte = KeyboardInput("delete", 'Voulez vous vraiment supprimer votre compte ? oui ou non', '', 20)
                if tostring(deletecompte) == nil then
                    return false
                else
                      if tostring(deletecompte) == "oui" then
                          TriggerServerEvent("BBanque:deletecompte")
                          ShowNotification("Demande de suppression de compte ~g~effectuée~s~.")
                          openinfo = false
                      elseif tostring(deletecompte) == "non" then
                          ShowNotification("Demande de suppression de compte ~r~annulée~s~.")
                      else
                          ShowNotification("Demande refusée, veuillez réponde par ~r~oui~s~ ou ~r~non~s~.")
                      end
                      prenom = (tostring(deletecompte))
                end
              end
            })
          end)

          RageUI.IsVisible(persoinfo,function()
            if myidentity then
                if mytypecompte then
                      RageUI.Button("Nom :", nil, {RightLabel = myidentity.nom}, true , {
                        onSelected = function()
                        end
                      })
                      RageUI.Button("Prénom :", nil, {RightLabel = myidentity.prenom}, true , {
                        onSelected = function()
                        end
                      })
                      RageUI.Button("Date de naissance :", nil, {RightLabel = myidentity.naissance}, true , {
                        onSelected = function()
                        end
                      })
                      RageUI.Button("Compte de Niveau :", nil, {RightLabel = mytypecompte.type}, true , {
                        onSelected = function()
                        end
                      })
                      if myidentity.statemotpasse == true then
                          RageUI.Button("Status Mot de Passe", nil, {RightLabel = "~g~Activé~s~"}, true , {
                            onSelected = function()
                            end
                          })
                      else
                          RageUI.Button("Status Mot de Passe", nil, {RightLabel = "~r~Désactivé~s~"}, true , {
                            onSelected = function()
                            end
                          })
                      end
                      RageUI.Button("Mot de Passe actuel", nil, {RightLabel = myidentity.motpasse}, true , {
                        onSelected = function()
                        end
                      })
                end
              end
          end)

          RageUI.IsVisible(mdpmodif,function()
                RageUI.Button("Activer le Mot de Passe", nil, {}, true , {
                  onSelected = function()
                    TriggerServerEvent("BBanque:activemdp", GetPlayerServerId(playerPed))
                    ShowNotification("~g~Le mot de passe est désormais actif.")
                  end
                })
                RageUI.Button("Désactiver le Mot de Passe", nil, {}, true , {
                  onSelected = function()
                    TriggerServerEvent("BBanque:desacmdp", GetPlayerServerId(playerPed))
                    ShowNotification("~r~Le mot de passe est désormais inactif.")
                  end
                })
                RageUI.Button("Changer de Mot de Passe", "Choisir votre Mot de Passe", {RightLabel = mdp}, true , {
                  onSelected = function()
                    local Mdpvali = KeyboardInput("mdpvd", 'Indiquez votre Mot de Passe', '', 5)
                    if Mdpvali ~= nil then
                        mdp = (tostring(Mdpvali))
                    end 
                  end
                })
                RageUI.Button("Valider le Mot de Passe", nil, {RightLabel = "→→", Color = {BackgroundColor = RageUI.ItemsColour.Blue}}, true , {
                  onSelected = function()
                    local Mdpvali = mdp
                
                    if not Mdpvali then
                        ShowNotification("Mot de Passe Invalide")
                    else
                        TriggerServerEvent("BBanque:setpassword", GetPlayerServerId(playerPed), Mdpvali)
                        ShowNotification("~g~Le mot de passe a été modifié avec succès.")
                        openinfo = false
                    end
                  end
                })
          end)

          RageUI.IsVisible(transac,function()
              if #bankTransaction > 0 then
                  RageUI.Button("~r~Effacer Toutes Les Transactions~s~", nil, {RightBadge = RageUI.BadgeStyle.Alert}, true , {
                    onSelected = function()
                      ClearTransaction() 
                    end
                  })
              end
              if #bankTransaction == 0 then
                  RageUI.Button("~r~Aucune Transaction~s~", nil, {}, true , {
                    onSelected = function()
                    end
                  })
              end
              for k,v in pairs(bankTransaction) do
                  RageUI.Button(v, nil, {}, true , {
                    onSelected = function()
                    end
                  })
              end
          end)

          RageUI.IsVisible(cdmenus,function()
              RageUI.Button("Carte Bancaire", "Acheter une Carte Bancaire", {RightLabel = "~g~250$~s~"}, true , {
                  onSelected = function()
                    TriggerServerEvent("BBanque:BuyCB")
                  end
              })
          end)

          RageUI.IsVisible(modiftype,function()
              RageUI.Button("Compte de Niveau 1", "Somme maximale : ~g~1000 $", {RightLabel = "~g~1250$~s~"}, true , {
                  onSelected = function()
                    TriggerServerEvent("BBanque:buycb1", GetPlayerServerId(playerPed))
                  end
              })
              RageUI.Button("Compte de Niveau 2", "Somme maximale : ~g~5000 $", {RightLabel = "~g~2500$~s~"}, true , {
                onSelected = function()
                  TriggerServerEvent("BBanque:buycb2", GetPlayerServerId(playerPed))
                end
              })
              RageUI.Button("Compte de Niveau 3", "Somme maximale : ~r~Illimité", {RightLabel = "~g~5000$~s~"}, true , {
                onSelected = function()
                  TriggerServerEvent("BBanque:buycb3", GetPlayerServerId(playerPed))
                end
              })
          end)
          Wait(1)
         end
      end)
   end
end

function CreaCompte()
     if open then 
         open = false
         RageUI.Visible(cracompte, false)
         return
     else
         open = true 
         RageUI.Visible(cracompte, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(cracompte,function()
            
                    RageUI.Button("Prénom", "Indiquez votre Prénom", {RightLabel = prenom}, true , {
                        onSelected = function()
                          local prenomInput = KeyboardInput("prenom", 'Indiquez Votre Prénom', '', 20)
                          if tostring(prenomInput) == nil then
                              return false
                          else
                              prenom = (tostring(prenomInput))
                          end
                        end
                    })
                    RageUI.Button("Nom", "Indiquez votre Nom", {RightLabel = nom}, true , {
                        onSelected = function()
                          local nameInput = KeyboardInput("nom", 'Indiquez Votre Nom', '', 20)
                          if nameInput ~= nil then
                              nom = (tostring(nameInput))
                          end 
                        end
                    })
                    RageUI.Button("Date de Naissance", "Indiquez votre Date de Naissance", {RightLabel = dates}, true , {
                      onSelected = function()
                        local DateInput = KeyboardInput("daten", 'Indiquez Votre Date de Naissance type : jour/mois/année', '', 12)
                        if DateInput ~= nil then
                            dates = (tostring(DateInput))
                        end
                      end
                    })
                    RageUI.Button("Ouvrir son compte", "Valider vos informations", {RightLabel = "→→", Color = {BackgroundColor = RageUI.ItemsColour.Blue}}, true , {
                      onSelected = function()
                        local prenomInput = prenom
                        local nameInput = nom
                        local DateInput = dates
                        local mdp = "Aucun"

                        if not prenomInput then
                            ShowNotification("Vous n'avez pas correctement renseigné la catégorie ~r~Prénom")
                        elseif not nameInput then
                            ShowNotification("Vous n'avez pas correctement renseigné la catégorie ~r~Nom")
                        elseif not DateInput then
                            ShowNotification("Vous n'avez pas correctement renseigné la catégorie ~r~Date de naissance") 
                        else
                          TriggerServerEvent("BBanque:setname", GetPlayerServerId(playerPed), prenomInput, nameInput, DateInput, mdp)
                          TriggerServerEvent("BBanque:setstatecompte", true)
                          --ShowNotification("~g~Votre compte bancaire a été ouvert avec succès !")
                          open = false
                        end
                      end
                    })
            end)
          Wait(1)
         end
      end)
   end
end

local creacompte = {
  crapose = {
      {pos = vector3(243.08926, 224.2578, 106.2869)}
  }
}

Citizen.CreateThread(function()
  while true do
      local pCoords2 = GetEntityCoords(PlayerPedId())
      local interval = 500
      local dst = GetDistanceBetweenCoords(pCoords2, true)
      for k,v in pairs(creacompte.crapose) do
          if #(pCoords2 - v.pos) < 2.0 then
            interval = 1
            ESX.ShowHelpNotification("Appuyez sur ~r~E~s~ pour parler au monsieur")
              if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback("BBanque:getstate", function(statecompte)
                  if statecompte then
                    InfoCompte()
                  else
                    CreaCompte()
                  end 
              end)
              end
          end
      end
      Citizen.Wait(interval)
  end
end)