require "ISUI/ISInventoryPaneContextMenu"

local contextHemophilia = {}

function contextHemophilia.addTakeFactorContext(player, context, items)
	for _, v in ipairs(items) do

		local item = v
		if not instanceof(v, "InventoryItem") then
			item = v.items[1]
		end
		local addOption = false
		local splayer = getSpecificPlayer(player);
		if item:getType() == "FactorVIII" then
			if splayer == nil then
				return
			end
			if splayer:HasTrait("HemophiliaSevere") or splayer:HasTrait("HemophiliaLite") then
				addOption = true
			end
		end
		if addOption then
			context:addOption(getText("ContextMenu_take_factorviii"), item, contextHemophilia.onTakeInjection, splayer)
			break
		end
	end
end

function contextHemophilia.onTakeInjection(factor, player)
	ISTimedActionQueue.add(ISInventoryTransferAction:new(player,factor,factor:getContainer(),player:getInventory(),10))
	ISTimedActionQueue.add(HemophiliaAction:new(player,170,factor))
end

Events.OnPreFillInventoryObjectContextMenu.Add(contextHemophilia.addTakeFactorContext)