-- main.lua
-- This is the main entry point for the LÖVE2D game.

-- Load the foundational files first
require 'engine/object'
require "engine/event"
require "engine/node"
require "engine/moveable"
require "engine/sprite"
require "functions/misc_functions"
require "game"
require "globals"

-- The love.load() function is called only once at the start of the game.
function love.load()
    G:start_up()
end

-- The love.update() function is called every frame.
-- 'dt' is the delta time, or the time since the last frame.
function love.update(dt)
    -- We simply delegate the update call to our Game object.
    G:update(dt)
end

-- The love.draw() function is called every frame after love.update().
function love.draw()
    -- We simply delegate the draw call to our Game object.
    G:draw()
end
