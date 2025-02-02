HemophiliaBaseGameCharacterDetails = {}

HemophiliaBaseGameCharacterDetails.DoTraits = function()

		local hemophilialite = TraitFactory.addTrait("HemophiliaLite", getText("UI_trait_hemophilialite"), -4, getText("UI_trait_hemophiliadesclite"), false);
		hemophilialite:addXPBoost(Perks.Doctor, 1)
		local hemophiliasevere = TraitFactory.addTrait("HemophiliaSevere", getText("UI_trait_hemophiliasevere"), -8, getText("UI_trait_hemophiliadescsevere"), false);
		hemophiliasevere:addXPBoost(Perks.Doctor, 1)
		TraitFactory.setMutualExclusive("HemophiliaLite", "HemophiliaSevere");

end

Events.OnGameBoot.Add(HemophiliaBaseGameCharacterDetails.DoTraits);
