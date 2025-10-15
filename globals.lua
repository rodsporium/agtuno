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

    -- Load your spritesheet image.
    G.ASSET_ATLAS = {
        cards = {
            image = love.graphics.newImage("resources/textures/1x/8BitDeck.png"),
            -- These are the pixel dimensions of a SINGLE card on your spritesheet.
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
            px = 71,
            py = 95
        }
    }

end