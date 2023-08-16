local love = require "love"

function Laser(x,y,angle)
    local LASER_SPEED = 450
    local explodingEnum = {
        not_exploding = 0,
        exploding = 1,
        exploded = 2
    }
    local EXPLODE_DURATION = 0.25

    return {
        x = x,
        y = y,
        x_velocity = LASER_SPEED * math.cos(angle) / love.timer.getFPS(),
        y_velocity = -LASER_SPEED * math.sin(angle) / love.timer.getFPS(),
        distance = 0,
        exploding = explodingEnum.not_exploding,
        explode_time = 0,

        draw = function (self,faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            if self.exploding < 1 then
                love.graphics.setColor(0,1,0,opacity)
    
                love.graphics.setPointSize(4)
    
                love.graphics.line(self.x,self.y,self.x + 10 * math.cos(angle),self.y - 10 * math.sin(angle))

            else
                love.graphics.setColor(1,104 / 255,0,opacity)
                love.graphics.circle("fill",self.x,self.y,7 * 1.7)    
                love.graphics.setColor(1,234 / 255,0,opacity)
                love.graphics.circle("fill",self.x,self.y,7)
            end

        end,

        move = function (self)
            self.x = self.x + self.x_velocity
            self.y = self.y + self.y_velocity

            if self.explode_time > 0 then
                self.exploding = explodingEnum.exploding
            end

            -- move the laser to the other side of the screen if it goes off the edge
            if self.x < 0 then
                self.x = love.graphics.getWidth()
            elseif self.x > love.graphics.getWidth() then
                self.x = 0
            end

            if self.y < 0 then
                self.y = love.graphics.getHeight()
            elseif self.y > love.graphics.getHeight() then
                self.y = 0
            end

            self.distance = self.distance + math.sqrt((self.x_velocity^2) + (self.y_velocity^2))
        end,

        explode = function (self)
            self.explode_time = math.ceil(EXPLODE_DURATION * (love.timer.getFPS() / 100))
            if self.explode_time > EXPLODE_DURATION then
                self.exploding = explodingEnum.exploded
            end
        end,
    }
end

return Laser