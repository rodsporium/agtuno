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
    -- if love.keyboard.isDown("right") then
    --     player.x = player.x + 100 * dt
    -- end
    -- if love.keyboard.isDown("left") then
    --     player.x = player.x - 100 * dt
    -- end
    -- if love.keyboard.isDown("up") then
    --     player.y = player.y - 100 * dt
    -- end
    -- if love.keyboard.isDown("down") then
    --     player.y = player.y + 100 * dt
    -- end

    -- This is the core of the animation.
    -- We loop through every object in the G.MOVEABLES list and call its move() function.
    -- This is what makes the VT (Visible Transform) smoothly catch up to the T (Target Transform).
    for k, v in ipairs(G.MOVEABLES) do
        v:move(dt)
    end

    -- Countdown our simple timer.
    G.animation_timer = G.animation_timer - dt
    if G.animation_timer > 0 and G.animation_timer - dt <= 0 then
        -- When the timer hits zero, we instantly change the card's TARGET position.
        print("Timer finished! Moving card.")
        my_card.T.x = 500
        my_card.T.y = 500

        -- The Moveable:move() function will now automatically handle the smooth
        -- animation to this new target position over the next few frames.
    end

end

function draw_fightscene()
    love.graphics.draw(background, 0, 0)
    -- love.graphics.draw(player.spriteSheet,player.x,player.y,100)

    -- love.graphics.clear(0.1, 0.2, 0.1, 1) -- Dark green background

    -- Loop through all the sprites in our global list and draw them.
    for k, v in ipairs(G.I.SPRITE) do
        v:draw()
    end
end
