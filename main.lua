-- main.lua
-- This is the main entry point for the LÖVE2D game.

-- Load the foundational files first
require "engine/object"
require "engine/controller"
require "engine/node"
require "engine/moveable"
require "engine/sprite"
require "engine/event"
require "functions/misc_functions"
require "game"
require "globals"
require "card"
require "cardarea"

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

-- NEW: This function is called by LÖVE when a mouse button is pressed.
function love.mousepressed(x, y, button)
    -- We pass the event directly to our global controller.
    if G.CONTROLLER then
        G.CONTROLLER:mousepressed(x, y, button)
    end
end

-- NEW: This function is called by LÖVE when a mouse button is released.
function love.mousereleased(x, y, button)
    -- We pass the event directly to our global controller.
    if G.CONTROLLER then
        G.CONTROLLER:mousereleased(x, y, button)
    end
end