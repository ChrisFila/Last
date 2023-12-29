mSocietyCFG = {

    --[[ Script  ]]

    Language = "fr",

    ESX = "esx:getSharedObject",
    AddonAccount = "esx_addonaccount:getSharedAccount",
    BlackMoney = "black_money",

    --[[ Menu  ]]

    Title = "Boss Menu",

    SubTitle = "Boss Menu",

    ColorMenu = {10, 10, 10},

    Banner = {
        Display = true,
        Texture = nil,
        Name = nil,
    },

    Marker = {
        Type = 1,
        Scale = {0.5, 0.5, 0.5},
        Color = {0, 150, 200},
    },

    --[[ Zone ]]

    Zone = {

       --[[  EXEMPLE
        {
            pos = vector3(0.0, 0.0, 0.0),
            name = "jobname",
            label = "Label Of Job",
            salary_max = 1200,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        }, 
        ]]

        {
            pos = vector3(462.2895, -985.4934, 30.7280),
            name = "police",
            label = "Los Santos Police Departement",
            salary_max = 20000,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        },

        {
            pos = vector3(94.951, -1294.021, 28.268),
            name = "unicorn",
            label = "Vanilla Unicorn",
            percent = 50,
            salary_max = 2500,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        },

        {
            pos = vector3(-204.08, -1331.11, 34.89),
            name = "mecano",
            label = "Benny\'s",
            salary_max = 2500,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        }, 

        {
            pos = vector3(-1897.84, 2067.71, 141.02),
            name = "vigne",
            label = "Vigneron",
            salary_max = 2500,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        }, 

        {
            pos = vector3(899.3667, -159.4734, 74.14725),
            name = "taxi",
            label = "Taxi",
            salary_max = 2500,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        }, 

        {
            pos = vector3(-546.65, -203.2, 46.45),
            name = "gouvernement",
            label = "Couvernement",
            salary_max = 50000,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        }, 

        {
            pos = vector3(340.61, -591.64, 43.28),
            name = "ambulance",
            label = "Ambulance",
            salary_max = 20000,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        }, 

        {
            pos = vector3(-31.14, -1111.02, 26.42),
            name = "carshop",
            label = "Concessionnaire Voitures",
            salary_max = 2500,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        }, 

--[[        {
            pos = vector3(-940.92, -2954.38, 19.85),
            name = "planeshop",
            label = "Concessionnaire Avions",
            salary_max = 2500,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        }, 

        {
            pos = vector3(273.15, -1154.18, 33.27),
            name = "motoshop",
            label = "Concessionnaire Motos",
            salary_max = 2500,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        },]] 

        {
            pos = vector3(-1366.26, -624.33, 30.32),
            name = "bahamas",
            label = "Bahamas",
            salary_max = 2500,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        }, 

        {
            pos = vector3(-1203.64, -892.76, 13.99),
            name = "burger",
            label = "Burger Shot",
            salary_max = 2500,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        },

        {
            pos = vector3(-340.62, -157.61, 44.59),
            name = "lscustom",
            label = "LS Custom",
            salary_max = 2500,
            options = {
                money = true, 
                wash = false, 
                employees = true, 
                grades = true
            },
        },
        
    },
}