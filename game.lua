-- This is the main game logic controller.

function start_up()
    -- Defines global variables and loads assets.
    set_globals()

    -- Initialize the item prototypes and create initial game objects.
    init_item_prototypes()

    -- Create the global controller instance. This will manage all player input.
    G.CONTROLLER = Controller()
end

function update(dt)
    -- Update the game clock.
    G.TIMERS.TOTAL = G.TIMERS.TOTAL + dt

    -- Run the movement logic for ALL objects.
    -- This ensures every card's Visible Transform (VT) is updated to its
    -- correct on-screen position for the current frame.
    movement(dt)

    -- Update the card areas. This sets the TARGET transform (T) for the next frame.
    if G.top_row then
        G.top_row:update(dt)
    end
    if G.middle_row then
        G.middle_row:update(dt)
    end
    if G.bottom_row then
        G.bottom_row:update(dt)
    end

    -- Update the controller.
    G.CONTROLLER:update(dt)
end

function draw()
    draw_fightscene()
end

function movement(dt)
    -- Update the EventManager.
    G.E_MANAGER:update(dt)

    -- This is the core of the animation.
    -- We loop through every object in the G.MOVEABLES list and call its move() function.
    -- This is what makes the VT (Visible Transform) smoothly catch up to the T (Target Transform).
    for k, v in ipairs(G.MOVEABLES) do
        v:move(dt)
    end
end

function draw_fightscene()
    -- This block fixes the "zoomed-in" background.
    -- Step 1: Get the current width and height of the window.
    local winW, winH = love.graphics.getDimensions()
    -- Step 2: Get the width and height of the background image.
    local bgW, bgH = background:getDimensions()
    -- Step 3: Calculate the scaling factor needed to fill the screen.
    local scaleX = winW / bgW
    local scaleY = winH / bgH
    -- Step 4: Draw the background with the calculated scaling.
    love.graphics.draw(background, 0, 0, 0, scaleX, scaleY)

    -- This function is a "comparator".
    -- Its job is to look at card 'a' and card 'b' and decide which one should come first in the sorted list.
    table.sort(G.I.CARD, function(a, b)
        -- Rule 1: The card being dragged is always on top (drawn last).
        if a.states.drag.is then return false end
        if b.states.drag.is then return true end

        -- Rule 2: We only proceed if both cards are actually in a valid row (`card.area`).
        if a.area and b.area then
            if a.area.T.y < b.area.T.y then return true end
            if a.area.T.y > b.area.T.y then return false end
            -- Rule 3: If cards are in the same row, sort by their position in that row.
            return a.hand_idx < b.hand_idx
        end
        -- Rule 4: If one or both cards aren't in an area, don't change their order.
        return false
    end)

    -- Loop through all the sprites in our global list and draw them.
    for k, v in ipairs(G.I.CARD) do
        v:draw()
    end
    
end

