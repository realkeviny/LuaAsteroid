local love = require "love"

local Text = require "../components/Text"
local Asteroid = require "../objects/Asteroid"

function Game()
    return {
        level = 1,
        state = {
            menu = true,
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

            _G.asteroids = {}

            local aster_X = math.floor(math.random(love.graphics.getWidth()))
            local aster_Y = math.floor(math.random(love.graphics.getHeight()))
            table.insert(asteroids,1,Asteroid(aster_X,aster_Y,100,self.level))
        end
    }
end

return Game