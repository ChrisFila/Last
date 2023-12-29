
cfg_custom = {}

cfg_custom.DrawDistance      = 15.0
cfg_custom.Locale            = 'fr'
cfg_custom.IsMecanoJobOnly = true
cfg_custom.IsMotorCycleBikerOnly = false

cfg_custom.shopProfit = { ['mecano'] = 50,  ['lscustom'] = 50 }

-- Role
cfg_custom.RequiredRole = {'mecano', 'lscustom'}
cfg_custom.Hint  = _U('press_custom')
cfg_custom.Zones = {
	{
		Pos   = {x = -211.04, y = -1324.37, z = 30.89},
		Size  = {x = 10.0, y = 10.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker= 27,
		Name  = _U('blip_name'),
		Hint  = _U('press_custom')
	},
	{
		Pos   = {x = -317.76, y = -118.35, z = 39.02},
		Size  = {x = 10.0, y = 10.0, z = 1.0},
		Color = {r = 204, g = 204, b = 0},
		Marker= 27,
		Name  = _U('blip_name'),
		Hint  = _U('press_custom')
	}
}

cfg_custom.Colors = {
	label = { _U('black'), _U('white'), _U('grey'), _U('red'), _U('pink'), _U('blue'), _U('yellow'), _U('green'), _U('orange'), _U('brown'), _U('purple'), _U('chrome'), _U('gold') },
	color = { 'black', 'white', 'grey', 'red', 'pink', 'blue', 'yellow', 'green', 'orange', 'brown', 'purple', 'chrome', 'gold' },
}

cfg_custom.DetailsColor = {
	[1] = {
		label = { _U('black'), _U('graphite'), _U('black_metallic'), _U('caststeel'), _U('black_anth'), _U('matteblack'), _U('darknight'), _U('deepblack'), _U('oil'), _U('carbon')},
		id = { 0, 1, 2, 3, 11, 12, 15, 16, 21, 147 }
	},
	[2] = {
		label = { _U('vanilla'), _U('creme'), _U('white'), _U('polarwhite'), _U('beige'), _U('mattewhite'), _U('snow'), _U('cotton'), _U('alabaster'), _U('purewhite') },
		id = { 106, 107, 111, 112, 113, 121, 122, 131, 132, 134 }
	},
	[3] = {
		label = { _U('silver'), _U('metallicgrey'), _U('laminatedsteel'), _U('darkgray'), _U('rockygray'), _U('graynight'), _U('aluminum'), _U('graymat'), _U('lightgrey'), _U('asphaltgray'), _U('grayconcrete'), _U('darksilver'), _U('magnesite'), _U('nickel'), _U('zinc'), _U('dolomite'), _U('bluesilver'), _U('titanium'), _U('steelblue'), _U('champagne'), _U('grayhunter'), _U('grey') },
		id = { 4, 5, 6, 7, 8, 9, 10, 13, 14, 17, 18, 19, 20, 22, 23, 24, 25, 26, 66, 93, 144, 156 }
	},
	[4] = {
		label = { _U('red'), _U('torino_red'), _U('poppy'), _U('copper_red'), _U('cardinal'), _U('brick'), _U('garnet'), _U('cabernet'), _U('candy'), _U('matte_red'), _U('dark_red'), _U('red_pulp'), _U('bril_red'), _U('pale_red'), _U('wine_red'), _U('volcano'), },
		id = { 27, 28, 29, 30, 31, 32, 33, 34, 35, 39, 40, 43, 44, 46, 143, 150 }
	},
	[5] = {
		label = { _U('electricpink'), _U('salmon'), _U('sugarplum') },
		id = { 135, 136, 137 }
	},
	[6] = {
		label = {  _U('topaz'), _U('light_blue'), _U('galaxy_blue'), _U('dark_blue'), _U('azure'), _U('navy_blue'), _U('lapis'), _U('blue_diamond'), _U('surfer'), _U('pastel_blue'), _U('celeste_blue'), _U('rally_blue'), _U('blue_paradise'), _U('blue_night'), _U('cyan_blue'), _U('cobalt'), _U('electric_blue'), _U('horizon_blue'), _U('metallic_blue'), _U('aquamarine'), _U('blue_agathe'), _U('zirconium'), _U('spinel'), _U('tourmaline'), _U('paradise'), _U('bubble_gum'), _U('midnight_blue'), _U('forbidden_blue'), _U('glacier_blue') },
		id = { 54, 60, 61, 62, 63, 64, 65, 67, 68, 69, 70, 73, 74, 75, 77, 78, 79, 80, 82, 83, 84, 85, 86, 87, 127, 140, 141, 146, 157 }
	},
	[7] = {
		label = { _U('yellow'), _U('wheat'), _U('raceyellow'), _U('paleyellow'), _U('lightyellow') },
		id = { 42, 88, 89, 91, 126 }
	},
	[8] = {
		label = { _U('met_dark_green'), _U('rally_green'), _U('pine_green'), _U('olive_green'), _U('light_green'), _U('lime_green'), _U('forest_green'), _U('lawn_green'), _U('imperial_green'), _U('green_bottle'), _U('citrus_green'), _U('green_anis'), _U('khaki'), _U('army_green'), _U('dark_green'), _U('hunter_green'), _U('matte_foilage_green') },
		id = { 49, 50, 51, 52, 53, 55, 56, 57, 58, 59, 92, 125, 128, 133, 151, 152, 155 }
	},
	[9] = {
		label = { _U('tangerine'), _U('orange'), _U('matteorange'), _U('lightorange'), _U('peach'), _U('pumpkin'), _U('orangelambo') },
		id = { 36, 38, 41, 123, 124, 130, 138 }
	},
	[10] = {
		label = { _U('copper'), _U('lightbrown'), _U('darkbrown'), _U('bronze'), _U('brownmetallic'), _U('Expresso'), _U('chocolate'), _U('terracotta'), _U('marble'), _U('sand'), _U('sepia'), _U('bison'), _U('palm'), _U('caramel'), _U('rust'), _U('chestnut'), _U('brown'), _U('hazelnut'), _U('shell'), _U('mahogany'), _U('cauldron'), _U('blond'), _U('gravel'), _U('darkearth'), _U('desert') },
		id = { 45, 47, 48, 90, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 108, 109, 110, 114, 115, 116, 129, 153, 154 }
	},
	[11] = {
		label = { _U('indigo'), _U('deeppurple'), _U('darkviolet'), _U('amethyst'), _U('mysticalviolet'), _U('purplemetallic'), _U('matteviolet'), _U('mattedeeppurple') },
		id = { 71, 72, 76, 81, 142, 145, 148, 149 }
	},
	[12] = {
		label = {  _U('brushechrome'), _U('blackchrome'), _U('brushedaluminum'), _U('chrome') },
		id = { 117, 118, 119, 120 }
	},
	[13] = {
		label = { _U('gold'), _U('puregold'), _U('brushedgold'), _U('lightgold') },
		id = { 37, 158, 159, 160 }
	}
}

function GetPlatesName(index)
	if (index == 0) then
		return _U('blue_on_white_1')
	elseif (index == 1) then
		return _U('yellow_on_black')
	elseif (index == 2) then
		return _U('yellow_blue')
	elseif (index == 3) then
		return _U('blue_on_white_2')
	elseif (index == 4) then
		return _U('blue_on_white_3')
	end
end

cfg_custom.bodyParts = {
	[1] = {
		mod = 'modSpoilers',
		label = _U('spoilers'),
		modType = 0,
		items = {
			label = {},
			price = 10
		}
	},
	[2] = {
		mod = 'modFrontBumper',
		label = _U('frontbumper'),
		modType = 1,
		items = {
			label = {},
			price = 12
		}
	},
	[3] = {
		mod = 'modRearBumper',
		label = _U('rearbumper'),
		modType = 2,
		items = {
			label = {},
			price = 12
		}
	},
	[4] = {
		mod = 'modSideSkirt',
		label = _U('sideskirt'),
		modType = 3,
		items = {
			label = {},
			price = 8
		}
	},
	[5] = {
		mod = 'modExhaust',
		label = _U('exhaust'),
		modType = 4,
		items = {
			label = {},
			price = 6
		}
	},
	[6] = {
		mod = 'modFrame',
		label = _U('cage'),
		modType = 5,
		items = {
			label = {},
			price = 9
		}
	},
	[7] = {
		mod = 'modGrille',
		label = _U('grille'),
		modType = 6,
		items = {
			label = {},
			price = 5
		}
	},
	[8] = {
		mod = 'modHood',
		label = _U('hood'),
		modType = 7,
		items = {
			label = {},
			price = 6
		}
	},
	[9] = {
		mod = 'modFender',
		label = _U('leftfender'),
		modType = 8,
		items = {
			label = {},
			price = 6
		}
	},
	[10] = {
		mod = 'modRightFender',
		label = _U('rightfender'),
		modType = 9,
		items = {
			label = {},
			price = 3
		}
	},
	[11] = {
		mod = 'modRoof',
		label = _U('roof'),
		modType = 10,
		items = {
			label = {},
			price = 6
		}
	},
	[12] = {
		mod = 'wheels',
		label = _U('wheel_type'),
		items = { _U('sport'), _U('muscle'), _U('lowrider'), _U('suv'), _U('allterrain'), _U('tuning'), _U('highend'), _U('motorcycle') },
		modType = 23,
		wheelType = { 0, 1, 2, 3, 4, 5, 7, 6 },
	},
	[13] = {
		mod = 'modFrontWheels',
		label = _U('wheels'),
		modType = 23,
		items = {
			label = {},
			price = 15
		}
	}
}

cfg_custom.windowTints = { 
	mod = 'windowTint',
	label = { '[1/7]', '[2/7]', '[3/7]', '[4/7]', '[5/7]', '[6/7]', '[7/7]' },
	label1 = _U('windowtint'),
	tint = { -1, 0, 1, 2, 3, 4, 5 },
	price = 2
}

cfg_custom.colorParts = {
	label = { _U('primary'), _U('secondary'), _U('pearlescent'), _U('windows'), _U('interior')--[[, _U('wheels'), _U('tireSmoke'), _U('headlights')--]] },
	mod = { 'primary', 'secondary', 'pearlescent', 'windows', 'interior' },
	wheelColorPrice = 2.5,
	primaryColorPrice = 3.5,
	secondaryColorPrice = 3.5,
	pearlescentColorPrice = 3.5,
	interiorColorPrice = 3.5,
	customPrimaryColorPrice = 5.5,
	customSecondaryColorPrice = 5.5,
	primaryPaintFinishPrice = 3.5,
	secondaryPaintFinishPrice = 3.5
}

cfg_custom.resprayTypes = {
	[1] = {
		label = { _U('metallic'), _U('matte'), _U('util'), _U('worn'), _U('brushed'), _U('others'), _U('personalize') },
		mod = { 'metallic', 'matte', 'util', 'worn', 'brushed', 'others', 'personalize' }
	},
	[2] = {
		label = { _U('metallic'), _U('matte'), _U('util'), _U('worn'), _U('brushed'), _U('others'), _U('personalize') },
		mod = { 'metallic', 'matte', 'util', 'worn', 'brushed', 'others', 'personalize' }
	},
	[3] = {
		label = { _U('metallic'), _U('matte'), _U('util'), _U('worn'), _U('brushed'), _U('others') },
		mod = { 'metallic', 'matte', 'util', 'worn', 'brushed', 'others' }
	},
	[4] = {
		label = { '[1/7]', '[2/7]', '[3/7]', '[4/7]', '[5/7]', '[6/7]', '[7/7]' },
		tint = { -1, 0, 1, 2, 3, 4, 5 },
		price = 3
	},
	[5] = {
		label = { _U('metallic'), _U('matte'), _U('util'), _U('worn'), _U('brushed'), _U('others')},
		mod = { 'metallic', 'matte', 'util', 'worn', 'brushed', 'others', 'personalize' }
	},
}

cfg_custom.tireSmoke = {
	mod = 'modSmokeEnabled',
	label = _U('tireSmoke'),
	mod1 = 'tyreSmokeColor',
	label1 = _U('tireSmokeColor'),
	price = 2
}

cfg_custom.xenon = {
	mod = 'modXenon',
	label = _U('headlights'),
	mod1 = 'xenonColor',
	label1 = _U('xenonColor'),
	items = {
		label = { '[1/14]', '[2/14]', '[3/14]', '[4/14]', '[5/14]', '[6/14]', '[7/14]', '[8/14]', '[9/14]', '[10/14]', '[11/14]', '[12/14]', '[13/14]', '[14/14]' },
		color = { -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 }
	},
	price = 2
}

cfg_custom.colorPalette = {
	[1] = { 
		metallic = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 49, 50, 51, 52, 53, 54, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 112, 125, 137, 141, 142, 143, 145, 146, 150, 156 }
	},
	[2] = { 
		matte = { 12, 13, 14, 39, 40, 41, 42, 55, 82, 83, 84, 128, 129, 131, 148, 149, 151, 152, 153, 154, 155 }
	},
	[3] = { 
		util = { 15, 16, 17, 18, 19, 20, 43, 44, 45, 56, 57, 75, 76, 77, 78, 79, 80, 81, 108, 109, 110, 122 }
	},
	[4] = { 
		worn = { 21, 22, 23, 24, 25, 26, 47, 48, 58, 59, 60, 85, 86, 87, 113, 114, 115, 116, 121, 123, 124, 126, 130, 132, 133 }
	},
	[5] = { 
		brushed = { 117, 118, 119, 159 }
	},
	[6] = { 
		others = { 120, 127, 134, 135, 136, 138, 139, 140, 144, 147, 157, 158 }
	},
	[7] = {
		personalize = {  }
	},
	[8] = { 
		wheelPrice = 2.58
	}
}

