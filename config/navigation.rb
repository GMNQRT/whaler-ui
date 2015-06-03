SimpleNavigation::Configuration.run do |navigation|
  prefix = "/#!/"
  navigation.selected_class = 'current'
  navigation.items do |primary|
    primary.dom_class = 'nav'
    primary.item :home, "#{fa_icon("th-large")} Dashboard".html_safe, '/'
    primary.item :container, "#{fa_icon("tasks")} Conteners".html_safe, prefix + "container"
    primary.item :image, "#{fa_icon("picture-o")} Images".html_safe, prefix + "images"
    primary.item :logout, "#{fa_icon("sign-out")} Sign out".html_safe, prefix + "signout"
  end

end