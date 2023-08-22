require "globals"
local love = require "love"

function Asteroid(x,y,ast_size,level)

local ASTEROID_VERTICE = 12
local ASTEROID_JAG = 0.6
local ASTEROID_SPEED = math.random(50) + (level * 4) + 10

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

        if show_debugging then
            love.graphics.setColor(1,0,0)

            love.graphics.circle("line",self.x,self.y,self.radius)
        end
    end,

    move = function(self,dt)
        self.x = self.x + self.x_velocity * dt
        self.y = self.y + self.y_velocity * dt

        if self.x + self.radius < 0 then
            self.x = love.graphics.getWidth() + self.radius
        elseif self.x - self.radius > love.graphics.getWidth() then
            self.x = -self.radius
        end

        if self.y + self.radius < 0 then
            self.y = love.graphics.getHeight() + self.radius
        elseif self.y - self.radius > love.graphics.getHeight() then
            self.y = -self.radius
        end
    end,

    destroy = function (self,asteroids_tbl,index,game)
        local MIN_ASTEROID_SIZE = math.ceil(ASTEROID_SIZE / 8)

        if self.radius > MIN_ASTEROID_SIZE then
            table.insert(asteroids_tbl,Asteroid(self.x,self.y,self.radius,game.level))
            table.insert(asteroids_tbl,Asteroid(self.x,self.y,self.radius,game.level))
        end

        if self.radius >= ASTEROID_SIZE / 2 then
            game.score = game.score + 20
        elseif self.radius <= MIN_ASTEROID_SIZE then
            game.score = game.score + 120
        else
            game.score = game.score + 60
        end

        if game.score > game.highScore then
            game.highScore = game.score
        end

        table.remove(asteroids_tbl,index)
    end
}
end

return Asteroid