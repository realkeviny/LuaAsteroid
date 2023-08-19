ASTEROID_SIZE = 150
show_debugging = false
destroy_ast = false


function calculateDistance(x1,y1,x2,y2)
    local dist_X = (x2 - x1) ^ 2
    local dist_Y = (y2 - y1) ^ 2
    return math.sqrt(dist_X + dist_Y)
end