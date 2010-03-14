module ClearanceTwitter
  module Routes
    def self.draw(map)
      map.resources :twitter_users, :controller => 'clearance_twitter/twitter_users',
                                    :only       => [:new, :create],
                                    :collection => { :oauth_callback => :get }
    end
  end
end
