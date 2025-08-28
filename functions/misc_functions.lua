-- functions/misc_functions.lua
-- A collection of essential helper functions for our engine.

-- This is a placeholder for a function the full engine uses for drawing optimization.
-- Our simple test doesn't need it to do anything, but the function must exist
-- to prevent errors when sprite:draw() is called.
function add_to_drawhash(obj) end


-- This is a helper function that creates an 'ease' event.
-- It's a convenient shortcut to make the EventManager animate a value.
function ease_value(ref_table, ref_value, ease_to, ease_type, duration)
    -- This creates a new event and adds it to the manager's queue.
    -- The event will smoothly change 'ref_value' of 'ref_table' to 'ease_to'
    -- over 'duration' seconds.
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        ref_table = ref_table,
        ref_value = ref_value,
        ease_to = ease_to,
        ease = ease_type,
        delay = duration
    }))
end
