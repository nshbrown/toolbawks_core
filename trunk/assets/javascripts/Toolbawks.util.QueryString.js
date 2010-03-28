/*
# Copyright (c) 2005 Adam Vandenberg
# Client-side access to querystring name=value pairs
#	Version 1.2.3
#	22 Jun 2005
#
# Enhanced by Nathaniel Brown
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

// More details here...
// http://www.dynamicdrive.com/forums/archive/index.php/t-11883.html

Toolbawks.enableQueryString = true;

Toolbawks.util.QueryString = {
  params : [],
  raw_params : false,
  
  init : function() {
		Toolbawks.util.QueryString.raw_params = location.search.substring(1, location.search.length);

  	if (Toolbawks.util.QueryString.raw_params.length == 0) {
  	  return;
  	}

    // Turn <plus> back to <space>
    // See: http://www.w3.org/TR/REC-html40/interact/forms.html#h-17.13.4.1
    Toolbawks.util.QueryString.raw_params = Toolbawks.util.QueryString.raw_params.replace(/\+/g, ' ')
    var args = Toolbawks.util.QueryString.raw_params.split('&') // parse out name/value pairs separated via &
    
    // split out each name=value pair
  	for (var i = 0, len = args.length; i < len; i++) {
  		var value;
  		var pair = args[i].split('=');
  		var name = unescape(pair[0]);

  		if (pair.length == 2) {
  			value = unescape(pair[1]);
  		} else {
  			value = name;
  		}

  		Toolbawks.util.QueryString.params[name] = value;
  	}
  },
  
  get_param : function(key, param_default) {
    // check if we have already parsed the query string yet
    if (!Toolbawks.util.QueryString.raw_params) {
      // run the parser
      Toolbawks.util.QueryString.init();
    }
    
    // if no key is passed, return all params
    if (!key) {
      return Toolbawks.util.QueryString.params;
    }
    
  	var value = Toolbawks.util.QueryString.params[key];
  	
  	// change UNDEFINED to NULL
  	if (param_default == null) {
  	  param_default = null;
  	}
    
    // use the default if there is no value
  	if (value == null) {
  	  value = param_default;
	  }

  	return value;
  },
  
  get_location : function(with_params, with_domain, with_hash, location) {
    Toolbawks.info('Toolbawks.util.QueryString.get_location');
    
    if (with_domain == undefined) {
      with_domain = false;
    }
    
    if (with_hash == undefined) {
      with_hash = false;
    }

    if (with_params == undefined) {
      with_params = true;
    }
    
    location = Toolbawks.util.QueryString.get_location(location)
    
    if (!location) {
      Toolbawks.log('Toolbawks.util.QueryString.get_location -> no location returned from Toolbawks.util.QueryString.get_location');
      return false;
    }
    
    location = location.match(/((http[s]?:\/\/(([^\/]+)[\/]?([^\?]*)?))[\?]?([^#]*)?)[#]?(.*)/im);
    var url = '';
    
    if (with_domain) {
      Toolbawks.log('Toolbawks.util.QueryString.get_location -> with_domain');

      if (with_hash) {
        Toolbawks.log('Toolbawks.util.QueryString.get_location -> with_hash');
        return location[0];
      } else if (with_params) {
        Toolbawks.log('Toolbawks.util.QueryString.get_location -> with_params');
        return location[1];
      } else {
        Toolbawks.log('Toolbawks.util.QueryString.get_location -> else (no hash, no params)');
        return location[3];
      }
    } else {
      Toolbawks.log('Toolbawks.util.QueryString.get_location -> else... no domain');
      var path = location[5];
      var params = location[6];
      var hash = location[7];
      
      if (with_hash) {
        Toolbawks.log('Toolbawks.util.QueryString.get_location -> with_hash');

        if (path == undefined) { 
          Toolbawks.error('Toolbawks.util.QueryString.get_location -> path is undefined');
          Toolbawks.dir(location);
          return false;
        }
        if (params == undefined) { 
          Toolbawks.info('Toolbawks.util.QueryString.get_location -> params is undefined');
        }
        if (hash == undefined) { 
          Toolbawks.info('Toolbawks.util.QueryString.get_location -> hash is undefined');
        }
        
        return '/' + path + (params != undefined ? '?' + params : '') + (hash != undefined ? '#' + hash : '');
      } else if (with_params) {
        Toolbawks.log('Toolbawks.util.QueryString.get_location -> with_params');

        if (path == undefined) { 
          Toolbawks.error('Toolbawks.util.QueryString.get_location -> path is undefined');
          Toolbawks.dir(location);
          return false;
        }
        if (params == undefined) { 
          Toolbawks.info('Toolbawks.util.QueryString.get_location -> params is undefined');
        }

        return '/' + path + (params != undefined ? '?' + params : '');
      } else {
        Toolbawks.log('Toolbawks.util.QueryString.get_location -> else (no hash, no params)');

        if (path == undefined) { 
          Toolbawks.error('Toolbawks.util.QueryString.get_location -> path is undefined');
          Toolbawks.dir(location);
          return false;
        }

        return '/' + path;
      }
    }
  },

  location : function(location) {
  
    if (location && location != undefined && location != false && location != "") {
      // use the location passed through
      location = new String(location);
    } else if (window.location) {
      location = new String(window.location);
    } else {
      Toolbawks.error('Toolbawks.util.QueryString.location -> unable to determine window.location');
      return false;
    }

    Toolbawks.info('Toolbawks.util.QueryString.location -> location: ' + location);
  
    return location;
  },

  domain : function(location) {
    Toolbawks.log('[tbx] Toolbawks.util.QueryString.domain(location => "' + location + '")');
    
    location = Toolbawks.util.QueryString.location(location);

    Toolbawks.log('[tbx] Toolbawks.util.QueryString.domain -> location : ' + location);

    var uri = location.match(/((http[s]?:\/\/(([^\/]+)[\/]?([^\?]*)?))[\?]?([^#]*)?)[#]?(.*)/im);

    if (!uri) {
      return false;
    }
    
    var domain = uri[4];
    
    if (domain && domain != '') {
      return domain;
    } else {
      return false;
    }
  },
  
  local : function(remote_uri) {
    var local_domain = Toolbawks.util.QueryString.domain();
    var remote_domain = Toolbawks.util.QueryString.domain(remote_uri);
    
    if (!remote_domain) {
      return true;
    } else if (local_domain == remote_domain) {
      return true;
    } else {
      return false;
    }
  }
};