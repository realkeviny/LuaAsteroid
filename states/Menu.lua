local love = require "love"

local Button = require "components.Button"

function Menu(game,player)
    local buttons = {
        Button(nil,nil,{r = 75 / 255,g = 75 / 255,b = 75 / 255},love.graphics.getWidth() / 3, 50,"New Game","center","s3",love.graphics.getWidth() / 3,love.graphics.getHeight() * 0.25)
    }

    return {
        draw = function (self)
            for _, button in pairs(buttons) do
                button:draw()
            end
        end
    }
end

return Menu