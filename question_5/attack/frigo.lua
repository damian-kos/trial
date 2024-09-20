--[[
Related to line 71 of spells.xml
	</instant>
		<instant group="attack" spellid="179" name="Frigo Winter" words="frigo" level="8" mana="0" premium="0" cooldown="1" groupcooldown="1" needlearn="1" script="attack/frigo.lua">
		<vocation name="Druid" />
		<vocation name="Elder Druid" />
	</instant>
]]--

-- Initialize table to hold combat objects for different area effects.
local combats = {}
-- Define parameters for all combat objects.
for i = 1, 6 do
	combats[i] = Combat()
	combats[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
	combats[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
end
-- Define areas for each combat object. Each array represents a pattern for the area effect.
-- 0 indicates no effect, 1 indicates the affected area, and 2 is the center point or starting point of the effect and it doesn't show on player's character unlike it would with 3
local combat_areas = {
    { -- Combat1
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {1, 0, 0, 2, 0, 0, 1},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0}
    },
	{ -- Combat2
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 2, 0, 0, 0},
		{0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0}
	},
	{ -- Combat3
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 2, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0}
	},
	{ -- Combat4
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0},
		{0, 0, 0, 2, 0, 0, 0},
		{0, 0, 0, 1, 0, 1, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0}
	},
	{ -- Combat5
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 2, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0}
	},
	{ -- Combat6
		{0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0},
		{0, 0, 1, 2, 1, 0, 0},
		{0, 0, 0, 0, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0, 0}
	}
}

-- Assign combat areas to the respective combats.
for index, area in ipairs(combat_areas) do
    combats[index]:setArea(createCombatArea(area))
end

-- Calculate min - max damage for a player
function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 8) + 50
	local max = (level / 5) + (magicLevel * 12) + 75
	return -min, -max
end

-- We need this because we can't use the same callback on multiple combats. 
-- With load(string.dump(callback)) we can copy it and bind to combat without losing inital callback.
function Combat.setCallbackFunction(self, event, callback)
    temporaryCallbackFunction = load(string.dump(callback))
    self:setCallback(event, "temporaryCallbackFunction") 
end

-- Assign copied values from function to combat objects
for i = 1, 6 do
    combats[i]:setCallbackFunction(CALLBACK_PARAM_LEVELMAGICVALUE, onGetFormulaValues)
end

local delays = {0 , 0.3, 0.5, 0.8}
-- Function to execute when spell is cast.
function onCastSpell(creature, var)
    doCombat(creature, combats[1], var)
	-- Casts of animation put in loop, so each of them can be fired in proper order.
	for i = 0, 2  do
		addEvent(function()  combats[1]:execute(creature, var) end, (i + delays[1]) * 1000) -- we use funcion() -- end, as doCombat would remove combat object and we couldn't reuse it
		addEvent(function()  combats[2]:execute(creature, var) end, (i + delays[1]) * 1000)
		addEvent(function()  combats[3]:execute(creature, var) end, (i + delays[2]) * 1000)
		addEvent(function()  combats[4]:execute(creature, var) end, (i + delays[2]) * 1000)
		addEvent(function()  combats[5]:execute(creature, var) end, (i + delays[3]) * 1000)
		addEvent(function()  combats[6]:execute(creature, var) end, (i + delays[4]) * 1000)
	end
    return true
 end

