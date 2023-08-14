local love = require "love"

local Text = require "../components/Text"

function Game()
    return {
        state = {
            menu = false,
            paused = false,
            running = true,
            ended = false
        },

        changeGameState = function (self,state)
            self.state.menu = state == "menu"
            self.state.paused  = state == "paused"
            self.state.running = state == "running"
            self.state.ended  = state == "ended"
        end,

        draw = function (self,faded)
            if faded then
                Text(
                    "Game Paused",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "s1",
                    false,
                    false,
                    love.graphics.getWidth(),
                    "center"
                ):draw()
            end
        end,


        startNewGame = function (self,player)
            self:changeGameState("running")

            _G.asteroid = {}
        end
    }
end

return Game