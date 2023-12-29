Config = {
    --[[
        -1  ->  Tous les groupes (sauf user)
    --]]
    authorizations = {
        ["vehicles"] = {"_dev", "superadmin", "admin", "responsable"},
        ["vehicles2"] = {"_dev", "superadmin", "admin", "responsable"},
        ["ped"] = {"_dev"},
        ["kick"] = -1,
        ["mess"] = -1,
        ["jail"] = -1,
        ["unjail"] = -1,
        ["teleport"] = -1,
        ["revive"] = -1,
        ["heal"] = -1,
        ["tppc"] = -1,
        ["warn"] = -1,
        ["permInventaire"] = {"_dev", "superadmin", "admin", "responsable", "modo", "helper"},
        ["clearInventory"] = {"_dev", "superadmin", "responsable", "admin"},
        ["clearLoadout"] = {"_dev", "superadmin", "responsable", "admin"},
        ["setGroup"] = {"_dev", "responsable"},
        ["setJob"] = {"_dev", "superadmin", "responsable", "admin"},
        ["give"] = {"_dev", "superadmin", "responsable", "admin"},
        ["giveMoney"] = {"_dev", "superadmin", "responsable", "admin"},
        ["wipe"] = {"_dev", "superadmin", "responsable", "admin"},
        ["clearvéhicules"] = {"_dev", "superadmin", "responsable", "admin"},
    },

    webhook = {
        onTeleport = "https://discord.com/api/webhooks/1038096023450550392/3BYhBIll9Hc_yYUa96Dze5Bt5eU_9vyTDbhtyknl3Gn6wsXGSFDrceOhSyhGyQtzQAis",
        onBan = "https://discord.com/api/webhooks/1038096023450550392/3BYhBIll9Hc_yYUa96Dze5Bt5eU_9vyTDbhtyknl3Gn6wsXGSFDrceOhSyhGyQtzQAis",
        onKick = "https://discord.com/api/webhooks/1038096023450550392/3BYhBIll9Hc_yYUa96Dze5Bt5eU_9vyTDbhtyknl3Gn6wsXGSFDrceOhSyhGyQtzQAis",
        onMessage = "https://discord.com/api/webhooks/1038096023450550392/3BYhBIll9Hc_yYUa96Dze5Bt5eU_9vyTDbhtyknl3Gn6wsXGSFDrceOhSyhGyQtzQAis",
        onMoneyGive = "https://discord.com/api/webhooks/1038096023450550392/3BYhBIll9Hc_yYUa96Dze5Bt5eU_9vyTDbhtyknl3Gn6wsXGSFDrceOhSyhGyQtzQAis",
        onItemGive = "https://discord.com/api/webhooks/1038096023450550392/3BYhBIll9Hc_yYUa96Dze5Bt5eU_9vyTDbhtyknl3Gn6wsXGSFDrceOhSyhGyQtzQAis",
        onClear = "https://discord.com/api/webhooks/1038096023450550392/3BYhBIll9Hc_yYUa96Dze5Bt5eU_9vyTDbhtyknl3Gn6wsXGSFDrceOhSyhGyQtzQAis",
        onGroupChange = "https://discord.com/api/webhooks/1038096023450550392/3BYhBIll9Hc_yYUa96Dze5Bt5eU_9vyTDbhtyknl3Gn6wsXGSFDrceOhSyhGyQtzQAis",
        onRevive = "https://discord.com/api/webhooks/1038096023450550392/3BYhBIll9Hc_yYUa96Dze5Bt5eU_9vyTDbhtyknl3Gn6wsXGSFDrceOhSyhGyQtzQAis",
        onHeal = "https://discord.com/api/webhooks/1038096023450550392/3BYhBIll9Hc_yYUa96Dze5Bt5eU_9vyTDbhtyknl3Gn6wsXGSFDrceOhSyhGyQtzQAis",
        onWipe = "https://discord.com/api/webhooks/1038096023450550392/3BYhBIll9Hc_yYUa96Dze5Bt5eU_9vyTDbhtyknl3Gn6wsXGSFDrceOhSyhGyQtzQAis"
    }
}