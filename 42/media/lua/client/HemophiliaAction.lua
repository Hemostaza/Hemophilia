HemophiliaAction = ISBaseTimedAction:derive("HemophiliaAction")
require "HemophiliaMainFile"

function HemophiliaAction:isValidStart()
	return self.character:HasTrait("HemophiliaSevere") or  self.character:HasTrait("HemophiliaLite")
end

function HemophiliaAction:isValid()
	if self.item:getRequireInHandOrInventory() then
		if not self:getRequiredItem() then
			return false
		end
	end
	return self.character:getInventory():contains(self.item);
end

function HemophiliaAction:update()
	-- if self.item then
        -- self.item:setJobDelta(0.0);
    -- end
end

function HemophiliaAction:start()
	print("start!");
	self:setActionAnim("takeinjection");
	if self.item then
        self.item:setJobDelta(0.0);
    end
end

function HemophiliaAction:stop()
	print("stop!");
	ISBaseTimedAction.stop(self);
	if self.item then
        self.item:setJobDelta(0.0);
    end
end

function HemophiliaAction:perform()
	print("perform!");
    ISBaseTimedAction.perform(self);
	takeFactorVIII(self.character);
	self.item:getContainer():setDrawDirty(true);
	if self.item then
        self.character:removeFromHands(self.item)
		self.character:getInventory():Remove(self.item)
    end
end

function HemophiliaAction:new(character, time, item)	
	local o = {};
	setmetatable(o, self);
	self.__index = self;
	o.character = character;
	o.item = item;
	o.maxTime = time;
	o.stopOnWalk = true;
    o.stopOnRun = true;
	return o;
end