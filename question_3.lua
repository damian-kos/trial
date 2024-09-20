-- Answer
-- More descriptive function name.
-- It tries to remove a player by its name from a party, by a player of playerId

function removePartyMember(playerId, memberName)
   -- Attempt to load the player object using the provided playerId. If not found, exit function.
   local player = Player(playerId)
   if player == nil then
       -- The player with the given ID could not be found, hence cannot proceed.
       return false
   end

   -- Retrieve the party object associated with the player. If player is not in a party, return false.
   local party = player:getParty()
   if party == nil then
       -- The player is not part of any party, so there's no party to remove a member from.
       return false
   end

   -- Optional: To ensure only the party leader can remove members, uncomment the following:
   -- if player ~= party:getLeader() then
   --    return false
   -- end

   -- Iterate through the list of party members to find a match by name.
   for _, member in ipairs(party:getMembers()) do 
       if member:getName() == memberName then 
           -- Matching member found; proceed to remove the member from the party.
           party:removeMember(member)
           -- Member successfully removed; success and exit.
           return true
       end
   end

   -- No party member matched the provided name; failure to remove.
   -- return false
end


-- Question
function do_sth_with_PlayerParty(playerId, membername)
    player = Player(playerId)
    local party = player:getParty()
    
    for k,v in pairs(party:getMembers()) do 
        if v == Player(membername) then 
            party:removeMember(Player(membername))
        end
    end
end