cfg_custom.paintFinish = { 0, 12, 15, 21, 117, 120 }

cfg_custom.neons = {
	[1] = {
		mod = 'leftNeon',
		label = _U('leftNeon'),
		price = 1
	},
	[2] = {
		mod = 'rightNeon',
		label = _U('rightNeon'),
		price = 1
	},
	[3] = {
		mod = 'frontNeon',
		label = _U('frontNeon'),
		price = 1
	},
	[4] = {
		mod = 'backNeon',
		label = _U('backNeon'),
		price = 1
	},
	[5] = {
		label = 'Cor neon',
		mod = 'neonColor',
		mod1 = 'neonEnabled',
		price = 1
	}
}

cfg_custom.extras = {
	[1] = {
		mod = 'modPlateHolder',
		label = _U('modplateholder'),
		modType = 25,
		items = {
			label = {},
			price = 2
		}
	},
	[2] = {
		mod = 'modVanityPlate',
		label = _U('modvanityplate'),
		modType = 26,
		items = {
			label = {},
			price = 2
		}
	},
	[3] = {
		mod = 'modTrimA',
		label = _U('interior'),
		modType = 27,
		items = {
			label = {},
			price = 8.5
		}
	},
	[4] = {
		mod = 'modOrnaments',
		label = _U('trim'),
		modType = 28,
		items = {
			label = {},
			price = 6
		}
	},
	[5] = {
		mod = 'modDashboard',
		label = _U('dashboard'),
		modType = 29,
		items = {
			label = {},
			price = 6
		}
	},
	[6] = {
		mod = 'modDial',
		label = _U('speedometer'),
		modType = 30,
		items = {
			label = {},
			price = 5
		}
	},
	[7] = {
		mod = 'modDoorSpeaker',
		label = _U('door_speakers'),
		modType = 31,
		items = {
			label = {},
			price = 4
		}
	},
	[8] = {
		mod = 'modSeats',
		label = _U('seats'),
		modType = 32,
		items = {
			label = {},
			price = 7
		}
	},
	[9] = {
		mod = 'modSteeringWheel',
		label = _U('steering_wheel'),
		modType = 33,
		items = {
			label = {},
			price = 3
		}
	},
	[10] = {
		mod = 'modShifterLeavers',
		label = _U('gear_lever'),
		modType = 34,
		items = {
			label = {},
			price = 3
		}
	},
	[11] = {
		mod = 'modAPlate',
		label = _U('quarter_deck'),
		modType = 35,
		items = {
			label = {},
			price = 3
		}
	},
	[12] = {
		mod = 'modSpeakers',
		label = _U('speakers'),
		modType = 36,
		items = {
			label = {},
			price = 6
		}
	},
	[13] = {
		mod = 'modTrunk',
		label = _U('trunk'),
		modType = 37,
		items = {
			label = {},
			price = 9
		}
	},
	[14] = {
		mod = 'modHydrolic',
		label = _U('hydraulic'),
		modType = 38,
		items = {
			label = {},
			price = 15
		}
	},
	[15] = {
		mod = 'modEngineBlock',
		label = _U('engine_block'),
		parent = 'cosmetics',
		modType = 39,
		items = {
			label = {},
			price = 6
		}
	},
	[16] = {
		mod = 'modAirFilter',
		label = _U('air_filter'),
		modType = 40,
		items = {
			label = {},
			price = 4
		}
	},
	[17] = {
		mod = 'modStruts',
		label = _U('struts'),
		modType = 41,
		items = {
			label = {},
			price = 5
		}
	},
	[18] = {
		mod = 'modArchCover',
		label = _U('arch_cover'),
		modType = 42,
		items = {
			label = {},
			price = 6
		}
	},
	[19] = {
		mod = 'modAerials',
		label = _U('aerials'),
		modType = 43,
		items = {
			label = {},
			price = 1
		}
	},
	[20] = {
		mod = 'modTrimB',
		label = _U('wings'),
		modType = 44,
		items = {
			label = {},
			price = 7
		}
	},
	[21] = {
		mod = 'modTank',
		label = _U('fuel_tank'),
		modType = 45,
		items = {
			label = {},
			price = 10
		}
	},
	[22] = {
		mod = 'modWindows',
		label = _U('windows'),
		modType = 46,
		items = {
			label = {},
			price = 4
		}
	},
	[23] = {
		mod = 'modLivery',
		label = _U('stickers'),
		modType = 48,
		items = {
			label = {},
			price = 13
		}
	},
	[24] = {
		mod = 'modHorns',
		label = _U('horns'),
		modType = 14,
		items = {
			label = {},
			price = 2
		}
	}
}

