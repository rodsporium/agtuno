-- This class is the central hub for all player input.
---@class Controller
Controller = Object:extend()

function Controller:init()
    -- This table will hold the object currently under the mouse cursor.
    self.hovering = {target = nil, prev_target = nil}

    -- Stores the current x and y coordinates of the mouse.
    self.cursor_position = {x = 0, y = 0}

    -- A list of all objects the cursor is currently touching.
    self.collision_list = {}

    -- A table to manage the state of the object being dragged.
    self.dragging = {
        target = nil,       -- The object currently being dragged.
        offset = {x = 0, y = 0} -- The offset from the object's origin to the mouse click position.
    }

    -- Keep track of the area under the cursor.
    self.hovering_area = nil
end

-- This function is called from main.lua whenever the mouse is pressed.
function Controller:mousepressed(x, y, button)
    -- Check if there's an object currently being hovered over.
    if self.hovering.target then
        -- If so, this is our new drag target!
        self.dragging.target = self.hovering.target

        -- Calculate the offset. This makes the drag feel natural,
        -- as if you're picking up the card from the exact point you clicked.
        self.dragging.offset.x = self.cursor_position.x - self.dragging.target.T.x
        self.dragging.offset.y = self.cursor_position.y - self.dragging.target.T.y

        -- Pass the calculated offset to the card.
        -- Now the card knows exactly where it was grabbed.
        self.dragging.target:start_drag(self.dragging.offset)
    end
end

-- This function is called from main.lua whenever the mouse is released.
function Controller:mousereleased(x, y, button)
    -- If we were dragging an object...
    if self.dragging.target then
        -- When the drag stops, tell the card which area it was dropped on.
        self.dragging.target:stop_drag(self.hovering_area)
        -- Clear the drag target.
        self.dragging.target = nil
    end
end

-- This is the main update loop for the controller, called every frame.
function Controller:update(dt)
    -- Get the current mouse position from LÖVE.
    local mx, my = love.mouse.getPosition()

    -- Translate screen pixel coordinates to game world coordinates.
    -- This is the crucial fix. For now, we'll assume a simple 1:1 mapping,
    -- but this is where you would handle scaling if your window size changes.
    self.cursor_position.x = mx
    self.cursor_position.y = my

    -- If an object is being dragged, update its position.
    if self.dragging.target then
        -- Tell the dragged object where the mouse is.
        self.dragging.target:drag(self.cursor_position.x, self.cursor_position.y)
    end

    -- Figure out which objects the cursor is colliding with.
    self:get_cursor_collision()

    -- Based on the collision list, determine the single object being hovered.
    self:set_cursor_hover()

    -- Now, tell the objects whether they are being hovered or not.
    if self.hovering.target ~= self.hovering.prev_target then
        -- If we started hovering over a new object, tell it to react.
        if self.hovering.target then
            self.hovering.target:hover()
        end
        -- If we stopped hovering over the previous object, tell it to stop reacting.
        if self.hovering.prev_target then
            self.hovering.prev_target:stop_hover()
        end
    end
end

-- Checks which objects are under the cursor.
function Controller:get_cursor_collision()
    -- Reset the list for this frame.
    self.collision_list = {}

    -- To make dragging feel right, we check for hovers from top to bottom (last created to first)
    for i = #G.I.CARD, 1, -1 do
        local card = G.I.CARD[i]
        if card ~= self.dragging.target and card.states.visible and card.states.collide.can then
            if self.cursor_position.x > card.VT.x and
               self.cursor_position.x < card.VT.x + card.VT.w and
               self.cursor_position.y > card.VT.y and
               self.cursor_position.y < card.VT.y + card.VT.h then
                table.insert(self.collision_list, card)
            end
        end
    end

    -- Also check for collision with the card areas.
    local areas = { G.top_row, G.middle_row, G.bottom_row }
    for i, area in ipairs(areas) do
        if area and self.cursor_position.x > area.VT.x and
           self.cursor_position.x < area.VT.x + area.VT.w and
           self.cursor_position.y > area.VT.y and
           self.cursor_position.y < area.VT.y + area.VT.h then
            table.insert(self.collision_list, area)
        end
    end
end

-- Determines the single "top-most" object being hovered.
function Controller:set_cursor_hover()
    self.hovering.prev_target = self.hovering.target
    self.hovering.target = nil

    -- Reset the hovering area.
    self.hovering_area = nil

    if #self.collision_list > 0 then
        -- Find the first card in the list (the top-most one).
        for _, obj in ipairs(self.collision_list) do
            if obj:is(Card) then
                self.hovering.target = obj
                break
            end
        end
        -- Find the first area in the list.
        for _, obj in ipairs(self.collision_list) do
            if obj:is(CardArea) then
                self.hovering_area = obj
                break
            end
        end
    end
end
