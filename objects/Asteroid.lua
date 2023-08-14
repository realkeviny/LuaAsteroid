local love = require "love"

function Asteroid(x,y,ast_size,level,debugging)
    debugging = debugging or false

local ASTEROID_VERTICE = 12
local ASTEROID_JAG = 0.5
local ASTEROID_SPEED = math.random(50) + (level * 2)

local vert = math.floor(math.random(ASTEROID_VERTICE + 1) + ASTEROID_VERTICE / 2)

local offset = {}   
for i = 1,vert + 1  do
    table.insert(offset,math.random() * ASTEROID_JAG * 2 + 1 - ASTEROID_JAG)
end

local velocity = -1
if math.random() < 0.5 then
    velocity = 1
end

return {
    x = x,
    y = y,
    x_velocity = math.random() * ASTEROID_SPEED * velocity,
    y_velocity = math.random() * ASTEROID_SPEED * velocity,
    radius = math.ceil(ast_size / 2),
    angle = math.rad(math.random(math.pi)),
    vert = vert,
    offset = offset,

    draw = function (self,faded)
        local opacity = 1

        if faded then
            opacity = 0.2
        end

        love.graphics.setColor(186 / 255,189 / 255,182 / 255,opacity)

        local points = {
            self.x + self.radius * self.offset[1] * math.cos(self.angle),
            self.y + self.radius * self.offset[1] * math.sin(self.angle),
        }

        for i = 1, self.vert - 1 do
            table.insert(points,self.x + self.radius * self.offset[i + 1] * math.cos(self.angle + i * math.pi * 2 / self.vert))
            table.insert(points,self.y + self.radius * self.offset[i + 1] * math.sin(self.angle + i * math.pi * 2 / self.vert))
        end

        love.graphics.polygon("line",points)

        if debugging then
            love.graphics.setColor(1,0,0)

            love.graphics.circle("line",self.x,self.y,self.radius)
        end
    end
}
end

return Asteroid