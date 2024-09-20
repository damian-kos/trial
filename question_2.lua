-- Answer
function printSmallGuildNames(memberCount)
	-- Direct string concatenation is used here to construct the SQL query.
    -- This approach is consistent with the rest of the codebase.
    local resultId = db.storeQuery("SELECT `name` FROM `guild` WHERE `max_members` < " .. memberCount)
    -- Check if the query successfully returned a result set.
    if resultId ~= false then
        -- Use a repeat-until loop to iterate through all rows in the result set.
        repeat
            -- Retrieve the 'name' field from the current row in the result set.
            local guildName = result.getString(resultId, "name")

            -- Print the guild name to the console or output.
            print(guildName)

        -- Continue to the next row. The loop ends when there are no more rows (result.next(resultId) returns false).
        until not result.next(resultId)

        -- Free the resources associated with the result set after processing all rows.
        result.free(resultId)
    end
	
end

-- Question
function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
    local guildName = result.getString("name")
    print(guildName)
    end
    