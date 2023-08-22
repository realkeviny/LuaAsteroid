local lunajson = require "dependencies/lunajson"

ASTEROID_SIZE = 150
show_debugging = false
destroy_ast = false


function calculateDistance(x1,y1,x2,y2)
    local dist_X = (x2 - x1) ^ 2
    local dist_Y = (y2 - y1) ^ 2
    return math.sqrt(dist_X + dist_Y)
end

function readJSON(fileName) -- save -> /src/data/save.json
    local file = io.open("src/data/" .. fileName .. ".json","r")
    local data = file:read("*all")
    file:close()

    return lunajson.decode(data)
end

function writeJSON(fileName,data) -- save -> /src/data/save.json
    local file = io.open("src/data/" .. fileName .. ".json","w")
    if file ~= nil then
        file:write(lunajson.encode(data))
        file:close()
    end
end