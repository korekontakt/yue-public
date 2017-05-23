--[[
 * @author Raymond Cheung [korekontakt](https://github.com/korekontakt/)
 * 
 * @copyright Copyright (c) 2016, Raymond Cheung.
--]]

-- Base object model, see [classic github repo](https://github.com/DeepMind/classic) for usage information
-- [DeepMind/classic/Class.lua](https://github.com/DeepMind/classic/blob/master/classic/Class.lua)
-- [Programming in Lua - Classes](https://www.lua.org/pil/16.1.html)
-- [Microsoft - .NET Core - System.Object.cs](https://github.com/dotnet/coreclr/blob/master/src/mscorlib/src/System/Object.cs)
-- [Oracle - The Java Tutorials - Declaring Member Variables](https://docs.oracle.com/javase/tutorial/java/javaOO/variables.html)

local classic = require("classic")
local YueObject = classic.class("YueObject")

--[[
  Access Modifiers
    private = true: Methods are not extendable.
    private = false: Methods are extendable.
--]]
YueObject._modifier = {private = true}

function YueObject:_init(opt)
  self:_assign(opt) -- create object if user does not provide one
end

-- Assign a table option as class attributes
function YueObject:_assign(opt)
  if (type(opt) == "table") then
    for k, v in pairs(opt) do
      self[k] = v
    end
  end
end

function YueObject:new(opt)
  self:_assign(opt)
  return self
end

function YueObject:clone()
  local new_obj = {}
  if (type(self) ~= "table") then
    new_obj = self
    return new_obj
  end
  for k, v in pairs(self) do
    new_obj[k] = v
  end
  local self_meta = getmetatable(self)
  setmetatable(new_obj, self_meta)
  return new_obj
end

-- Extend another class methods
function YueObject:extend(klass)
  if (type(klass) == "string") then
    klass = classic.getClass(klass)
  end
  assert(klass ~= nil, "invalid class include")
  local klassAttributes = rawget(klass, "_classAttributes") or {}
  local klassModifiers = klassAttributes._modifier or {}
  if (type(klassModifiers) == "table" and klassModifiers.private) then
    return false
  end

  -- Methods provided by the mixin are copied to the including class.
  local methods = rawget(self:class(), "_methods")
  local otherMethods = rawget(klass, "_methods")
  for name, func in pairs(otherMethods) do
    if (methods[name] == nil) then
      methods[name] = func
    end
  end
  
  return true
end

-- Get a class Attribute
function YueObject:getter(attr)
  if (type(attr) == "string") then    
    return self[attr]
  else
    return nil
  end
end

-- Set a class Attribute
function YueObject:setter(attr, value)
  if (type(attr) == "string" and type(self[attr]) == type(value)) then    
    self[attr] = value
  end
end

function YueObject:trycatch(funcLambda, err_msg)
  local psts, perr
  if (type(err_msg) ~= "string") then
    err_msg = ""
  end
  if (type(funcLambda) == "function") then
    psts, perr = pcall(funcLambda)
    if (not psts) then
      print("*****")
      print("ERROR: " .. err_msg, perr)
      print("*****")
    end
  end
  return psts, perr
end

function YueObject:getParent()
  if (self._parent ~= nil) then
    return self._parent
  else
    local p = self:class():name()
    if (p == "YueObject") then
      return "classic"
    end
    local fParent = function()
      p = self:class():parent()
    end
    psts = self:trycatch(fParent)
    return p
  end
end

function YueObject:test()
  print("Loading " .. self:class():name() .. ":test()...")
  print("Methods:", self:class():methods())
  print("Parent:", self:getParent())
end

return YueObject