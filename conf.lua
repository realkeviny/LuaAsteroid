local love = require "love"

function love.conf(app)
    app.window.width = 1920
    app.window.height = 1200
    app.window.title = "Asteroids"
end