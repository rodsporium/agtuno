-- This is the "master blueprint" for every class in your engine.
-- It's an empty table that will hold the core functions for inheritance.
Object = {}

-- This is the most important line for inheritance in Lua.
-- '__index' is a special key. When you try to access something on an object
-- (like my_card:move()) and it doesn't exist on that specific object,
-- Lua will look inside the table pointed to by __index.
-- By setting it to itself, we make Object the ultimate fallback for all methods.
Object.__index = Object

-- This is the base "constructor" function for all objects.
-- Every class you create (Node, Moveable, etc.) will have its own 'init' function,
-- and they all eventually call this empty one at the top of the chain.
function Object:init()
end

-- This is the "factory" that creates new classes.
-- When you write "Node = Object:extend()", this function is what runs.
function Object:extend()
  local cls = {}
  for k, v in pairs(self) do
    if k:find("__") == 1 then
      cls[k] = v
    end
  end
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end

-- This is a utility function to check an object's "ancestry".
-- It answers the question: "Is this object a Card?" or "Is this object a Moveable?"
function Object:is(T)
  local mt = getmetatable(self)
  while mt do
    if mt == T then
      return true
    end
    mt = getmetatable(mt)
  end
  return false
end

-- This is another special Lua "metamethod" that makes creating objects clean.
-- It allows you to create a new object by calling the class name as if it were a function.
-- Example: my_card = Card(...)
function Object:__call(...)
  local obj = setmetatable({}, self)
  obj:init(...)
  return obj
end
