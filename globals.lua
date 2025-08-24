-- globals.lua
-- This file defines the global 'G' table which will hold all our game-wide data.

function set_globals()
    player = {}
    player.x = 200
    player.y = 200
    player.spriteSheet = love.graphics.newImage('resources/textures/1x/8bitdeck.png')

    background = love.graphics.newImage('resources/textures/1x/battlefield.png')

    -----------
    --- Tester
    -----------

    G = {}
    Card = Sprite:extend()
    G.I = {
        NODE = {},
        SPRITE = {}
    }

    G.MOVEABLES = {}
    G.SETTINGS = { paused = false }

    -- Load your spritesheet image.
    G.ASSET_ATLAS = {
        cards = {
            image = love.graphics.newImage("resources/textures/1x/8BitDeck.png"),
            -- These are the pixel dimensions of a SINGLE card on your spritesheet.
            -- You may need to adjust these values to get a perfect cutout.
            px = 71, -- The width of one card sprite in pixels
            py = 95  -- The height of one card sprite in pixels
        }
    }

    my_card = Card({
        -- T is the TARGET transform. We place it at x=50, y=200.
        T = { x = 50, y = 200, w = 71 , h = 95 }, -- Draw the card 50% bigger
        -- Tell the sprite to use our 'cards' atlas.
        atlas = G.ASSET_ATLAS.cards,
        -- Tell it WHICH sprite to cut out. {x=10, y=0} is the King of Hearts.
        sprite_pos = {x = 12, y = 0}
    })

    -- A simple timer to trigger the animation.
    G.animation_timer = 0.5

end