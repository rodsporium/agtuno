-- -- class.lua
-- -- A simple library for creating object-oriented classes in Lua.
-- -- This allows us to use the 'Object:extend()' pattern.

-- Object = {}

-- function Object:new(o)
--   o = o or {}
--   setmetatable(o, self)
--   self.__index = self
--   return o
-- end

-- function Object:extend(o)
--   o = o or {}
--   o.super = self
--   setmetatable(o, self)
--   self.__index = self
--   return o
-- end

-- -- A simple function to check the class of an object
-- function Object:is(T)
--     local mt = getmetatable(self)
--     while mt do
--         if mt == T then return true end
--         mt = mt.super
--     end
--     return false
-- end
