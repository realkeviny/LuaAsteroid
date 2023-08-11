---@diagnostic disable: lowercase-global
local love = require "love"

function Player(debugging)
    local SHIP_SIZE = 25
    local VIEW_ANGLE = math.rad(90)

    debugging = debugging or false

    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = SHIP_SIZE / 2,
        angle = VIEW_ANGLE,
        rotation = 0,
        thrusting = false,
        thrust = {
            x = 0,
            y = 0,
            speed = 6,
            large_flame = false,
            flame = 2.0
        },

        drawFlameThrust = function (self,fillType,color)
            love.graphics.setColor(color)
            love.graphics.polygon(fillType,
            self.x - self.radius * (2 / 3 * math.cos(self.angle) + 0.5 * math.sin(self.angle)),
            self.y + self.radius * (2 / 3 * math.sin(self.angle) - 0.5 * math.cos(self.angle)),
            self.x - self.radius * self.thrust.flame * math.cos(self.angle),
            self.y + self.radius * self.thrust.flame * math.sin(self.angle),
            self.x - self.radius * (2 / 3 * math.cos(self.angle) - 0.5 * math.sin(self.angle)),
            self.y + self.radius * (2 / 3 * math.sin(self.angle) + 0.5 * math.cos(self.angle))
        )
        end,

        draw = function (self)
            local opacity = 1

            if self.thrusting then
                if not self.thrust.large_flame then
                    self.thrust.flame = self.thrust.flame - 1 / love.timer.getFPS()

                    if self.thrust.flame < 1.5 then
                        self.thrust.large_flame = true
                    end
                else
                    self.thrust.flame = self.thrust.flame + 1 / love.timer.getFPS()

                    if self.thrust.flame > 2.5 then
                        self.thrust.large_flame = false
                    end
                end

                self:drawFlameThrust("fill",{255 / 255,92 / 255,10 / 255})
                self:drawFlameThrust("line",{1,0.16,0})
            end

            if debugging then
                love.graphics.setColor(0,0,1,opacity)

                love.graphics.rectangle("fill",self.x - 1,self.y - 1,2,2)

                love.graphics.circle("line",self.x,self.y,self.radius)
            end

            love.graphics.setColor(1,1,1,opacity)

            love.graphics.polygon("line",
            self.x + ((4 / 3) * self.radius) * math.cos(self.angle),
            self.y - ((4 / 3) * self.radius) * math.sin(self.angle),
            self.x - self.radius * (2 / 3 * math.cos(self.angle) + math.sin(self.angle)),
            self.y + self.radius * (2 / 3 * math.sin(self.angle) - math.cos(self.angle)),
            self.x - self.radius * (2 / 3 * math.cos(self.angle) - math.sin(self.angle)),
            self.y + self.radius * (2 / 3 * math.sin(self.angle) + math.cos(self.angle))
        )
        end,

        move = function (self)
            local FPS = love.timer.getFPS()
            local friction = 0.65

            self.rotation = 360 / 180 * math.pi / FPS

            if love.keyboard.isDown("a") or love.keyboard.isDown("left") or love.keyboard.isDown("kp4") then
                self.angle = self.angle + self.rotation
            end

            if love.keyboard.isDown("d") or love.keyboard.isDown("right") or love.keyboard.isDown("kp6") then
                self.angle = self.angle - self.rotation
            end

            if self.thrusting then
                self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.angle) / FPS
                self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.angle) / FPS
            else
                if self.thrust.x ~= 0 or self.thrust.y ~= 0 then
                    self.thrust.x = self.thrust.x - friction * self.thrust.x / FPS
                    self.thrust.y = self.thrust.y - friction * self.thrust.y / FPS
                end
            end

            self.x = self.x + self.thrust.x
            self.y = self.y + self.thrust.y

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
        end
    }
end

return Player