--[[
 * @author Raymond Cheung <korekontakt@gmail.com>
 * 
 * @copyright Copyright (c) 2017, Raymond Cheung.
--]]

-- http://luaunit.readthedocs.io/en/luaunit_v3_2_1/

package.path = "/usr/share/lua/5.2/?.lua;" .. package.path;

luaunit = require("luaunit");
YueObject = require("lib.YueObject");

TestYueObject = {}
  function TestYueObject:setUp()
    self.opt = {
      x = 0,
      y = 0,
    };
    instance = YueObject();
    instance:new(self.opt);
  end
  
  function TestYueObject:testNew()
    if (instance == nil) then
      instance = YueObject():new(self.opt);
    end
    luaunit.assertEquals(instance.x, 0);
    luaunit.assertEquals(instance.y, 0);
  end
  
  function TestYueObject:testClone()
    local pt = {
      x = 1,
      y = 2,
      z = 3,
    };
    local obj1 = YueObject():new(pt);
    local obj2 = obj1:clone();
    luaunit.assertEquals(obj2.x, 1);
    luaunit.assertEquals(obj2.y, 2);
    luaunit.assertEquals(obj2.z, 3);
  end
  
  function TestYueObject:testExtend()
    local TestObjectExtendable = classic.class("TestObjectExtendable");
    local hi = "Hello World!";
    
    function TestObjectExtendable:hello()
      return hi;
    end
    
    local obj = instance:clone();
    local isExtended = obj:extend(TestObjectExtendable);
    luaunit.assertEquals(isExtended, true);
    luaunit.assertIsFunction(obj.hello);
    luaunit.assertEquals(obj.hello(), hi);
  end
  
  function TestYueObject:testGetter()
    luaunit.assertEquals(instance:getter("x"), 0);
    luaunit.assertEquals(instance:getter("y"), 0);
    luaunit.assertNil(instance:getter("z"));
  end
  
  function TestYueObject:testSetter()
    local obj = instance:clone();
    obj:setter("x", 3);    
    obj:setter("y", 4);
    luaunit.assertEquals(obj:getter("x"), 3);
    luaunit.assertEquals(obj:getter("y"), 4);
    luaunit.assertNil(instance:getter("z"));
  end
  
  function TestYueObject:testTryCatch()
    local f_msg = "FAILED!";
    local f_code = 121;
    local fErr = function()
      error(f_msg);
    end
    local err_msg = "Hello, Error!";
    local psts, perr = instance:trycatch(fErr, err_msg);
    luaunit.assertEquals(psts, false);
    luaunit.assertStrContains(perr, f_msg);
    psts, perr = instance:trycatch(function() error({code=f_code}) end, "Error Code");
    luaunit.assertEquals(perr.code, f_code);
  end
  
  function TestYueObject:testTest()
    instance:test();
  end
-- end of table TestYueObject

os.exit(luaunit.LuaUnit.run());
