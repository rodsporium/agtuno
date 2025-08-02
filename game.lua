-- game.lua
-- This is the main game logic controller.

function start_up()
    set_globals()
end

function update(dt)
    movement(dt)
end

function draw()
    draw_circle()
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

function draw_circle()
    love.graphics.circle("fill",player.x,player.y,100)
end