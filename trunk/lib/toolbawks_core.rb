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

module Toolbawks
  mattr_accessor :default_host
  self.default_host = nil

  mattr_accessor :default_port
  self.default_port = nil

  mattr_accessor :default_protocol
  self.default_protocol = nil
  
  mattr_accessor :root_domain
  self.root_domain = ''

  mattr_accessor :REGEX_URL
  self.REGEX_URL = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
  
  mattr_accessor :REGEX_EMAIL
  self.REGEX_EMAIL = /^\S+\@(\[?)[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,4}|[0-9]{1,4})(\]?)$/ix
  
  def self.url
    "#{default_protocol}://#{default_host}#{default_port != false ? ':' + default_port : ''}"
  end
end

module ToolbawksCore
  mattr_accessor :enabled
  self.enabled = true
end

def logger
  RAILS_DEFAULT_LOGGER
end

require 'commands/rake'

# Include all our core rails extensions
require 'toolbawks_core/rails_extensions'

# Upgraded Pluralizer
require 'toolbawks_core/pluralize'

require 'retardase_inhibitor/init.rb'