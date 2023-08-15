local love = require "love"

function Laser(x,y,angle)
    local LASER_SPEED = 450
    return {
        x = x,
        y = y,
        x_velocity = LASER_SPEED * math.cos(angle) / love.timer.getFPS(),
        y_velocity = -LASER_SPEED * math.sin(angle) / love.timer.getFPS(),
        distance = 0,

        draw = function (self,faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            love.graphics.setColor(0,1,0,opacity)

            love.graphics.setPointSize(4)

            love.graphics.line(self.x,self.y,self.x + 10 * math.cos(angle),self.y - 10 * math.sin(angle))
        end,

        move = function (self)
            self.x = self.x + self.x_velocity
            self.y = self.y + self.y_velocity

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
        end
    }
end

return Laser