cfg_custom.upgrades = {
	[1]	= {
		mod = 'modEngine',
		label = _U('engine'),
		modType = 11,
		items = {
			--[[label = {'Stock', 'Level 1', 'Level 2', 'Level 3', 'Level 4'},--]]
			label = {},
			price = { 0, 30, 40, 50, 60, 70 }
		}
	},
	[2]	= {
		mod = 'modTransmission',
		label = _U('transmission'),
		modType = 13,
		items = {
			--[[label = {'Stock', 'Level 1', 'Level 2', 'Level 3', 'Level 4'},--]]
			label = {},
			price = { 0, 10, 15, 20, 25, 30 }
		}
	},
	[3]	= {
		mod = 'modBrakes',
		label = _U('brakes'),
		modType = 12,
		items = {
			--[[label = {'Stock', 'Level 1', 'Level 2', 'Level 3', 'Level 4'},--]]
			label = {},
			price = { 0, 15, 25, 35, 45, 55, 65 }
		}
	},
	[4]	= {
		mod = 'modSuspension',
		label = _U('suspension'),
		modType = 15,
		items = {
			--[[label = {'Stock', 'Level 1', 'Level 2', 'Level 3', 'Level 4', 'Level 5'},--]]
			label = {},
			price = { 0, 10, 15, 20, 25, 30, 35 }
		}
	},
	[5]	= {
		mod = 'modTurbo',
		label = _U('turbo'),
		modType = 18,
		items = {
			--[[label = {'Stock', 'Level 1'},--]]
			label = {},
			price = { 0, 50 }
		}
	}
}

