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

module ApplicationHelper
  def toolbawks_core_head(options = {})
    options[:base] = false if !options[:base]

    options[:scripaculous] = '1.7.1_beta3' if (options[:scripaculous] || options[:control_modal]) && options[:scripaculous] != false
    options[:prototype] = '1.5.1.1' if (options[:prototype] || options[:control_modal]) && options[:prototype] != false

    stylesheets = toolbawks_core_head_stylesheets(options)
    
    <<-EOL
    #{ stylesheets }
    #{ javascript_include_tag 'prototype-1_5_1_1.js', :plugin => 'toolbawks_core' if options[:prototype] && options[:prototype] == '1.5.1.1' }
    #{ javascript_include_tag 'scripaculous-1.7.1_beta3/builder.js', 'scripaculous-1.7.1_beta3/effects.js', 'scripaculous-1.7.1_beta3/dragdrop.js', 'scripaculous-1.7.1_beta3/controls.js', :plugin => 'toolbawks_core' if options[:scripaculous] && options[:scripaculous] == '1.7.1_beta3' }
    #{ javascript_include_tag 'Toolbawks.js', 'Toolbawks.console.js', 'Toolbawks.dialog.js', 'Toolbawks.global.js', 'Toolbawks.util.js', 'Toolbawks.util.QueryString.js', 'Toolbawks.transport.js', :plugin => 'toolbawks_core' }
    #{ javascript_include_tag 'Toolbawks.geo.js', 'Toolbawks.geo.Util.js', :plugin => 'toolbawks_core' if !options[:base] || options[:base] == false }
    #{ javascript_include_tag 'control.modal.2.2.3.js', :plugin => 'toolbawks_core' if options[:control_modal] }
EOL
  end
  
  def toolbawks_core_head_stylesheets(options = {})
    <<-EOL
    #{ stylesheet_link_tag 'Toolbawks.core.css', :plugin => 'toolbawks_core' }
EOL
  end
  
  def d(vars)
    begin
      if vars.class == Array
        debug = ''
      
        vars.each do |var|
          debug += _d(var)
        end
      
        debug
      elsif vars.class == String
        _d(vars)
      else 
        _d(vars.inspect)
      end
    rescue
      <<-EOL
<pre><span class="string">
There is an error debugging this type of variable class: #{vars.class}
</span>
</pre>
EOL
    end
  end
  
  def _d(var)
    # initial conversion of the var into ruby code
    var_to_convert = var.inspect.gsub('\"', '"')
    
    # add new lines after commas
    var_to_convert = var_to_convert.gsub(/((\"[^\"]*\"=>((\"[^\"]*\")|nil)(,\s|\})))/, "\\2\n").gsub(/(@[a-z]*=\{)([^\}])/, "\\1\n\\2").gsub(/[\n]?(,\s@[a-z_]*\=)/, "\n\\1")
    
    convertor = Syntax::Convertors::HTML.for_syntax "ruby"
    convertor.convert(var_to_convert)
  end
  
  def form_input(field_attributes, field_options = {})
    field_options[:prefix] ||= ''
    
    # Column
    field_attributes[:column] = form_input_column(field_attributes[:input]) if !field_attributes[:column]
    
    # Container
    field = <<-EOL
    <div class="field#{ form_field_error?(field_attributes) ? ' error' : '' }#{ form_checkbox?(field_options) ? ' field_checkbox' : '' }">
EOL

    if form_checkbox?(field_options)
      # Input
      field += field_attributes[:input]

      # Name
      if field_attributes[:name] && field_attributes[:name].length > 0
        field += <<-EOL
        <label for="#{ field_attributes[:input].match(/.*id=\"([^\"]*)\".*/)[1] }">#{ field_attributes[:name] }</label>
EOL
      end
    else
      # Name
      if field_attributes[:name] && field_attributes[:name].length > 0
        field += <<-EOL
        <label for="#{ field_attributes[:input].match(/.*id=\"([^\"]*)\".*/)[1] }">#{ field_attributes[:name] }</label>
EOL
      end
    
      # Input
      field += field_attributes[:input]
    end

    # Required
    if field_attributes[:required]
      field += <<-EOL
      <span class="required">*</span>
EOL
    end
    
    # Errors
    if field_attributes[:errors] && field_attributes[:errors].length > 0 || field_attributes[:object] && field_attributes[:object].errors.on(field_attributes[:column])
      object_errors = field_attributes[:errors] ? field_attributes[:errors] : field_attributes[:object].errors[field_attributes[:column]]
      field += <<-EOL
      <span class="error" id="#{ field_options[:prefix] + field_attributes[:column] + '_error' }">#{ (object_errors.class == Array ? object_errors.join(', ') : object_errors) }</span>
EOL
    elsif field_attributes[:description] && field_attributes[:description].length > 0
      field += <<-EOL
      <span class="description" id="#{ field_options[:prefix] + field_attributes[:column] + '_description' }">#{ field_attributes[:description] }</span>
EOL
    end


    # Example
    if field_attributes[:example]
      field += <<-EOL
      <span class="example" id="#{ field_options[:prefix] + field_attributes[:column] + '_example' }">#{ field_attributes[:example] }</span>
EOL
    end
    
    field += <<-EOL
    </div>
EOL
  end
  
  def form_checkbox?(field_options)
    field_options[:options] && field_options[:options][:checkbox] == true
  end
  
  def form_field_error?(field_attributes)
    field_attributes[:error] || field_attributes[:errors] && field_attributes[:errors].length > 0 || (field_attributes[:object] && field_attributes[:object].errors.on(field_attributes[:column]))
  end
  
#  def errors
#  end

  def form_input_column(input_html)
    input_html.match(/.*name=\"([^\"]*)\"/)[1].gsub(/.*\[([^\]]*)\]/, '\\1')
  end
end