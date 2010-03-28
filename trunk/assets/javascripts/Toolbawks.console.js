/*
# Copyright (c) 2007 Nathaniel Brown
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
*/

Toolbawks.console = {
  enabled : false,
  enabled_firefox : true,
  enabled_extjs : false,
  
  is_enabled : function() {
    if (!Toolbawks.console.enabled) {
      return false;
    } else {
      if (Toolbawks.console.enabled_extjs && typeof Ext != 'undefined' && console == Ext.debug){
        return true;
      } else if (typeof console == 'undefined' || (typeof Ext != 'undefined' && console == Ext.debug)) {
        return false;
      } else {
        return true;
      }
    }
  },
  
  log : function(message) {
    if (!Toolbawks.console.is_enabled()) {
      return true;
    }
    try {
      console.log(message)
    } catch(err) {};
  },

  info : function(message) {
    if (!Toolbawks.console.is_enabled()) {
      return true;
    }
    try {
      console.info(message)
    } catch(err) {};
  },
  
  dir : function(obj) {
    if (!Toolbawks.console.is_enabled()) {
      return true;
    }
    try {
      console.dir(obj)
    } catch(err) {};
  },
  
  warn : function(message) {
    if (!Toolbawks.console.is_enabled()) {
      return true;
    }
    try {
      console.warn(message)
    } catch(err) {};
  },
  
  error : function(message) {
    if (!Toolbawks.console.is_enabled()) {
      return true;
    }
    try {
      console.error(message)
    } catch(err) {};
  }
  
};

Toolbawks.dir = Toolbawks.console.dir;
Toolbawks.info = Toolbawks.console.info;
Toolbawks.log = Toolbawks.console.log;
Toolbawks.error = Toolbawks.console.error;
Toolbawks.warn = Toolbawks.console.warn;