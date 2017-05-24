--[[
 * @author Raymond Cheung [korekontakt](https://github.com/korekontakt/)
 * 
 * @copyright Copyright (c) 2017, Raymond Cheung.
--]]

-- [LuaUnit 3.2.1 Doc](http://luaunit.readthedocs.io/en/luaunit_v3_2_1/)

package.path = "/usr/share/lua/5.2/?.lua;" .. package.path

local luaunit = require("luaunit")
local YueObject = require("lib.YueObject")

TestYueObject = {}
  function TestYueObject:setUp()
    opt = {
      x = 0,
      y = 0,
    }
    instance = YueObject()
    instance:new(opt)
  end
  
  function TestYueObject:testNew()
    if (instance == nil) then
      instance = YueObject():new(opt)
    end
    luaunit.assertEquals(instance.x, 0)
    luaunit.assertEquals(instance.y, 0)
  end
  
  function TestYueObject:testClone()
    local pt = {
      x = 1,
      y = 2,
      z = 3,
    }
    local obj1 = YueObject():new(pt)
    local obj2 = obj1:clone()
    luaunit.assertEquals(obj2.x, 1)
    luaunit.assertEquals(obj2.y, 2)
    luaunit.assertEquals(obj2.z, 3)
    obj1.x = 4;
    luaunit.assertEquals(obj2.x, 1)
  end
  
  function TestYueObject:testExtend()
    local TestObjectExtendable = classic.class("TestObjectExtendable")
    local hi = "Hello World!"
    
    function TestObjectExtendable:hello()
      return hi
    end
    
    local TestExtendedObject, super = classic.class("TestExtendedObject", YueObject)
    function TestExtendedObject:new(opt)
      super._init(self, opt);
      self.isExtended = self:extend("TestObjectExtendable")
      return self
    end
    
    local obj = TestExtendedObject():new()
    luaunit.assertEquals(obj.isExtended, true)
    luaunit.assertIsFunction(obj.hello)
    luaunit.assertEquals(obj.hello(), hi)
  end
  
  function TestYueObject:testModifier()
    local TestSubclass, _ = classic.class("TestSubclass", YueObject)
    TestSubclass._modifier = {private = true}
    local hi = "Hello World!"
    
    function TestSubclass:hiPrivate()
      return hi
    end
    
    local TestAnother, super = classic.class("TestAnother", YueObject)
    function TestAnother:new(opt)
      super._init(self, opt);
      self.isExtended = self:extend("TestSubclass")
      return self
    end
    
    local obj = TestAnother():new()
    luaunit.assertEquals(obj.isExtended, false)
    luaunit.assertIsNil(obj.hiPrivate)
  end
  
  function TestYueObject:testGetter()
    luaunit.assertEquals(instance:getter("x"), 0)
    luaunit.assertEquals(instance:getter("y"), 0)
    luaunit.assertNil(instance:getter("z"))
  end
  
  function TestYueObject:testSetter()
    local obj = instance:clone()
    obj:setter("x", 3)
    obj:setter("y", 4)
    luaunit.assertEquals(obj:getter("x"), 3)
    luaunit.assertEquals(obj:getter("y"), 4)
    obj:setter("y", "five")
    luaunit.assertEquals(obj:getter("y"), 4)
    luaunit.assertNil(instance:getter("z"))
  end
  
  function TestYueObject:testTryCatch()
    local f_msg = "FAILED!"
    local f_code = 121
    local fErr = function()
      error(f_msg)
    end
    local err_msg = "Hello, Error!"
    local psts, perr = instance:trycatch(fErr, err_msg)
    luaunit.assertEquals(psts, false)
    luaunit.assertStrContains(perr, f_msg)
    psts, perr = instance:trycatch(function() error({code=f_code}) end, "Error Code")
    luaunit.assertEquals(perr.code, f_code)
  end
  
  function TestYueObject:testTest()
    local TestParent, _ = classic.class("TestParent", YueObject)
    local TestChild, _ = classic.class("TestChild", TestParent)
    local obj = TestChild():new();
    obj:test()
    luaunit.assertEquals(obj:getParentName(), "classic.class<TestParent>")
  end
-- end of table TestYueObject

os.exit(luaunit.LuaUnit.run())
