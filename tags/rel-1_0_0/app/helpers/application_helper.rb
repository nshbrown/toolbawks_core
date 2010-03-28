module ApplicationHelper
  def toolbawks_core_head
    <<-EOL
    #{ stylesheet_link_tag 'Toolbawks', :plugin => 'toolbawks_core' }
    #{ javascript_include_tag 'Toolbawks', :plugin => 'toolbawks_core' }
EOL
  end
end