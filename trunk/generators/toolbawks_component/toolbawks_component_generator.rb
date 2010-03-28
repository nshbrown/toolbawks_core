# Copyright (c) 2007 Nathaniel Brown

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
class ToolbawksComponentGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false, :skip_fixture => false
  
  def initialize(runtime_args, runtime_options = {})
    super

    component_name = runtime_args.shift
    component_name = Pluralize.underscore((component_name.match(/toolbawks/i) ? component_name : 'Toolbawks' + Pluralize.classify(component_name)))
    component_root = File.join('.', 'vendor', 'plugins', component_name)
    component_name_simple = Pluralize.underscore(component_name.gsub(/toolbawks/, ''))
    
    @component = {
      :name => component_name,
      :name_simple => component_name_simple,
      :path => {
        :controllers => File.join(component_root, 'app/controllers', component_name_simple),
        :views => File.join(component_root, 'app/views/toolbawks', component_name_simple),
        :helpers => File.join(component_root, 'app/helpers/toolbawks', component_name_simple),
        :lib => File.join(component_root, 'lib', component_name)
      },
      :root => component_root
    }

  end

  def manifest
    
    record do |m|
      puts "[tbx] @component #{ @component.inspect }"
      
      # Root directory and all subdirectories.
      puts "[tbx] creating @component[:root] dir: #{ @component[:root] }"
      m.directory @component[:root]

      # Generic controller, helper, views, and test directories.
      
      BASEDIRS.each do |path| 
        dir = File.join(@component[:root], path)
        puts "[tbx] creating dir: #{ dir }"
        m.directory dir
      end

      # Component specific controller, helper, and view directories.
      @component[:path].each_pair do |type, d|
        puts "[tbx] creating dir: #{ d }"
        m.directory d
      end

      # Root Files
      ["UPGRADE", "LICENSE"].each do |f|
        template = File.join(@component[:root], f)
        puts "[tbx] creating file: #{ f } with template : #{ template }"
        m.file f, template
      end
      
      # Root Templates
      ["about.yml", "CHANGELOG", "INSTALL", "README", "init.rb", "install.rb"].each do |f|
        template = File.join(@component[:root], f)
        puts "[tbx] creating file: #{ f } with template : #{ template }"
        m.template f, template, :assigns => { :component => @component }
     end

      # Check for class naming collisions.
      m.class_collisions "Toolbawks::#{ @component[:name_simple] }Controller", "Toolbawks::#{ @component[:name_simple] }Helper"

      # Application
      [
        ["app/controllers/toolbawks/component_controller.rb", File.join(@component[:path][:controllers], @component[:name_simple] + "_controller.rb")],
        ["app/helpers/application_helper.rb", File.join(@component[:root], "app/helpers/application_helper.rb")],
        ["app/helpers/toolbawks/component_helper.rb", File.join(@component[:path][:helpers], @component[:name_simple] + "_helper.rb")],
        ["app/views/toolbawks/component/index.rhtml", File.join(@component[:path][:views], "index.rhtml")],

        # Lib
        ["lib/toolbawks_component.rb", File.join(@component[:root], 'lib/' + Pluralize.underscore(@component[:name]) + '.rb')]
      ].each do |template|
        puts "[tbx] creating template : #{ template[0] } destination : #{ template[1] }"

        m.template template[0], template[1], :assigns => { :component => @component }
      end

=begin
      # Depend on model generator but skip if the model exists.
      m.dependency 'tool', [singular_name], :collision => :skip

      # Toolbawks forms.
      m.complex_template "form.rhtml",
        File.join('app/views',
                  controller_class_path,
                  controller_file_name,
                  "_form.rhtml"),
        :insert => 'form_toolbawks.rhtml',
        :sandbox => lambda { create_sandbox },
        :begin_mark => 'form',
        :end_mark => 'eoform',
        :mark_id => singular_name

      # Untoolbawks views.
      untoolbawks_actions.each do |action|
        path = File.join('app/views',
                          controller_class_path,
                          controller_file_name,
                          "#{action}.rhtml")
        m.template "controller:view.rhtml", path,
                   :assigns => { :action => action, :path => path}
      end
=end
    end
  end

  # Installation skeleton.  Intermediate directories are automatically
  # created so don't sweat their absence here.
  BASEDIRS = %w(
    app/controllers
    app/controllers/toolbawks
    app/helpers
    app/helpers/toolbawks
    app/models
    app/views/layouts
    app/views/toolbawks
    db
    db/migrate
    doc
    lib
    lib/tasks
    public/images
    public/javascripts
    public/stylesheets
    test/fixtures
    test/functional
    test/integration
    test/mocks/development
    test/mocks/test
    test/unit
  )
  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} toolbawks_component [component_name]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration", 
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
      opt.on("--skip-fixture",
             "Don't generation a fixture file for this model") { |v| options[:skip_fixture] = v}
    end
    
    def component
      @component
    end
end