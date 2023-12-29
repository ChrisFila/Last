cfg_gouv = {

    MarkerType = 22, -- Pour voir les différents type de marker: https://docs.fivem.net/docs/game-references/markers/
    MarkerSizeLargeur = 0.3, -- Largeur du marker
    MarkerSizeEpaisseur = 0.3, -- Épaisseur du marker
    MarkerSizeHauteur = 0.3, -- Hauteur du marker
    MarkerDistance = 1.3, -- Distane de visibiliter du marker (1.0 = 1 mètre)
    MarkerColorR = 69, -- Voir pour les couleurs RGB: https://www.google.com/search?q=html+color+picker&rlz=1C1GCEA_enFR965FR965&oq=html+color+&aqs=chrome.2.69i59j0i131i433i512j0i512l5j69i60.3367j0j7&sourceid=chrome&ie=UTF-8
    MarkerColorG = 112, -- Voir pour les couleurs RGB: https://www.google.com/search?q=html+color+picker&rlz=1C1GCEA_enFR965FR965&oq=html+color+&aqs=chrome.2.69i59j0i131i433i512j0i512l5j69i60.3367j0j7&sourceid=chrome&ie=UTF-8
    MarkerColorB = 246, -- Voir pour les couleurs RGB: https://www.google.com/search?q=html+color+picker&rlz=1C1GCEA_enFR965FR965&oq=html+color+&aqs=chrome.2.69i59j0i131i433i512j0i512l5j69i60.3367j0j7&sourceid=chrome&ie=UTF-8
    MarkerOpacite = 180, -- Opacité du marker (min: 0, max: 255)
    MarkerSaute = true, -- Si le marker saute (true = oui, false = non)
    MarkerTourne = true, -- Si le marker tourne (true = oui, false = non)

    NomDesMenu = {
        cl_menu = "Gouvernement",
        cl_garage = "Garage Gouvernement",
        cl_coffre = "Coffre Gouvernement",
    },

    VehiculesBanchisseur = { 
        {buttoname = "Voiture Gouv", rightlabel = "→→", spawnname = "stretch", spawnzone = vector3(-520.4052, -265.7148, 35.33), headingspawn = 110.532}, -- Garage Voiture
        {buttoname = "Baller", rightlabel = "→→", spawnname = "baller6", spawnzone = vector3(-520.4052, -265.7148, 35.33), headingspawn = 110.532}, -- Garage Voiture
        {buttoname = "Dubsta", rightlabel = "→→", spawnname = "dubsta2", spawnzone = vector3(-520.4052, -265.7148, 35.33), headingspawn = 110.532}, -- Garage Voiture
        {buttoname = "Limousine", rightlabel = "→→", spawnname = "lamg", spawnzone = vector3(-520.4052, -265.7148, 35.33), headingspawn = 110.532}, -- Garage Voiture
        {buttoname = "Chevrolet Suburban", rightlabel = "→→", spawnname = "sspres", spawnzone = vector3(-520.4052, -265.7148, 35.33), headingspawn = 110.532}, -- Garage Voiture
    },   

    
    Coffre = {
        {pos = vector3(-534.6, -192.52, 46.45)},
    },
    Garage = {
        {pos = vector3(-521.7024, -264.3309, 35.32)},
    },
    Ranger = {
        {pos = vector3(-520.4052, -265.7148, 35.33)},
    },
    Vestiaire = {
        {pos = vector3(-541.4, -192.76, 46.45)},
    },

    serviceWeapons = {
        {Label = "Lampe de poche", Name = "weapon_nightstick"},    
        {Label = "Matraque", Name = "weapon_stungun"},
        {Label = "Taser", Name = "weapon_flashlight"},
    },

    Gouvernement = {
        clothes = {
                grades = {
                    [0] = {
                        label = "S'équiper de la tenue : ~r~Sécurité ",
                        minimum_grade = 0,
                        variations = {
                        male = {
                           ['tshirt_1'] = 192,  ['tshirt_2'] = 9,
                           ['torso_1'] = 316,   ['torso_2'] = 8,
                           ['decals_1'] = 0,   ['decals_2'] = 0,
                           ['arms'] = 18,
                           ['pants_1'] = 143,   ['pants_2'] = 0,
                           ['shoes_1'] = 23,   ['shoes_2'] = 0,
                           ['helmet_1'] = -1,  ['helmet_2'] = 0,
                           ['chain_1'] = 0,    ['chain_2'] = 0,
                           ['mask_1'] = -1,  ['mask_2'] = 0,
                           ['bproof_1'] = 97,  ['bproof_2'] = 4,
                           ['ears_1'] = 2,     ['ears_2'] = 0,
                        },
                        female = {
                           ['tshirt_1'] = 53,  ['tshirt_2'] = 0,
                           ['torso_1'] = 102,   ['torso_2'] = 0,
                           ['decals_1'] = 0,   ['decals_2'] = 0,
                           ['arms'] = 0,
                           ['pants_1'] = 59,   ['pants_2'] = 0,
                           ['shoes_1'] = 25,   ['shoes_2'] = 0,
                           ['helmet_1'] = -1,  ['helmet_2'] = 0,
                           ['chain_1'] = 0,    ['chain_2'] = 0,
                           ['mask_1'] = -1,  ['mask_2'] = 0,
                           ['bproof_1'] = 7,  ['bproof_2'] = 4,
                           ['ears_1'] = 2,     ['ears_2'] = 0,
                        }
                    },
                    onEquip = function()
                    end
                },
                    [1] = {
                        minimum_grade = 1,
                        label = "S'équiper de la tenue : ~r~Président",
                        variations = {
                        male = {
                           ['tshirt_1'] = 53,  ['tshirt_2'] = 0,
                           ['torso_1'] = 93,   ['torso_2'] = 1,
                           ['decals_1'] = 0,   ['decals_2'] = 0,
                           ['arms'] = 0,
                           ['pants_1'] = 59,   ['pants_2'] = 0,
                           ['shoes_1'] = 25,   ['shoes_2'] = 0,
                           ['helmet_1'] = -1,  ['helmet_2'] = 0,
                           ['chain_1'] = 0,    ['chain_2'] = 0,
                           ['mask_1'] = -1,  ['mask_2'] = 0,
                           ['bproof_1'] = 0,  ['bproof_2'] = 0,
                           ['ears_1'] = 2,     ['ears_2'] = 0,
                        },
                        female = {
                           ['tshirt_1'] = 53,  ['tshirt_2'] = 0,
                           ['torso_1'] = 93,   ['torso_2'] = 1,
                           ['decals_1'] = 0,   ['decals_2'] = 0,
                           ['arms'] = 0,
                           ['pants_1'] = 59,   ['pants_2'] = 0,
                           ['shoes_1'] = 25,   ['shoes_2'] = 0,
                           ['helmet_1'] = -1,  ['helmet_2'] = 0,
                           ['chain_1'] = 0,    ['chain_2'] = 0,
                           ['mask_1'] = -1,  ['mask_2'] = 0,
                           ['bproof_1'] = 0,  ['bproof_2'] = 0,
                           ['ears_1'] = 2,     ['ears_2'] = 0,
                       }
                   },
                    onEquip = function()
                    end
                },

    },
        }
    },
    

}