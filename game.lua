-- game.lua
-- This is the main game logic controller.

function start_up()
    set_globals()
end

function update(dt)
    movement(dt)
end

function draw()
    draw_fightscene()
end

function movement(dt)
    if love.keyboard.isDown("right") then
        player.x = player.x + 100 * dt
    end
    if love.keyboard.isDown("left") then
        player.x = player.x - 100 * dt
    end
    if love.keyboard.isDown("up") then
        player.y = player.y - 100 * dt
    end
    if love.keyboard.isDown("down") then
        player.y = player.y + 100 * dt
    end
end

function draw_fightscene()
    love.graphics.draw(background, 0, 0)
    -- love.graphics.draw(player.spriteSheet,player.x,player.y,100)
end


-------------------------------------------------
-- CODE TESTER FOR node.lua, moveable.lua, and sprite.lua
-------------------------------------------------

-- Create a Card class that is a type of Sprite
Card = Sprite:extend()

-- A global table to hold our game state
G = {}

function love.load()
    -- Create a dummy image for our card atlas.
    -- In your game, you would load this from your spritesheet file.
    local canvas = love.graphics.newCanvas(71, 95)
    love.graphics.setCanvas(canvas)
        love.graphics.clear(0.2, 0.2, 0.2, 1)
        love.graphics.setColor(1,0,0,1)
        love.graphics.rectangle('fill', 5, 5, 61, 85)
    love.graphics.setCanvas()
    
    G.ASSET_ATLAS = {
        cards = {
            image = canvas,
            px = 71, -- pixel width of one sprite
            py = 95  -- pixel height of one sprite
        }
    }

    -- Create an instance of our Card.
    my_card = Card({
        T = { x = 50, y = 200, w = 71, h = 95 },
        atlas = G.ASSET_ATLAS.cards,
        sprite_pos = {x=0, y=0}
    })

    -- A simple timer to trigger the animation
    G.animation_timer = 2
end

function love.update(dt)
    -- Update all moveable objects. This calls the Moveable:move() function.
    for k, v in ipairs(G.MOVEABLES) do
        v:move(dt)
    end

    -- Countdown the timer
    G.animation_timer = G.animation_timer - dt
    if G.animation_timer <= 0 then
        -- When the timer hits zero, instantly change the card's TARGET position.
        -- The Moveable:move() function will handle the smooth animation to this new target.
        my_card.T.x = 400
        G.animation_timer = 1000 -- Set a high value so it only runs once
    end
end

function love.draw()
    love.graphics.clear(0.1, 0.2, 0.1, 1) -- Dark green background

    -- Draw all the sprites.
    for k, v in ipairs(G.I.SPRITE) do
        v:draw()
    end
end
