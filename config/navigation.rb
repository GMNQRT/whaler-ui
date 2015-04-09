SimpleNavigation::Configuration.run do |navigation|
  prefix = "/#!/"
  navigation.selected_class = 'current'
  navigation.items do |primary|
    primary.dom_class = 'nav navbar-nav'
    primary.item :home, 'Home', prefix
    primary.item :container, 'Contener', prefix + "container"
    # primary.item :menu_about_us, 'About Us', about_us_path
    # primary.item :menu_blog, 'Blog', posts_path
    # primary.item :menu_contact_us, 'Contact Us', contact_us_path
  end
end 