require 'Foraging/forageSystem'

Events.onAddForageDefs.Add(function()

    local AchilleaPlant = {
        type = "Hemophilia.Achillea",
        minCount = 4,
        maxCount = 10,
        xp = 15,
        recipes = {"Herbalist"},
        categories = {"MedicinalPlants"},
        zones = {
            Forest = 20,
            DeepForest = 25,
            Vegitation = 15,
            FarmLand = 10,
            Farm = 10
        },
        months = {3, 4, 5, 6, 7, 8, 9, 10, 11},
        bonusMonths = {6, 7, 8, 9},
        altWorldTexture = getTexture("media/textures/WorldItem/achilleaplantworld.png")
    };

    local HemophiliaLiteSkill = {
		name                    = "hemophilialite",
		type                    = "trait",
		visionBonus             = 0,
		weatherEffect           = 33,
		darknessEffect          = 15,
		specialisations         = {
			["MedicinalPlants"]     = 75,
            ["WildHerbs"]			= 50,
		},
	};

    local HemophiliaSevereSkill = {
		name                    = "hemophiliasevere",
		type                    = "trait",
		visionBonus             = 0,
		weatherEffect           = 33,
		darknessEffect          = 15,
		specialisations         = {
			["MedicinalPlants"]     = 95,
			["WildHerbs"]			= 60,
		},
	};

    forageSystem.addItemDef(AchilleaPlant);
    forageSystem.addSkillDef(HemophiliaLiteSkill);
    forageSystem.addSkillDef(HemophiliaSevereSkill);

    forageSystem.generateLootTable();

end)
