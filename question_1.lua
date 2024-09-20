-- Answer

--[[ 
Basing on codebase these keys are stored in storages.lua so to follow the pattern
we could put it there but for the sake of this question will define it here ]]--
-- Define constants so we can avoid magic numbers
local STORAGE_KEY = 1000 
local RESET_VALUE = -1
local RELEASE_DELAY = 1000 -- milliseconds. If delay is necessary. If there would be more addEvents with different delays, it could be better to not define it like this.


-- Called when a player logs out. Schedules the release of the player's storage if necessary.
function onLogout(player)
    if player:getStorageValue(STORAGE_KEY) == 1 then
        -- Assumning that we want to delay this operation.
        addEvent(function() 
                player:setStorageValue(STORAGE_KEY, RESET_VALUE)
                end, 
                RELEASE_DELAY)
    end
    return true
end


-- Question

local function releaseStorage(player)
player:setStorageValue(1000, -1)
end

function onLogout(player)
if player:getStorageValue(1000) == 1 then
addEvent(releaseStorage, 1000, player)
end
return true
end
