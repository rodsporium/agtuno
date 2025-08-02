-- main.lua
-- This is the main entry point for the LÖVE2D game.

-- Load the foundational files first
require "game"
require "globals"

-- The love.load() function is called only once at the start of the game.
function love.load()
    start_up()
end

-- The love.update() function is called every frame.
-- 'dt' is the delta time, or the time since the last frame.
function love.update(dt)
    update(dt)
end

-- The love.draw() function is called every frame after love.update().
function love.draw()
    draw()
end
