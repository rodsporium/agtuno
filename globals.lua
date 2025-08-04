-- globals.lua
-- This file defines the global 'G' table which will hold all our game-wide data.

function set_globals()
    player = {}
    player.x = 200
    player.y = 200
    player.spriteSheet = love.graphics.newImage('resources/textures/1x/8bitdeck.png')

    background = love.graphics.newImage('resources/textures/1x/battlefield.png')
end