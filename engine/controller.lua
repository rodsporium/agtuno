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

-- NEW HELPER FUNCTION: This is the core of the fix.
-- It checks if a point (mx, my) is inside a rotated rectangle (card).
function is_point_in_rotated_rect(mx, my, rect)
    -- 1. Find the center of the rectangle.
    local cx = rect.VT.x
    local cy = rect.VT.y

    -- 2. Translate the mouse point so the rectangle's center is the origin (0,0).
    local translated_mx = mx - cx
    local translated_my = my - cy

    -- 3. "Un-rotate" the translated mouse point by the rectangle's rotation angle.
    local sin_r = math.sin(-rect.VT.r)
    local cos_r = math.cos(-rect.VT.r)
    local rotated_mx = translated_mx * cos_r - translated_my * sin_r
    local rotated_my = translated_mx * sin_r + translated_my * cos_r

    -- 4. Now, check if this new "un-rotated" point is inside the rectangle's simple,
    -- non-rotated bounding box centered at (0,0).
    if math.abs(rotated_mx) < rect.VT.w / 2 and
       math.abs(rotated_my) < rect.VT.h / 2 then
        return true
    end

    return false
end

-- This function is called from main.lua whenever the mouse is pressed.
function Controller:mousepressed(x, y, button)
    -- Check if there's an object currently being hovered over.
    if self.hovering.target then
        -- If so, this is our new drag target!
        self.dragging.target = self.hovering.target

        -- Correctly calculate offset from the card's visual center, not its top-left.
        self.dragging.offset.x = self.cursor_position.x - self.dragging.target.VT.x
        self.dragging.offset.y = self.cursor_position.y - self.dragging.target.VT.y

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
        -- UPDATED: Pass both the area and the specific card being hovered over.
        self.dragging.target:stop_drag(self.hovering_area, self.hovering.target)
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

    -- Store the previous hover target before we find the new one.
    self.hovering.prev_target = self.hovering.target

    -- Figure out which objects the cursor is colliding with.
    self:get_cursor_collision()

    -- Based on the collision list, determine the single object being hovered.
    self:set_cursor_hover()

    -- If the hovered card has changed since the last frame...
    if self.hovering.target ~= self.hovering.prev_target then
        -- If we are dragging a card...
        if self.dragging.target then
            -- ...tell the NEW card underneath to pop up (drop_hover).
            if self.hovering.target then self.hovering.target:drop_hover() end
            -- ...tell the OLD card underneath to stop popping up.
            if self.hovering.prev_target then self.hovering.prev_target:stop_drop_hover() end
        -- Otherwise, if we are just moving the mouse normally...
        else
            -- ...do the normal hover effect.
            if self.hovering.target then self.hovering.target:hover() end
            if self.hovering.prev_target then self.hovering.prev_target:stop_hover() end
        end
    end
end

-- UPDATED: This function is now much smarter about finding the top-most card.
-- Checks which objects are under the cursor.
function Controller:get_cursor_collision()
    -- Reset the list for this frame.
    self.collision_list = {}

    -- 1. Create a temporary copy of the card list to sort.
    local sorted_cards = {}
    for _, card in ipairs(G.I.CARD) do
        table.insert(sorted_cards, card)
    end

    -- 2. Sort this temporary list using the EXACT same logic as draw_fightscene.
    table.sort(sorted_cards, function(a, b)
        if a.states.drag.is then return false end
        if b.states.drag.is then return true end
        if a.area and b.area then
            if a.area.T.y < b.area.T.y then return true end
            if a.area.T.y > b.area.T.y then return false end
            return a.hand_idx < b.hand_idx
        end
        return false
    end)
    
    -- Loop backwards (from top-most to bottom-most).
    for i = #sorted_cards, 1, -1 do
        local card = sorted_cards[i]
        if card ~= self.dragging.target and card.states.visible and card.states.collide.can then

            -- UPDATED: Use the new, smarter collision check.
            if is_point_in_rotated_rect(self.cursor_position.x, self.cursor_position.y, card) then
                table.insert(self.collision_list, card)
                break -- The first card we find is the correct one, so we stop looking.
            end
        end
    end

    -- UPDATED: This block now correctly finds the top-most CardArea.
    local areas = { G.top_row, G.middle_row, G.bottom_row }
    -- 1. Sort the areas by their Y position, from top of screen to bottom.
    table.sort(areas, function(a, b) return a.T.y < b.T.y end)

    -- 2. Loop backwards, checking the bottom-most (front-most) area first.
    for i = #areas, 1, -1 do
        local area = areas[i]
        -- Use the rotation-aware check, as CardAreas are also Moveables with a center origin.
        if area and is_point_in_rotated_rect(self.cursor_position.x, self.cursor_position.y, area) then
            table.insert(self.collision_list, area)
            break
        end
    end
end

-- Determines the single "top-most" object being hovered.
function Controller:set_cursor_hover()
    -- self.hovering.prev_target is now set in the main update loop.
    self.hovering.target = nil
    -- Reset the hovering area.
    self.hovering_area = nil

    -- This logic is now simpler because collision_list will only ever have 
    -- one card at most (the top one).
    for _, obj in ipairs(self.collision_list) do
        if obj:is(Card) then
            self.hovering.target = obj
        elseif obj:is(CardArea) then
            self.hovering_area = obj
        end
    end
end
