function table.indexOf(table, value)
    for i = 1, #table do
        if (table[i] == value) then
            return i
        end
    end
    return -1
end

function table.push(table, value)
    table[#table + 1] = value
end

function table.splice(table, index, count)
    local result = {}
    for i = 1, count do
        result[i] = table[index + i - 1]
        table[index + i - 1] = nil
    end
    return result
end

function string.startsWith(str, start)
    return str:sub(1, #start) == start
end

function table.set(table, index, value)
    table[index] = value
end