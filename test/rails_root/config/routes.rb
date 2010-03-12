ActionController::Routing::Routes.draw do |map|
  ClearanceTwitter::Routes.draw(map)
  map.root :controller => 'clearance/sessions', :action => 'new'

  Clearance::Routes.draw(map)
end