cfg_custom.PlateText = {
	[1]	= {label = "Blue_on_White_1", id = 3}, 
	[2]	= {label = "Blue_on_White_2", id =0}, 
	[3]	= {label = "Blue_on_White_3", id = 4}, 
	[4]	= {label = "Yellow_on_Blue", id = 5}, 
	[5]	= {label = "Yellow_on_Black", id = 1}, 
	[6]	= {label = "North_Yankton", id = 5},   
}


cfg_custom.Vehicles = {
	{ name = 'Brioso', model = 'brioso', price = 10000},
	{ name = 'Issi', model = 'issi2', price = 15000},
	{ name = 'Panto', model = 'panto', price = 17500},
	{ name = 'Prairie', model = 'Prairie', price = 24500},
	{ name = 'Blista', model = 'blista', price = 21500},
	{ name = 'Issi Derby', model = 'issi3', price = 12500},
	{ name = 'Cognoscenti Cab.', model = 'cogcabrio', price = 27500 },
	{ name = 'Felon GT', model = 'felon2', price = 31500 },
	{ name = 'Jackal', model = 'jackal', price = 28500 },
	{ name = 'Oracle XS', model = 'oracle2', price = 32500 },
	{ name = 'Sentinel', model = 'sentinel', price = 35000 },
	{ name = 'Sentinel XS', model = 'sentinel2', price = 37500 },
	{ name = 'Windsor', model = 'windsor', price = 50000 },
	{ name = 'Windsor Drop', model = 'windsor2', price = 55000 },
	{ name = 'Zion', model = 'zion', price = 42500 },
	{ name = 'Blista Clasic', model = 'blista2', price = 42500 },
	{ name = 'Zion Cabrio', model = 'zion2', price = 44500 },
	{ name = 'Exemplar', model = 'exemplar', price = 52500 },
	{ name = 'F620', model = 'f620', price = 45500 },
	{ name = 'Oracle Classic', model = 'oracle', price = 38500 },
	{ name = 'Oracle Deluxe', model = 'oracle2', price = 41500 },
	{ name = 'Vespa', model = 'faggio2', price = 2200 },
	{ name = 'Zombie Luxuary', model = 'zombieb', price = 24500 },
	{ name = 'Vader', model = 'vader', price = 31000 },
	{ name = 'Tri bike (velo)', model = 'tribike3', price = 1000 },
	{ name = 'Sovereign', model = 'sovereign', price = 25500 },
	{ name = 'Scorcher (velo)', model = 'scorcher', price = 700 },
	{ name = 'Sanctus', model = 'sanctus', price = 41500 },
	{ name = 'Ruffian', model = 'ruffian', price = 34500 },
	{ name = 'Nightblade', model = 'nightblade', price = 38500 },
	{ name = 'Manchez', model = 'manchez', price = 15000 },
	{ name = 'Hexer', model = 'hexer', price = 37500 },
	{ name = 'Hakuchou', model = 'hakuchou', price = 39000 },
	{ name = 'Fixter (velo)', model = 'fixter', price = 600 },
	{ name = 'Akuma', model = 'AKUMA', price = 24500 },
	{ name = 'Faggio', model = 'faggio', price = 1500 },
	{ name = 'Esskey', model = 'esskey', price = 26500 },
	{ name = 'Enduro', model = 'enduro', price = 29500 },
	{ name = 'Defiler', model = 'defiler', price = 34000 },
	{ name = 'Daemon High', model = 'daemon2', price = 41000 },
	{ name = 'Daemon', model = 'daemon', price = 42000 },
	{ name = 'Cliffhanger', model = 'cliffhanger', price = 45000 },
	{ name = 'Carbon RS', model = 'carbonrs', price = 50500 },
	{ name = 'BMX (velo)', model = 'bmx', price = 300 },
	{ name = 'BF 400', model = 'bf400', price = 12500 },
	{ name = 'Bati 801RR', model = 'bati2', price = 35000 },
	{ name = 'Avarus', model = 'avarus', price = 42500 },
	{ name = 'Bagger', model = 'bagger', price = 31500 },
	{ name = 'Chimera', model = 'chimera', price = 27500 },
	{ name = 'Diablous', model = 'diablous', price = 34500 },
	{ name = 'Diablous Road', model = 'diablous2', price = 37500 },
	{ name = 'Double', model = 'double', price = 43500 },
	{ name = 'FCR', model = 'fcr', price = 23500 },
	{ name = 'Gargoyle', model = 'gargoyle', price = 31000 },
	{ name = 'Hakuchou Sport', model = 'hakuchou2', price = 45000 },
	{ name = 'Innovation', model = 'innovation', price = 35500 },
	{ name = 'Lectro', model = 'lectro', price = 29500 },
	{ name = 'Nemesis', model = 'nemesis', price = 27500 },
	{ name = 'PCJ', model = 'pcj', price = 31500 },
	{ name = 'Ratbike', model = 'ratbike', price = 17500 },
	{ name = 'Sanchez', model = 'sanchez', price = 10500 },
	{ name = 'Sanchez sport', model = 'sanchez2', price = 12500 },
	{ name = 'Thrust', model = 'thrust', price = 17500 },
	{ name = 'Vindicator', model = 'vindicator', price = 24500 },
	{ name = 'Vortex', model = 'vortex', price = 24500 },
	{ name = 'Blade', model = 'blade', price = 35500 },
	{ name = 'Buccaneer', model = 'buccaneer', price = 41500 },
	{ name = 'Buccaneer Rider', model = 'buccaneer2', price = 43500 },
	{ name = 'Chino', model = 'chino', price = 37000 },
	{ name = 'Chino Luxe', model = 'chino2', price = 39000 },
	{ name = 'Coquette', model = 'coquette3', price = 51200 },
	{ name = 'Dominator', model = 'dominator', price = 70000 },
	{ name = 'Dukes', model = 'dukes', price = 41000 },
	{ name = 'Faction Rider', model = 'faction2', price = 36500 },
	{ name = 'Faction XL', model = 'faction3', price = 42500 },
	{ name = 'Gauntlet', model = 'gauntlet', price = 37500 },
	{ name = 'Hermes', model = 'hermes', price = 75500 },
	{ name = 'Hotknife', model = 'hotknife', price = 48000 },
	{ name = 'Hustler', model = 'hustler', price = 31500 },
	{ name = 'Nightshade', model = 'nightshade', price = 51500 },
	{ name = 'Phoenix', model = 'phoenix', price = 27500 },
	{ name = 'Picador', model = 'picador', price = 24500 },
	{ name = 'Sabre Turbo', model = 'sabregt', price = 32500 },
	{ name = 'Sabre GT', model = 'sabregt2', price = 35500 },
	{ name = 'Tampa', model = 'tampa', price = 38500 },
	{ name = 'Vigero', model = 'vigero', price = 26500 },
	{ name = 'Virgo', model = 'virgo', price = 26500 },
	{ name = 'Voodoo', model = 'voodoo', price = 28500 },
	{ name = 'Yosemite', model = 'yosemite', price = 27500 },
	{ name = 'Clique', model = 'clique', price = 42500 },
	{ name = 'Deviant', model = 'deviant', price = 48500 },
	{ name = 'Dominator Sport', model = 'dominator2', price = 65000 },
	{ name = 'Dominator Deluxe', model = 'dominator3', price = 82500 },
	{ name = 'Ellie', model = 'ellie', price = 32500 },
	{ name = 'Impaler', model = 'impaler', price = 30000 },
	{ name = 'Moonbeam', model = 'moonbeam', price = 36500 },
	{ name = 'Moonbeam Rider', model = 'moonbeam2', price = 39500 },
	{ name = 'Ratloader', model = 'ratloader2', price = 24500 },
	{ name = 'Ruiner', model = 'ruiner', price = 28500 },
	{ name = 'Slamvan', model = 'slamvan', price = 24500 },
	{ name = 'Slamvan rallongé', model = 'slamvan2', price = 49500 },
	{ name = 'Stalion', model = 'stalion', price = 31500 },
	{ name = 'Tulip', model = 'tulip', price = 32500 },
	{ name = 'Vamos', model = 'vamos', price = 35500 },
	{ name = 'Virgo Classic', model = 'virgo2', price = 29500 },
	{ name = 'Bifta', model = 'bifta', price = 42500 },
	{ name = 'Blazer', model = 'blazer', price = 27500 },
	{ name = 'Blazer Sport', model = 'blazer4', price = 31500 },
	{ name = 'Brawler', model = 'brawler', price = 41500 },
	{ name = 'Bubsta 6x6', model = 'dubsta3', price = 61500 },
	{ name = 'Dune Buggy', model = 'dune', price = 29500 },
	{ name = 'Guardian', model = 'guardian', price = 85500 },
	{ name = 'Kamacho', model = 'kamacho', price = 51500 },
	{ name = 'Rebel', model = 'rebel2', price = 39500 },
	{ name = 'Sandking', model = 'sandking', price = 65000 },
	{ name = 'Bodhi', model = 'bodhi2', price = 24500 },
	{ name = 'Dloader', model = 'dloader', price = 22500 },
	{ name = 'Kalahari', model = 'kalahari', price = 29500 },
	{ name = 'Rancher', model = 'rancherxl', price = 33500 },
	{ name = 'Rebel Lowcoast', model = 'rebel', price = 28500 },
	{ name = 'Riata', model = 'riata', price = 46500 },
	{ name = 'Trophy Truck', model = 'trophytruck', price = 48500 },
	{ name = 'Trophy Truck Limited', model = 'trophytruck2', price = 53500 },
	{ name = 'Asea', model = 'asea', price = 24500 },
	{ name = 'Cognoscenti', model = 'cognoscenti', price = 31500 },
	{ name = 'Emperor', model = 'emperor', price = 28500 },
	{ name = 'Fugitive', model = 'fugitive', price = 34500 },
	{ name = 'Glendale', model = 'glendale', price = 34500 },
	{ name = 'Premier', model = 'premier', price = 24500 },
	{ name = 'Primo Custom', model = 'primo2', price = 31500 },
	{ name = 'Tailgater', model = 'tailgater', price = 35500 },
	{ name = 'Warrener', model = 'warrener', price = 27500 },
	{ name = 'Asterope', model = 'asterope', price = 32000 },
	{ name = 'Cog 55', model = 'cog55', price = 50500 },
	{ name = 'Ingot', model = 'ingot', price = 27500 },
	{ name = 'Intruder', model = 'intruder', price = 34500 },
	{ name = 'Regina', model = 'regina', price = 27500 },
	{ name = 'Staffhord', model = 'stafford', price = 58500 },
	{ name = 'Stanier', model = 'stanier', price = 31500 },
	{ name = 'Stratum', model = 'stratum', price = 27500 },
	{ name = 'Super D', model = 'superd', price = 41500 },
	{ name = 'Surge', model = 'surge', price = 49500 },
	{ name = 'Washington', model = 'washington', price = 31000 },
	{ name = 'Khamelion', model = 'khamelion', price = 175500 },
	{ name = 'Surano', model = 'surano', price = 185000 },
	{ name = 'Sultan', model = 'sultan', price = 70549 },
	{ name = 'Streiter', model = 'streiter', price = 136000 },
	{ name = 'Sentinel3', model = 'sentinel3', price = 69500 },
	{ name = 'Schafter V12', model = 'schafter3', price = 80500 },
	{ name = '9F Cabrio', model = 'ninef2', price = 240500 },
	{ name = '9F', model = 'ninef', price = 215000 },
	{ name = 'Massacro', model = 'massacro', price = 190500 },
	{ name = 'Mamba', model = 'mamba', price = 140000 },
	{ name = 'Kuruma', model = 'kuruma', price = 165500 },
	{ name = 'Alpha', model = 'alpha', price = 80000 },
	{ name = 'Jester', model = 'jester', price = 125500 },
	{ name = 'Feltzer', model = 'feltzer2', price = 115500 },
	{ name = 'Elegy', model = 'elegy2', price = 105000 },
	{ name = 'Coquette', model = 'coquette', price = 110500 },
	{ name = 'Comet 5', model = 'comet5', price = 155500 },
	{ name = 'Comet', model = 'comet2', price = 135000 },
	{ name = 'Carbonizzare', model = 'carbonizzare', price = 145000 },
	{ name = 'Buffalo S', model = 'buffalo2', price = 65500 },
	{ name = 'Bestia GTS', model = 'bestiagts', price = 75500 },
	{ name = 'Banshee', model = 'banshee', price = 120000 },
	{ name = 'Devester', model = 'deveste', price = 185500 },
	{ name = 'Elegy Classic', model = 'elegy', price = 77500 },
	{ name = 'Flash GT', model = 'flashgt', price = 125500 },
	{ name = 'Furore GT', model = 'furoregt', price = 127500 },
	{ name = 'Fusilade', model = 'fusilade', price = 62500 },
	{ name = 'Futo', model = 'futo', price = 57500 },
	{ name = 'GB 200', model = 'gb200', price = 77500 },
	{ name = 'Italigto', model = 'italigto', price = 215500 },
	{ name = 'Jester Classic', model = 'jester3', price = 87500 },
	{ name = 'Lynx', model = 'lynx', price = 127500 },
	{ name = 'Pariah', model = 'pariah', price = 149500 },
	{ name = 'Penumbra', model = 'penumbra', price = 81500 },
	{ name = 'Raiden', model = 'raiden', price = 147500 },
	{ name = 'Ruston', model = 'ruston', price = 115000 },
	{ name = 'Schlagen', model = 'schlagen', price = 165500 },
	{ name = 'Specter', model = 'specter', price = 135500 },
	{ name = 'Tropos', model = 'tropos', price = 112500 },
	{ name = 'Verliere Sport', model = 'verlierer2', price = 125000 },
	{ name = 'Btype', model = 'btype', price = 27500 },
	{ name = 'Btype Hotroad', model = 'btype2', price = 65000 },
	{ name = 'Btype Luxe', model = 'btype3', price = 42500 },
	{ name = 'Casco', model = 'casco', price = 115500 },
	{ name = 'Coquette Classic', model = 'coquette2', price = 137500 },
	{ name = 'Stirling GT', model = 'feltzer3', price = 142500 },
	{ name = 'GT 500', model = 'gt500', price = 75500 },
	{ name = 'Manana', model = 'manana', price = 27500 },
	{ name = 'Monroe', model = 'monroe', price = 145500 },
	{ name = 'Pigalle', model = 'pigalle', price = 43500 },
	{ name = 'Rapid GT3', model = 'rapidgt3', price = 58500 },
	{ name = 'Retinue', model = 'retinue', price = 12500 },
	{ name = 'Savestra', model = 'savestra', price = 14500 },
	{ name = 'Stinger', model = 'stinger', price = 39500 },
	{ name = 'Stinger GT', model = 'stingergt', price = 58500 },
	{ name = 'Viseris', model = 'viseris', price = 81500 },
	{ name = 'Z190', model = 'z190', price = 67500 },
	{ name = 'Z-Type', model = 'ztype', price = 92500 },
	{ name = 'Cheetah Classic', model = 'cheetah2', price = 97500 },
	{ name = 'Fagaloa', model = 'fagaloa', price = 17500 },
	{ name = 'Infernus', model = 'infernus', price = 235000 },
	{ name = 'JB 700', model = 'jb700', price = 145000 },
	{ name = 'Michelli', model = 'michelli', price = 24500 },
	{ name = 'Peyote', model = 'peyote', price = 32500 },
	{ name = 'Swinger', model = 'swinger', price = 145500 },
	{ name = 'Torero', model = 'torero', price = 124000 },
	{ name = 'Tornado', model = 'tornado', price = 31500 },			
	{ name = 'Adder', model = 'adder', price = 1250500 },
	{ name = 'Autarch', model = 'autarch', price = 750500 },
	{ name = 'Banshee 900R', model = 'banshee2', price = 640500 },
	{ name = 'Bullet', model = 'bullet', price = 560000 },
	{ name = 'Cheetah', model = 'cheetah', price = 1250500 },
	{ name = 'Osiris', model = 'osiris', price = 1315500 },
	{ name = 'X80 Proto', model = 'prototipo', price = 1650500 },
	{ name = 'Reaper', model = 'reaper', price = 950500 },
	{ name = 'Sultan RS', model = 'sultanrs', price = 560500 },
	{ name = 'T20', model = 't20', price = 1450500 },
	{ name = 'Turismo R', model = 'turismor', price = 2750500 },
	{ name = 'Vacca', model = 'vacca', price = 836500 },
	{ name = 'Visione', model = 'visione', price = 1350500 },
	{ name = 'Voltic', model = 'voltic', price = 875500 },
	{ name = 'Zentorno', model = 'zentorno', price = 1650500 },
	{ name = 'FlashProtect', model = 'FlashProtect', price = 1150500 },
	{ name = 'Entity Super', model = 'entity2', price = 1375500 },
	{ name = 'Entity XF', model = 'entityxf', price = 640500 },
	{ name = 'FMJ', model = 'fmj', price = 1550500 },
	{ name = 'gp1', model = 'gp1', price = 715500 },
	{ name = 'Itali GTB', model = 'italigtb', price = 1535500 },
	{ name = '7B', model = 'le7b', price = 650500 },
	{ name = 'Pfister', model = 'pfister811', price = 735500 },
	{ name = 'SC1', model = 'sc1', price = 547500 },
	{ name = 'Tempesta', model = 'tempesta', price = 1350500 },
	{ name = 'Turismo', model = 'turismo2', price = 475500 },
	{ name = 'Baller Sport', model = 'baller3', price = 85000 },
	{ name = 'Dubsta', model = 'dubsta', price = 76000 },
	{ name = 'Dubsta Luxuary', model = 'dubsta2', price = 81000 },
	{ name = 'Huntley S', model = 'huntley', price = 54750 },
	{ name = 'Mesa', model = 'mesa', price = 57500 },
	{ name = 'Mesa Trail', model = 'mesa3', price = 70500 },
	{ name = 'Patriot', model = 'patriot', price = 90500 },
	{ name = 'Rocoto', model = 'rocoto', price = 115000 },
	{ name = 'Seven 70', model = 'seven70', price = 75500 },
	{ name = 'XLS', model = 'xls', price = 59500 },
	{ name = 'Baller Classic', model = 'baller', price = 78500 },
	{ name = 'Baller', model = 'baller2', price = 80500 },
	{ name = 'FQ2', model = 'fq2', price = 67500 },
	{ name = 'Granger', model = 'granger', price = 105000 },
	{ name = 'Gresley', model = 'gresley', price = 75500 },
	{ name = 'Habanero', model = 'habanero', price = 54500 },
	{ name = 'Bison', model = 'bison', price = 37500},
	{ name = 'Burrito', model = 'burrito', price = 22500},
	{ name = 'Burrito', model = 'burrito3', price = 22500 },
	{ name = 'Camper', model = 'camper', price = 30000 },
	{ name = 'Gang Burrito', model = 'gburrito', price = 35000 },
	{ name = 'Burrito', model = 'gburrito2', price = 37500 },
	{ name = 'Journey', model = 'journey', price = 19500 },
	{ name = 'Paradise', model = 'paradise', price = 21500 },
	{ name = 'Rumpo Trail', model = 'rumpo3', price = 41500 },
	{ name = 'Surfer', model = 'surfer', price = 27500 },
};