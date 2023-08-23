local love = require "love"

local Button = require "components.Button"

function Menu(game,player,sfx)
    local funcs = {
        newGame = function ()
            game:startNewGame(player)
        end,
        quitGame = function ()
            love.event.quit()
        end
    }

    local buttons = {
        Button(funcs.newGame,nil,{r = 75 / 255,g = 75 / 255,b = 75 / 255},love.graphics.getWidth() / 3, 50,"New Game","center","s3",love.graphics.getWidth() / 3,love.graphics.getHeight() * 0.25),
        Button(nil,nil,{r = 75 / 255,g = 75 / 255,b = 75 / 255},love.graphics.getWidth() / 3, 50,"Settings","center","s3",love.graphics.getWidth() / 3,love.graphics.getHeight() * 0.4),
        Button(funcs.quitGame,nil,{r = 75 / 255,g = 75 / 255,b = 75 / 255},love.graphics.getWidth() / 3, 50,"Quit","center","s3",love.graphics.getWidth() / 3,love.graphics.getHeight() * 0.55),
    }

    return {
        focused = "",

        run = function (self,clicked)
            local mouse_x,mouse_y = love.mouse.getPosition()

            for name, button in pairs(buttons) do
                if button:checkHover(mouse_x,mouse_y,10) then
                    sfx:playFX("select","single")

                    if clicked then
                        button:click()
                    end

                    self.focused = name

                    button:setTextColor(0.8,0.2,0.2)
                else
                    if self.focused == name then
                        sfx:setFXPlayed(false)
                    end
                    button:setTextColor(1,1,1)
                end
            end
        end,

        draw = function (self)
            for _, button in pairs(buttons) do
                button:draw()
            end
        end
    }
end

return Menu