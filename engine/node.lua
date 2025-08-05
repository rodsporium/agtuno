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
    -- For now, the only one we care about is 'visible'.
    self.states = {
        visible = true,
        collide = {can = false, is = false},
        focus = {can = false, is = false},
        hover = {can = true, is = false},
        click = {can = true, is = false},
        drag = {can = true, is = false},
        release_on = {can = true, is = false}
    }

    -- Every Node can have children. This isn't essential right now,
    -- but it's a core feature of the engine.
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
