---@class Event
--- The task 
Event = Object:extend()

-- This is the CONSTRUCTOR for a single Event.
-- It runs when you create a new event, like: Event({ trigger = 'after', delay = 1.0 })
function Event:init(config)
    -- The 'trigger' determines WHEN the event should happen.
    -- We will focus on three main types: 'immediate', 'after', and 'ease'.
    self.trigger = config.trigger or 'immediate'

    -- The 'func' is the actual code that will run when the event is triggered.
    -- If no function is provided, it defaults to an empty one that does nothing.
    self.func = config.func or function() return true end

    -- The 'delay' is the time in seconds to wait before running the function.
    -- This is only used for the 'after' and 'ease' triggers.
    self.delay = config.delay or 0

    -- This variable tracks when the event was created to calculate delays.
    self.time = G.TIMERS.TOTAL

    -- If the trigger is 'ease', we need to set up the animation properties.
    if self.trigger == 'ease' then
        self.ease = {
            ref_table = config.ref_table,       -- The object to animate (e.g., my_card)
            ref_value = config.ref_value,       -- The property to change (e.g., 'T.x')
            start_val = config.ref_table[config.ref_value], -- The starting value
            end_val = config.ease_to,           -- The target value
            start_time = G.TIMERS.TOTAL,        -- When the animation starts
            end_time = G.TIMERS.TOTAL + self.delay, -- When the animation ends
        }
    end
end

---@class EventManager
--- The task manager
EventManager = Object:extend()

-- This is the CONSTRUCTOR for the EventManager.
function EventManager:init()
    -- The 'queue' is the list of all pending tasks (Event objects).
    -- In the full engine, there are multiple queues, but for our foundation, one is enough.
    self.queue = {}
end

-- This function adds a new task to the manager's list.
function EventManager:add_event(event)
    table.insert(self.queue, event)
end

-- This is the CORE of the EventManager. It is called every single frame from love.update.
function EventManager:update(dt)
    -- We loop through our queue of events backwards.
    -- (Looping backwards is safer when removing items from a list you are looping over).
    for i = #self.queue, 1, -1 do
        local event = self.queue[i]
        local should_remove = false

        -- Check the event's trigger type and handle it accordingly.
        if event.trigger == 'after' then
            -- If enough time has passed...
            if event.time + event.delay <= G.TIMERS.TOTAL then
                -- ...run the event's function.
                event.func()
                should_remove = true -- Mark this event for removal.
            end

        elseif event.trigger == 'ease' then
            -- If the animation is still in progress...
            if G.TIMERS.TOTAL < event.ease.end_time then
                -- Calculate how far along the animation is (from 0.0 to 1.0).
                local percent_done = (G.TIMERS.TOTAL - event.ease.start_time) / event.delay
                -- Update the object's property by interpolating between the start and end values.
                event.ease.ref_table[event.ease.ref_value] = event.ease.start_val + (event.ease.end_val - event.ease.start_val) * percent_done
            else
                -- If the animation is finished, snap the value to the final target
                -- to ensure it's perfectly accurate.
                event.ease.ref_table[event.ease.ref_value] = event.ease.end_val
                should_remove = true -- Mark this event for removal.
            end

        elseif event.trigger == 'immediate' then
            -- For 'immediate' events, just run the function right away.
            event.func()
            should_remove = true
        end

        -- If the event is marked for removal, remove it from the queue.
        if should_remove then
            table.remove(self.queue, i)
        end
    end
end
