local love = require "love"
require "globals"

local Text = require "../components/Text"
local Asteroid = require "../objects/Asteroid"

function Game(saveData)
    return {
        level = 1,
        state = {
            menu = true,
            paused = false,
            running = false,
            ended = false
        },
        score = 0,
        highScore = saveData.highScore or 0,
        screenText = {},
        gameOverShowing = false,

        saveGame = function (self)
            writeJSON("save",{
                highScore = self.highScore
            })
        end,

        changeGameState = function (self,state)
            self.state.menu = state == "menu"
            self.state.paused  = state == "paused"
            self.state.running = state == "running"
            self.state.ended  = state == "ended"

            if self.state.ended then
                self:gameOver()
            end
        end,

        gameOver = function (self)
            self.screenText = {
                Text(
                    "Game Over",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "s1",
                    true,
                    true,
                    love.graphics.getWidth(),
                    "center"
                )
            }

            self.gameOverShowing = true

            self:saveGame()
        end,

        draw = function (self,faded)
            local opacity = 1

            if faded then
                opacity = 0.5
            end

            for index, text in pairs(self.screenText) do
                if self.gameOverShowing then
                    self.gameOverShowing = text:draw(self.screenText,index)

                    if not self.gameOverShowing then
                        self:changeGameState("menu")
                    end
                else
                    text:draw(self.screenText,index)
                end
            end

            Text("Score: " .. self.score,-20,10,"s4",false,false,love.graphics.getWidth(),"right",faded and opacity or 0.6):draw()
            Text("High Score: " .. self.highScore,0,10,"s5",false,false,love.graphics.getWidth(),"center",faded and opacity or 0.5):draw()

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
            if player.lives <= 0 then
                self:changeGameState("ended")
            else
                self:changeGameState("running")
            end

            local num_asteroids = 0

            _G.asteroids = {}

            self.screenText = {
                Text(
                    "Level " .. self.level,
                    0,
                    love.graphics.getHeight() * 0.25,
                    "s1",
                    true,
                    true,
                    love.graphics.getWidth(),
                    "center"
                )
            }

            for i = 1, num_asteroids + self.level do
                local aster_X
                local aster_Y

                repeat
                    aster_X = math.floor(math.random(love.graphics.getWidth()))
                    aster_Y = math.floor(math.random(love.graphics.getHeight()))  
                until calculateDistance(player.x,player.y,aster_X,aster_Y) > ASTEROID_SIZE * 2 + player.radius

                table.insert(asteroids,1,Asteroid(aster_X,aster_Y,ASTEROID_SIZE,self.level))
            end
        end
    }
end

return Game