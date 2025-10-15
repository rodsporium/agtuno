---@class Node
Node = Object:extend()

-- This is the CONSTRUCTOR. It runs every time you create a new Node.
-- Example: my_object = Node({ T = {x=10, y=10, w=2, h=3} })
function Node:init(args)
    -- Make sure 'args' is a table so we don't get errors.
    args = args or {}
    args.T = args.T or {}

    -- This is the MOST IMPORTANT part of a Node.
    -- The 'T' table holds the object's Transform: its position, size, and rotation.
    self.T = {
        x = args.T.x or 0, -- The x-position in game units
        y = args.T.y or 0, -- The y-position in game units
        w = args.T.w or 1, -- The width in game units
        h = args.T.h or 1, -- The height in game units
        r = args.T.r or 0, -- The rotation in radians
        scale = args.T.scale or 1,
    }

    -- This table holds the object's current states.
    self.states = {
        visible = true,
        collide = {can = false, is = false},
        focus = {can = false, is = false},
        hover = {can = true, is = false},
        click = {can = true, is = false},
        drag = {can = true, is = false},
        release_on = {can = true, is = false}
    }

    -- Every Node can have children.
    if not self.children then
        self.children = {}
    end
end

-- This is the DRAWER. It's called every frame for every object.
function Node:draw()
    -- This is a simple check: if the object is not visible, do nothing.
    if self.states.visible then
        -- A base Node doesn't draw a picture itself.
        -- Its only job is to tell all of its children to draw themselves.
        for _, v in pairs(self.children) do
            v:draw()
        end
    end
end

-- UPDATED: This is the corrected troubleshooter function.
function Node:draw_boundingrect()
    if self.VT then
        love.graphics.push()
            -- Remember the current color before we change it.
            local r, g, b, a = love.graphics.getColor()

            -- Set the color to red for the debug box.
            love.graphics.setColor(1, 0, 0, 0.5)

            -- 1. Move the coordinate system's origin to the center of our object.
            love.graphics.translate(self.VT.x, self.VT.y)
            -- 2. Rotate the entire coordinate system.
            love.graphics.rotate(self.VT.r)
            -- 3. Draw a simple, non-rotated rectangle centered at the new (0,0) origin.
            love.graphics.rectangle(
                "line",
                -self.VT.w / 2,
                -self.VT.h / 2,
                self.VT.w,
                self.VT.h
            )
        love.graphics.pop()

        -- After drawing, set the color back to what it was before.
        love.graphics.setColor(r, g, b, a)
    end
end
