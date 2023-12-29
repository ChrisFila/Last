cfg_braquage = {}

cfg_braquage.Locale = 'fr'

cfg_braquage.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 1.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

cfg_braquage.PoliceNumberRequired = 2
cfg_braquage.TimerBeforeNewRob    = 600 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

cfg_braquage.MaxDistance    = 20   -- max distance from the robbary, going any longer away from it will to cancel the robbary
cfg_braquage.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

Stores = {
	["paleto_twentyfourseven"] = {
		position = { x = 1736.32, y = 6419.47, z = 35.03 },
		reward = math.random(2500, 3000),
		nameOfStore = "24/7",
		secondsRemaining = 350, -- seconds
		lastRobbed = 0
	},
	["sandyshores_twentyfoursever"] = {
		position = { x = 1961.24, y = 3749.46, z = 32.34 },
		reward = math.random(2500, 3000),
		nameOfStore = "24/7",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["littleseoul_twentyfourseven"] = {
		position = { x = -709.17, y = -904.21, z = 19.21 },
		reward = math.random(2500, 3000),
		nameOfStore = "24/7",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["bar_one"] = {
	    position = { x = 1990.57, y = 3044.95, z = 47.21 },
		reward = math.random(2500, 3000),
		nameOfStore = "Yellow Jack",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["ocean_liquor"] = {
		position = { x = -2959.33, y = 388.21, z = 14.00 },
		reward = math.random(2500, 3000),
		nameOfStore = "Robs Liquor",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["rancho_liquor"] = {
		position = { x = 1126.80, y = -980.40, z = 45.41 },
		reward = math.random(2500, 3000),
		nameOfStore = "Robs Liquor",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["sanandreas_liquor"] = {
		position = { x = -1219.85, y = -916.27, z = 11.32 },
		reward = math.random(2500, 3000),
		nameOfStore = "Robs Liquor",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["grove_ltd"] = {
		position = { x = -43.40, y = -1749.20, z = 29.42 },
		reward = math.random(2500, 3000),
		nameOfStore = "LTD Gasoline",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["mirror_ltd"] = {
		position = { x = 1160.67, y = -314.40, z = 69.20 },
		reward = math.random(2500, 3000),
		nameOfStore = "LTD Gasoline",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	},
	["families_ltd"] = {
		position = { x = 28.41, y = -1339.63, z = 29.5 },
		reward = math.random(2500, 3000),
		nameOfStore = "LTD Gasoline",
		secondsRemaining = 200, -- seconds
		lastRobbed = 0
	}
}