function init_item_prototypes()

    -- This table holds the prototype data for all card "fronts" (the rank and suit).
    -- The key is a string like 'S_A' for Ace of Spades.
    -- The 'pos' key corresponds to the {x, y} coordinate on the 'cards' atlas.
    G.P_CARDS = {
        ['S_A'] = { pos = {x=12, y=3} }, -- Ace of Spades
        ['S_2'] = { pos = {x=0, y=3} }, -- 2 of Spades
        ['S_3'] = { pos = {x=1, y=3} }, -- 3 of Spades
        ['S_4'] = { pos = {x=2, y=3} }, -- 4 of Spades
        ['S_5'] = { pos = {x=3, y=3} }, -- 5 of Spades
        ['S_6'] = { pos = {x=4, y=3} }, -- 6 of Spades
        ['S_7'] = { pos = {x=5, y=3} }, -- 7 of Spades
        ['S_8'] = { pos = {x=6, y=3} }, -- 8 of Spades
        ['S_9'] = { pos = {x=7, y=3} }, -- 9 of Spades
        ['S_T'] = { pos = {x=8, y=3} }, -- 10 of Spades
        ['S_J'] = { pos = {x=9, y=3} }, -- Jack of Spades
        ['S_Q'] = { pos = {x=10, y=3} }, -- Queen of Spades
        ['S_K'] = { pos = {x=11, y=3} }, -- King of Spades

        ['H_A'] = { pos = {x=12, y=0} }, -- Ace of Hearts
        ['H_2'] = { pos = {x=0, y=0} }, -- 2 of Hearts
        ['H_3'] = { pos = {x=1, y=0} }, -- 3 of Hearts
        ['H_4'] = { pos = {x=2, y=0} }, -- 4 of Hearts
        ['H_5'] = { pos = {x=3, y=0} }, -- 5 of Hearts
        ['H_6'] = { pos = {x=4, y=0} }, -- 6 of Hearts
        ['H_7'] = { pos = {x=5, y=0} }, -- 7 of Hearts
        ['H_8'] = { pos = {x=6, y=0} }, -- 8 of Hearts
        ['H_9'] = { pos = {x=7, y=0} }, -- 9 of Hearts
        ['H_T'] = { pos = {x=8, y=0} }, -- 10 of Hearts
        ['H_J'] = { pos = {x=9, y=0} }, -- Jack of Hearts
        ['H_Q'] = { pos = {x=10, y=0} }, -- Queen of Hearts
        ['H_K'] = { pos = {x=11, y=0} }, -- King of Hearts

        ['C_A'] = { pos = {x=12, y=1} }, -- Ace of Clubs
        ['C_2'] = { pos = {x=0, y=1} }, -- 2 of Clubs
        ['C_3'] = { pos = {x=1, y=1} }, -- 3 of Clubs
        ['C_4'] = { pos = {x=2, y=1} }, -- 4 of Clubs
        ['C_5'] = { pos = {x=3, y=1} }, -- 5 of Clubs
        ['C_6'] = { pos = {x=4, y=1} }, -- 6 of Clubs
        ['C_7'] = { pos = {x=5, y=1} }, -- 7 of Clubs
        ['C_8'] = { pos = {x=6, y=1} }, -- 8 of Clubs
        ['C_9'] = { pos = {x=7, y=1} }, -- 9 of Clubs
        ['C_T'] = { pos = {x=8, y=1} }, -- 10 of Clubs
        ['C_J'] = { pos = {x=9, y=1} }, -- Jack of Clubs
        ['C_Q'] = { pos = {x=10, y=1} }, -- Queen of Clubs
        ['C_K'] = { pos = {x=11, y=1} }, -- King of Clubs

        ['D_A'] = { pos = {x=12, y=2} }, -- Ace of Diamonds
        ['D_2'] = { pos = {x=0, y=2} }, -- 2 of Diamonds
        ['D_3'] = { pos = {x=1, y=2} }, -- 3 of Diamonds
        ['D_4'] = { pos = {x=2, y=2} }, -- 4 of Diamonds
        ['D_5'] = { pos = {x=3, y=2} }, -- 5 of Diamonds
        ['D_6'] = { pos = {x=4, y=2} }, -- 6 of Diamonds
        ['D_7'] = { pos = {x=5, y=2} }, -- 7 of Diamonds
        ['D_8'] = { pos = {x=6, y=2} }, -- 8 of Diamonds
        ['D_9'] = { pos = {x=7, y=2} }, -- 9 of Diamonds
        ['D_T'] = { pos = {x=8, y=2} }, -- 10 of Diamonds
        ['D_J'] = { pos = {x=9, y=2} }, -- Jack of Diamonds
        ['D_Q'] = { pos = {x=10, y=2} }, -- Queen of Diamonds
        ['D_K'] = { pos = {x=11, y=2} }, -- King of Diamonds
    }

    -- This table holds the prototype data for all card "centers".
    G.P_CENTERS = {
        c_base = { name = 'Base', pos = {x = 1, y = 0} }
    }

    -- This table holds the prototype data for all card "backs".
    G.P_BACKS = {
        c_back = { name = 'Back1', pos = {x = 0, y = 0} }
    }

    -- Create CardAreas for our hand
    G.top_row    = CardArea(440, 300, 420, 180, {card_limit = 3})
    G.middle_row = CardArea(320, 360, 660, 180, {card_limit = 5})
    G.bottom_row = CardArea(320, 420, 660, 180, {card_limit = 5})

    -- Create a full hand of 13 cards.
    local cards = {
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['S_A'], G.P_CENTERS['c_base']),
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['H_A'], G.P_CENTERS['c_base']),
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['C_A'], G.P_CENTERS['c_base']),
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['D_A'], G.P_CENTERS['c_base']),
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['S_K'], G.P_CENTERS['c_base']),
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['H_K'], G.P_CENTERS['c_base']),
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['C_K'], G.P_CENTERS['c_base']),
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['D_K'], G.P_CENTERS['c_base']),
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['S_Q'], G.P_CENTERS['c_base']),
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['H_Q'], G.P_CENTERS['c_base']),
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['C_Q'], G.P_CENTERS['c_base']),
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['D_Q'], G.P_CENTERS['c_base']),
        Card(0,0, 71*1.5, 95*1.5, G.P_CARDS['S_J'], G.P_CENTERS['c_base']),
    }

    -- Distribute the 13 cards into the three rows.
    for i, card in ipairs(cards) do
        if i <= 3 then
            G.top_row:emplace(card)
        elseif i <= 8 then
            G.middle_row:emplace(card)
        else
            G.bottom_row:emplace(card)
        end
    end

    -- After all cards have been created and placed in their areas,
    -- loop through them and snap their visible positions to their final target positions.
    for k, v in ipairs(G.I.CARD) do
        v:hard_set_VT()
    end

end
