require "globals"

local love = require "love"
local Player = require "objects/Player"
local Game = require "states/Game"

math.randomseed(os.time())

function love.load()
    love.mouse.setVisible(false)
    _G.mouse_x, _G.mouse_y = 0, 0

    player = Player()
    game = Game()
    game:startNewGame(player)
end

function love.keypressed(key)
    if game.state.running then
        if key == "w" or key == "up" or key == "kp8" then
            player.thrusting = true
        end

        if key == "space" or key == "down" or key == "kp5" then
            player:shootLaser()
        end
        
        if key == "escape" then
            game:changeGameState('paused')
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState('running')
        end
    end
end

function love.keyreleased(key)
    if key == "w" or key == "up" or key == "kp8" then
        player.thrusting = false
    end
end

function love.mousepressed(x,y,button,istouch,presses)
    if button == 1 then
        if game.state.running then
            player:shootLaser()
        end
    end
end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()
    if game.state.running then
        player:move()

        for ast_index,asteroid in pairs(asteroids) do
            if not player.exploding then
                if calculateDistance(player.x,player.y,asteroid.x,asteroid.y) < asteroid.radius then
                    player:explode()
                    destroy_ast = true
                end
            else
                player.explode_time = player.explode_time - 1

                if player.explode_time == 0 then
                    if player.lives - 1 <= 0 then
                        game:changeGameState("ended")
                        return
                    end

                    player = Player(player.lives - 1)
                end
            end

            for _, laser in pairs(player.lasers) do
                if calculateDistance(laser.x,laser.y,asteroid.x,asteroid.y) < asteroid.radius then
                    laser:explode()
                    asteroid:destroy(asteroids,ast_index,game)
                end
            end

            if destroy_ast then
                if player.lives - 1 <= 0 then
                    if player.explode_time == 0 then
                        destroy_ast = false
                        asteroid:destroy(asteroids,ast_index,game)
                    end
                else
                    destroy_ast = false
                    asteroid:destroy(asteroids,ast_index,game)
                end
            end

            asteroid:move(dt)
        end
    end
end

function love.draw()
    if game.state.running or game.state.paused then
        player:drawLives(game.state.paused)
        player:draw(game.state.paused)

        for _,asteroid in pairs(asteroids) do
            asteroid:draw(game.state.paused)
        end

        game:draw(game.state.paused)
    end

    love.graphics.setColor(1,1,1,1)

    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
end