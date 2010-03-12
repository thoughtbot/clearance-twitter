module ClearanceTwitter
  module Routes
    def self.draw(map)
      map.resources :twitter_users, :controller => 'clearance_twitter/twitter_users',
                                    :only       => [:new, :create]
    end
  end
end
