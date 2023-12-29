JerryCanCostFuel = 50
RefillCostFuell = 50 -- S'il lui manque la moitié de sa capacité, ce montant sera divisé en deux, et ainsi de suite.
FuelDecorFuel = "_FUEL_LEVEL"
DisableKeysFuells = {0, 22, 23, 24, 29, 30, 31, 37, 44, 56, 82, 140, 166, 167, 168, 170, 288, 289, 311, 323}

-- Modifiez ici le coût du carburant, en utilisant une valeur multiplicatrice. La valeur 2,0 entraînerait une double augmentation.
CostMultiplierFuel = 1.0

-- Configure the strings as you wish here.
StringsLocalFuel = {
	ExitVehicle = "Sortir du véhicule pour faire le plein",
	EToRefuel = "Appuyez sur ~r~E ~w~pour faire le plein du véhicule",
	JerryCanEmpty = "Le Bidon de JerryCan est vide",
	FullTank = "Le réservoir est plein",
	PurchaseJerryCan = "Appuyez sur ~r~E ~w~ pour acheter un jerrican de ~r~$" .. JerryCanCostFuel,
	CancelFuelingPump = "Appuyez sur ~r~E ~w~pour annuler le ravitaillement",
	CancelFuelingJerryCan = "Appuyez sur ~r~E ~w~pour annuler le ravitaillement",
	NotEnoughCash = "~r~Pas assez d'argent",
	RefillJerryCan = "Appuyez sur ~r~E ~w~ pour remplir le jerrican pour ",
	NotEnoughCashJerryCan = "Pas assez d'argent pour remplir le jerrican",
	JerryCanFull = "Le Bidon de JerryCan est deja plein",
	TotalCost = "Coût",
}

PumpModelsFuel = {
	[-2007231801] = true,
	[1339433404] = true,
	[1694452750] = true,
	[1933174915] = true,
	[-462817101] = true,
	[-469694731] = true,
	[-164877493] = true
}

-- Blacklist Vehicles avec le hash ou le nom "Adder" ou 1131912276 || https://wiki.gtanet.work/index.php?title=Vehicle_Models
BlacklistVehiculeFuel = {
	1131912276,
	448402357,
	-836512833,
	-186537451,
	1127861609,
	-1233807380,
	-400295096,
	-150975354
}

-- Multiplicateurs de classe. Si vous voulez que les SUV consomment moins de carburant, vous pouvez changer pour tout ce qui est inférieur à 1,0, et vice versa.
ClassesVeh = {
	[0] = 0.2, -- Compacts
	[1] = 0.2, -- Sedans
	[2] = 0.2, -- SUVs
	[3] = 0.2, -- Coupes
	[4] = 0.2, -- Muscle
	[5] = 0.2, -- Sports Classics
	[6] = 0.2, -- Sports
	[7] = 0.2, -- Super
	[8] = 0.2, -- Motorcycles
	[9] = 0.2, -- Off-road
	[10] = 0.2, -- Industrial
	[11] = 0.2, -- Utility
	[12] = 0.2, -- Vans
	[13] = 0.2, -- Cycles
	[14] = 0.2, -- Boats
	[15] = 0.2, -- Helicopters
	[16] = 0.2, -- Planes
	[17] = 0.2, -- Service
	[18] = 0.2, -- Emergency
	[19] = 0.2, -- Military
	[20] = 0.2, -- Commercial
	[21] = 0.2, -- Trains
}

-- La partie gauche correspond au pourcentage de tours/minute, et la partie droite à la quantité de carburant (divisée par 10) que vous voulez retirer du réservoir chaque seconde
FuelUsage = {
	[1.0] = 1.2,
	[0.9] = 1.0,
	[0.8] = 1.0,
	[0.7] = 0.9,
	[0.6] = 0.8,
	[0.5] = 0.7,
	[0.4] = 0.5,
	[0.3] = 0.4,
	[0.2] = 0.2,
	[0.1] = 0.1,
	[0.0] = 0.0,
}
