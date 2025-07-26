-- main.lua
-- This is the main entry point for the LÖVE2D game.

-- Load our other files. The order is important.
-- Class must come first so the other files can use it.
require 'class'
require 'globals'
require 'game'

-- The love.load() function is called only once at the start of the game.
function love.load()
    -- Create a new instance of our Game object.
    -- This will call Game:init() and Game:set_globals()
    GameInstance = Game:new()

    -- Now that the game object is created, run its startup sequence.
    GameInstance:start_up()

    -- Set a default font for drawing text
    love.graphics.setFont(love.graphics.newFont(24))
end

-- The love.update() function is called every frame.
-- 'dt' is the delta time, or the time since the last frame.
function love.update(dt)
    -- We simply delegate the update call to our Game object.
    GameInstance:update(dt)
end

-- The love.draw() function is called every frame after love.update().
function love.draw()
    -- Set a background color
    love.graphics.setBackgroundColor(G.C.GREY)

    -- Set the drawing color to white
    love.graphics.setColor(G.C.WHITE)

    -- We simply delegate the draw call to our Game object.
    GameInstance:draw()
end

-- This is a helper function for handling key presses
function love.keypressed(key)
    -- This makes the 'wasPressed' function work
    love.keyboard.wasPressed = function(key)
        return love.keyboard.keysPressed[key]
    end
end

function love.keyreleased(key)
    love.keyboard.wasPressed = function(key) return false end
end

function love.run()
    love.keyboard.keysPressed = {}

    if love.load then love.load(arg) end

    -- Main loop
    while true do
        love.keyboard.keysPressed = {}
        if love.event then
            love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then
                    return
                elseif name == 'keypressed' then
                    love.keyboard.keysPressed[a] = true
                end
                love.handlers[name](a,b,c,d,e,f)
            end
        end

        if love.timer then
            love.timer.step()
            local dt = love.timer.getDelta()
            if love.update then love.update(dt) end
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.origin()
            love.graphics.clear(love.graphics.getBackgroundColor())
            if love.draw then love.draw() end
            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end
