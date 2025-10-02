-- globals.lua
-- This file defines the global 'G' table which will hold all our game-wide data.

function set_globals()

    background = love.graphics.newImage('resources/textures/1x/battlefield.png')

    G = {}

    G.I = {
        NODE = {},
        SPRITE = {},
        CARD = {}
    }

    G.MOVEABLES = {}
    G.SETTINGS = {
        paused = false
    }
    G.TIMERS = {
        TOTAL = 0
    }

    G.E_MANAGER = EventManager()

    -- Create a simple white image on the fly to use as our card background atlas.
    local canvas = love.graphics.newCanvas(71, 95)
    love.graphics.setCanvas(canvas)
        love.graphics.clear(1, 1, 1, 1) -- White background
    love.graphics.setCanvas()

    -- Load your spritesheet image.
    G.ASSET_ATLAS = {
        cards = {
            image = love.graphics.newImage("resources/textures/1x/8BitDeck.png"),
            -- These are the pixel dimensions of a SINGLE card on your spritesheet.
            -- You may need to adjust these values to get a perfect cutout.
            px = 71, -- The width of one card sprite in pixels
            py = 95  -- The height of one card sprite in pixels
        },
        centers = {
            image = love.graphics.newImage("resources/textures/1x/Enhancers.png"),
            px = 71,
            py = 95
        },
        card_back = {
            image = love.graphics.newImage("resources/textures/1x/Enhancers.png"),
            image = canvas,
            px = 71, py = 95
        }
    }

end