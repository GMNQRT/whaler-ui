SimpleNavigation::Configuration.run do |navigation|
  navigation.selected_class = 'current'
  navigation.items do |primary|
    primary.dom_class = 'nav'
    primary.item :home, "#{fa_icon("th-large")} <span>Dashboard</span>".html_safe, '/', html: { data: { 'ng-class' => '{ active: controller == "homeCtrl"}'  }}
    primary.item :user, "#{fa_icon("user")} <span>Users</span>".html_safe, "/users", html: { data: { 'ng-class' => '{ active: controller == "userCtrl"}'  }}
    primary.item :container, "#{fa_icon("tasks")} <span>Containers</span>".html_safe, "/container", html: { data: { 'ng-class' => '{ active: controller == "containerCtrl"}'  }}
    primary.item :image, "#{fa_icon("picture-o")} <span>Images</span>".html_safe, "/images", html: { data: { 'ng-class' => '{ active: controller == "imageCtrl"}'  }}
  end

end
