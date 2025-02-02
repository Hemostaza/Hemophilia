--HemophiliaMainFile = {};

local function setWoundTimes(bodydamage,pd)
	local woundStartTime = pd.HemophiliaWoundsTimes;
	
	for n = 0, bodydamage:getBodyParts():size() - 1 do
		local bp = bodydamage:getBodyParts():get(n);
			if bp:getScratchTime() ~= 0 then
				if woundStartTime[n]==0 then
					woundStartTime[n] = bp:getScratchTime();
				end
				bp:setScratchTime(woundStartTime[n]);
			end
			--if bp:isCut() then
				if bp:getCutTime() ~= 0 then
					if woundStartTime[n]==0 then
						woundStartTime[n] = bp:getCutTime();
					end
					bp:setCutTime(woundStartTime[n]);
				end
			--end
			--if bp:bitten() then
				if bp:getBiteTime() ~= 0 then
					if woundStartTime[n]==0 then
						woundStartTime[n] = bp:getBiteTime();
					end
					bp:setBiteTime(woundStartTime[n]);
				end
			--end
			--if bp:isDeepWounded() then
				if bp:getDeepWoundTime() ~= 0 then
					if woundStartTime[n]==0 then
						woundStartTime[n] = bp:getDeepWoundTime();
					end
					bp:setDeepWoundTime(woundStartTime[n]);
				end
			--end
			--if bp:stitched() then
				if bp:getStitchTime() ~= 0 then
					if woundStartTime[n]==0 then
						woundStartTime[n] = bp:getStitchTime();
					end
					bp:setStitchTime(woundStartTime[n]);
				end
			--end
			if bp:getFractureTime() ~= 0 then
					if woundStartTime[n]==0 then
						woundStartTime[n] = bp:getFractureTime();
					end
				bp:setFractureTime(woundStartTime[n]);
			end
		--else woundStartTime[n]=0;
		--end
	end
end

local function hemophiliaBleedingTime()
	for playerIndex = 0, getNumActivePlayers()-1 do
    local player = getSpecificPlayer(playerIndex);	
	
	if player == nil then
		return
	end	
	local playerdata = player:getModData();
	local bodydamage = player:getBodyDamage();
	local factorVIIIHours = playerdata.FactorVIIIHours;
	local bleedingtimes = playerdata.HemophiliaHealingTimes;
	local woundStartTime = playerdata.HemophiliaWoundsTimes
	if player:HasTrait("HemophiliaSevere") then
		for n = 0, bodydamage:getBodyParts():size() - 1 do
			local i = bodydamage:getBodyParts():get(n);
			local v = bleedingtimes;
			local w = woundStartTime;
			if v[n] == 0 then
				v[n] = i:getBleedingTime()*2; 
				i:setBleedingTime(v[n]);
			end
			if i:getBleedingTime() ~= 0 then
				if factorVIIIHours  <= 2 then
					i:setBleedingTime(v[n]);
					setWoundTimes(bodydamage,playerdata);
				else 
					i:setBleedingTime(i:getBleedingTime()-(ZombRand(1,15)/100));
					v[n] = i:getBleedingTime(); --reset start bleeding time when have factor viii
					-- w[n] = 0; --don't know if I want that
				end
			end
			if i:getBleedingTime() <= 0 or i:getBleedingTime() == nil then
				w[n] = 0;
				v[n] = 0;
				playerdata.HemophiliaWoundsTimes = w;
				playerdata.HemophiliaHealingTimes = v;
			end
		end
	end
	if player:HasTrait("HemophiliaLite") then 
		for n = 0, bodydamage:getBodyParts():size() - 1 do
			local i = bodydamage:getBodyParts():get(n);
			local v = bleedingtimes;
			local w = woundStartTime;
			if v[n] == 0 then
				v[n] = i:getBleedingTime()*1.5; 
				i:setBleedingTime(v[n]);
			end
			if i:getBleedingTime() ~= 0 then
				if factorVIIIHours  <= 0 then
					setWoundTimes(bodydamage,playerdata);
					i:setBleedingTime(i:getBleedingTime()+(ZombRand(2,30)/100));
				else
					i:setBleedingTime(i:getBleedingTime()-(ZombRand(1,15)/100));
					v[n] = i:getBleedingTime();
					w[n] = 0; --here I know I want that
				end
			end
			if i:getBleedingTime() >= 200 then i:setBleedingTime(v[n]); end
			if i:getBleedingTime() <= 0 or i:getBleedingTime() == nil then
				w[n] = 0;
				v[n] = 0;
				playerdata.HemophiliaWoundsTimes = w;
				playerdata.HemophiliaHealingTimes = v;
			end
		end
	end
	end
end

function takeFactorVIII(player)
	local playerdata = player:getModData();
	playerdata.FactorVIIIHours = 10;
end

local function factorreduction()
	for playerIndex = 0, getNumActivePlayers()-1 do
    local player = getSpecificPlayer(playerIndex);	
	
	if player == nil then
		return
	end	
	if player:HasTrait("HemophiliaSevere") or  player:HasTrait("HemophiliaLite") then
		local factorVIIIHours = player:getModData().FactorVIIIHours;
		if factorVIIIHours == nil then return end
		if factorVIIIHours > 0 then
			factorVIIIHours = factorVIIIHours - 1;
			player:getModData().FactorVIIIHours = factorVIIIHours;
		end
	end
	end
end

local function initialize(playerIndex, player)
	--for playerIndex = 0, getNumActivePlayers()-1 do
    --local player = getSpecificPlayer(playerIndex);	
	
	if player == nil then
		return
	end	
	local playerdata = player:getModData();
	local getOnStart
	if player:HasTrait("HemophiliaSevere") or  player:HasTrait("HemophiliaLite") then
		if playerdata.FactorVIIIHours == nil then playerdata.FactorVIIIHours = 0 end
		if playerdata.HemophiliaHealingTimes == nil or playerdata.HemophiliaWoundsTimes == nil then
			local bt = {};
			local wt = {};
			for i = 0, player:getBodyDamage():getBodyParts():size() - 1 do
				bt[i] = 0;
				wt[i] = 0;
			end
			playerdata.HemophiliaHealingTimes = bt;
			playerdata.HemophiliaWoundsTimes = wt;
			local inventory = player:getInventory();
			if player:HasTrait("HemophiliaLite") then 
				inventory:addItem(inventory:AddItem("Hemophilia.FactorVIII"));
			end
			if player:HasTrait("HemophiliaSevere") then
				inventory:addItem(inventory:AddItem("Hemophilia.FactorVIII"));
				inventory:addItem(inventory:AddItem("Hemophilia.FactorVIII"));
			end
		end
	end
	--end
end

Events.OnCreatePlayer.Add(initialize);

Events.EveryTenMinutes.Add(hemophiliaBleedingTime);
Events.EveryHours.Add(factorreduction);
