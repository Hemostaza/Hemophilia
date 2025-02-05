local function setWoundTime(bodyPart, randomTime)
    if bodyPart:getScratchTime() ~= 0 then
        bodyPart:setScratchTime(bodyPart:getScratchTime() + randomTime);
    end
    if bodyPart:getCutTime() ~= 0 then
        bodyPart:setCutTime(bodyPart:getCutTime() + randomTime);
    end
    if bodyPart:getBiteTime() ~= 0 then
        bodyPart:setBiteTime(bodyPart:getBiteTime() + randomTime);
    end
    if bodyPart:getDeepWoundTime() ~= 0 then
        bodyPart:setDeepWoundTime(bodyPart:getDeepWoundTime() + randomTime);
    end
    if bodyPart:getStitchTime() ~= 0 then
        bodyPart:setStitchTime(bodyPart:getStitchTime() + randomTime);
    end
    if bodyPart:getFractureTime() ~= 0 then
        bodyPart:setFractureTime(bodyPart:getFractureTime() + randomTime);
    end
end

local function isWounded(bodyPart)
	if bodyPart:getScratchTime() > 0 then
        return true;
    end
	if bodyPart:getCutTime() > 0 then
        return true;
    end
    if bodyPart:getBiteTime() > 0 then
        return true;
    end
    if bodyPart:getDeepWoundTime() > 0 then
        return true;
    end
	return false
end

local function hemophiliaBleedingTime()
    for playerIndex = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(playerIndex);

        if player == nil then
            return
        end
        if player:HasTrait("HemophiliaSevere") or player:HasTrait("HemophiliaLite") then
            -- Gracz ma hemofilie więc odczyniamy maniane
            local playerdata = player:getModData();
            local bodydamage = player:getBodyDamage();
            local factorVIIIHours = playerdata.FactorVIIIHours;
            local bodyParts = bodydamage:getBodyParts();
            -- Jak jest podany czynnik to w chuju cały ten proces niżej pierdolić
            if factorVIIIHours > 0 then
                return
            end
            -- im mniejszy multipler tym wiekszy random krwawienia.
            local multipler = 60;
            if player:HasTrait("HemophiliaSevere") then
                multipler = 35;
            end
            -- print(bodyParts:size());
            -- sprawdź najpierw czy pędzel w ogóle krwawi kurwa mać reloaduj sie
            for bodyPartIndex = 0, bodyParts:size() - 1 do
                local bodyPart = bodyParts:get(bodyPartIndex)
                --sprawdź czy jest obrażenie jakeis na konczynie
                if isWounded(bodyPart) then
                    --sprawdź czy już nie krwawi
                    if (bodyPart:getBleedingTime() <= 0) then
                        -- print("Uszkodzenie kutasa poziom over 9999");
                        -- Możliwość ponownego otwarcia ran i chuj xD
                        local rand = ZombRand(-100, 100);
                        --print("randomowa wartosc do otwarcia rany xD ",rand)
                        if rand >= multipler then
                            --print("Ponowne krawienie łooo ", rand);
                            --bodyPart:setBleeding(true);
                            bodyPart:setBleedingTime(25/rand);
                        end
                    end

                end
                -- Dopiero jak krwawi to zacznij rozkminiaj czas krwawienia kurwiu
                if bodyPart:getBleedingTime() > 0 then
                    -- losowa liczba dodana do czasu krwawienia podzielona przez mocność hemofilii
                    local rand = ZombRand(3, 15) / multipler;
                    --print("Wydłużenie czasu krwawienia o ", rand)
                    local bleedingTime = bodyPart:getBleedingTime() + rand;
                    -- ustawienie tego w kończynie
                    bodyPart:setBleedingTime(bleedingTime)
                    --print("wydłużenie czasu gojenia się rany o ", rand)
                    setWoundTime(bodyPart, rand);
                end
            end
        end
    end
end

function takeFactorVIII(player)
    local playerdata = player:getModData();
    playerdata.FactorVIIIHours = ZombRand(9,12);
end

local function factorreduction()
    for playerIndex = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(playerIndex);

        if player == nil then
            return
        end
        if player:HasTrait("HemophiliaSevere") or player:HasTrait("HemophiliaLite") then
            local factorVIIIHours = player:getModData().FactorVIIIHours;
            if factorVIIIHours == nil then
                return
            end
            if factorVIIIHours > 0 then
                --print("ile ma czynnika", factorVIIIHours);
                factorVIIIHours = factorVIIIHours - 1;
                player:getModData().FactorVIIIHours = factorVIIIHours;
            end
        end
    end
end

local function initialize(playerIndex, player)
    -- for playerIndex = 0, getNumActivePlayers()-1 do
    -- local player = getSpecificPlayer(playerIndex);	

    if player == nil then
        return
    end
    local playerdata = player:getModData();
    local getOnStart
    if player:HasTrait("HemophiliaSevere") or player:HasTrait("HemophiliaLite") then
        if playerdata.FactorVIIIHours == nil then
            --print("Factor hours = null ")
            playerdata.FactorVIIIHours = 0
            local inventory = player:getInventory();
            inventory:addItem(inventory:AddItem("Hemophilia.FactorVIII"));
            if player:HasTrait("HemophiliaSevere") then
                inventory:addItem(inventory:AddItem("Hemophilia.FactorVIII"));
            end
        end
        --print("Factor hours ",playerdata.FactorVIIIHours)
    end
    -- end
end

Events.OnCreatePlayer.Add(initialize);

Events.EveryTenMinutes.Add(hemophiliaBleedingTime);
Events.EveryHours.Add(factorreduction);
