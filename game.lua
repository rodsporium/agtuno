-- game.lua
-- This is the main game logic controller.

function start_up()
    set_globals()
    init_item_prototypes()
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
        c_base = { name = 'Base', pos = {x = 0, y = 4} },
        j_joker = { name = 'Joker', pos = {x = 0, y = 0} }
    }

    G.deck = {}
    local suits = {'S', 'H', 'C', 'D'}
    local ranks = {'A', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K'}

    -- Loop through all suits and ranks to create a full 52-card deck.
    for i, suit in ipairs(suits) do
        for j, rank in ipairs(ranks) do
            local card_key = suit .. '_' .. rank
            -- Create each card stacked at the same initial position.
            local new_card = Card(50, 200, 71 * 1.5, 95 * 1.5, G.P_CARDS[card_key], G.P_CENTERS['c_base'])
            table.insert(G.deck, new_card)
        end
    end

    -- NEW: Schedule an animation to move all the cards.
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 2, -- Wait for 2 seconds
        func = function()
            print("Event triggered! Moving all cards.")
            -- Loop through the deck and move each card to a new fanned-out position.
            for i, card in ipairs(G.deck) do
                -- Instantly change the card's TARGET position.
                -- The Moveable:move() function will handle the smooth slide.
                card.T.x = 100 + (i * 15)
                card.T.y = 300
            end
            return true -- Return true to remove this event from the queue.
        end
    }))

end
