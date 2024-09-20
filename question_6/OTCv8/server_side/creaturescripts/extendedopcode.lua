local OPCODE_LANGUAGE = 1
-- Make sure that 'creaturescripts.xml' have defined
-- <event type="extendedopcode" name="ExtendedOpcode" script="extendedopcode.lua" />
-- And loging.lua registers an event 	player:registerEvent("ExtendedOpcode") 
-- Definte tiles which should stop player's dash. These are choosed from tile.h file enum. 
local blocking_tiles = { 
    TILESTATE_PROTECTIONZONE, 
    TILESTATE_HOUSE, 
    TILESTATE_FLOORCHANGE, 
    TILESTATE_TELEPORT, 
    TILESTATE_BLOCKSOLID, 
    TILESTATE_BLOCKPATH }

-- Define unused extended opcode, which will be send in a packet to receiver.
local OPCODE_DASH = 15

function onExtendedOpcode(player, opcode, buffer)
	if opcode == OPCODE_LANGUAGE then
		-- otclient language
		if buffer == 'en' or buffer == 'pt' then
			-- example, setting player language, because otclient is multi-language...
			-- player:setStorageValue(SOME_STORAGE_ID, SOME_VALUE)
		end
	else
		-- other opcodes can be ignored, and the server will just work fine...
	end

-- Answer starts here
-- If received opcode equals to defined OPCODE, do further actions based on buffer. 
-- Basing on buffer we can do different actions.
	if opcode == OPCODE_DASH then
		if buffer == "doDash" then
            Dash(player)
            -- After dash is performed, reset shader to default.
			addEvent(function()  
				player:sendExtendedOpcode(OPCODE_DASH, 51)
			end, 800)

		end
	end

end

function Dash(player)
    -- Checks if the current tile prevents movement
    local function isTileBlocked(tile)
        for _, tilestate in pairs(blocking_tiles) do
            if tile:hasFlag(tilestate) then
                return true -- The tile has a blocking state.
            end
        end
        return false -- The tile does not block movement.
    end

    -- Executes the dash action, considering maximum distance allowed.
    local function performDash(maxDistance)
        local currentPosition = player:getPosition() -- Current player position.
        local direction = player:getDirection() -- Direction player is facing
        local targetPosition = currentPosition -- Initialize target position.
        
         -- Determine the target position based on maxDistance.
        for step = 1, maxDistance do
            local nextPosition = Position(currentPosition)
            nextPosition:getNextPosition(direction, step)
            local tile = Tile(nextPosition)
            -- If the next tile is blocked, end the loop.
            if not tile or isTileBlocked(tile) then
                break
            end
             -- Update the target position to the next position.
            targetPosition = nextPosition
        end

        -- Move the player to the target position if it's different from the current position.
        if currentPosition ~= targetPosition then
            player:teleportTo(targetPosition)  -- Teleport the player.
            player:sendExtendedOpcode(OPCODE_DASH, 50) -- Send success message. And change player's shader to outline 
        else
            player:sendCancelMessage("You cannot dash here.") -- Inform the player if dashing is not possible.
        end
    end

    -- Perform the initial 3-tile dash
    performDash(3)

    -- Perform additional 1-tile dashes with increasing delays.
    for i = 1, 3 do
        addEvent(function()
            performDash(1)
        end, i * 200)
    end
end


