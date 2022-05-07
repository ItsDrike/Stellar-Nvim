local M = {}


--- Find the first entry for which the predicate returns true.
-- @generic K, V
-- @param tbl table<K, V>
-- @param predicate fun(entry:V):bool @Called for each entry of the table
-- @return V @The entry for which the predicate returned true, otherwise nil
function M.find_first(tbl, predicate)
    for _, entry in pairs(tbl) do
        if predicate(entry) then
            return entry
        end
    end
    return nil
end


-- Check if given table contains a given value
-- @generic K, V
-- @param tbl table<K, V>
-- @param value V
-- @return bool @does table contain given value
function M.contains(tbl, value)
    local ret = M.find_first(tbl, function(val)
        return val == value
    end)
    return ret ~= nil
end


-- Get the length of a given table
-- @param tbl table
-- @return int @amount of elements in a table
function M.len(tbl)
    local count = 0
    for _ in pairs(tbl) do
        count = count + 1
    end
    return count
end


--Print an arbitrary table in readable form
-- @param tbl table
-- @param max_depth int @How many tables deep should we go (all the way if nil)
function M.print_table(tbl, max_depth)
    -- Make a string of n tabs
    local function tab(amt)
        local str = ""
        for _ = 1, amt do
            str = str .. "\t"
        end
        return str
    end

    -- Wraps a string in quotes safely (escaping \ and quotes)
    local function wrap_str(str)
        local single_quotes = 0
        local double_quotes = 0
        for i = 1, #str do
            local c = str:sub(i,i)
            if c == "'" then
                single_quotes = single_quotes + 1
            elseif c == '"' then
                double_quotes = double_quotes + 1
            end
        end

        -- Always prefer the option where we escape less, if that's neither, use single quotes
        local wrap_char
        if single_quotes > double_quotes then
            wrap_char = '"'
            str = str:gsub([["]], [[\"]])
        else
            wrap_char = "'"
            str = str:gsub([[']], [[\']])
        end

        return wrap_char .. str:gsub([[\]], [[\\]]) .. wrap_char
    end

    -- Convert arbitrary object that's not a table to a string
    local function to_str(x)
        if M.contains({"number", "boolean", "function", "nil", "userdata", "thread"}, type(x)) then
            return tostring(x)
        elseif type(x) == "string" then
            return wrap_str(x)
        elseif type(x) == "table" then
            error("to_str function doesn't support tables!")
        end
    end

    -- This function takes a single `node` parameter which is a table and creates a nicely formatted, printable string
    -- representing this table. The other parameters are used for the recursive calls and they shouldn't be specified
    -- initially.
    local function table_to_str(node, output, depth)
        depth = depth or 1
        output = output or {}

        if max_depth ~= nil and depth > max_depth then
            table.insert(output, tab(depth) .. "...")
            return
        end

        -- If we're at depth 1, this is the initial call
        local initial = depth == 1

        -- Insert the starting {
        if initial then
            table.insert(output, "{")
        end

        for k, v in pairs(node) do
            local key = '[' .. to_str(k) .. ']'

            if type(v) ~= "table" then
                table.insert(output, tab(depth) .. key .. " = " .. to_str(v))
            else
                -- If next table would surpass the max depth, just add {...}
                if max_depth ~= nil and depth + 1 > max_depth then
                    table.insert(output, tab(depth) .. key .. " = {...}")
                else
                    table.insert(output, tab(depth) .. key .. " = {")
                    table_to_str(v, output, depth + 1)
                    table.insert(output, tab(depth) .. "}")
                end
            end
        end

        if initial then
            -- Insert the ending }
            table.insert(output, "}")

            -- Perform the actual concatenation here, only on the initial call. We do this because lua strings are
            -- immutable and concating them is expensive, whereas simply inserting to a mutable table is way faster.
            -- This way, we only perform the concat operation once, when all of the lines are ready.
            return table.concat(output, "\n")
        end
    end

    print(table_to_str(tbl))
end

return M
