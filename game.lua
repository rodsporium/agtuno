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

    -- Update the game's clock.
    G.TIMERS.TOTAL = G.TIMERS.TOTAL + dt

    -- Update the EventManager. This is the heartbeat of the animation system.
    G.E_MANAGER:update(dt)

    -- This is the core of the animation.
    -- We loop through every object in the G.MOVEABLES list and call its move() function.
    -- This is what makes the VT (Visible Transform) smoothly catch up to the T (Target Transform).
    for k, v in ipairs(G.MOVEABLES) do
        v:move(dt)
    end
 
end

function draw_fightscene()

    love.graphics.draw(background, 0, 0)

    -- Loop through all the sprites in our global list and draw them.
    for k, v in ipairs(G.I.SPRITE) do
        v:draw()
    end
    
end
