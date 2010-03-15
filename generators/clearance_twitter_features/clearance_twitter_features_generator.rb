require File.expand_path(File.dirname(__FILE__) + "/../lib/insert_commands.rb")

class ClearanceTwitterFeaturesGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory File.join("features", "step_definitions")

      ["features/step_definitions/clearance_twitter_steps.rb",
       "features/twitter_sign_in.feature",
       "features/twitter_sign_up.feature"].each do |file|
        m.file file, file
       end

      m.insert_into 'features/support/env.rb', 'World(WebMockTwitterFake)'
      m.insert_into 'features/support/env.rb', 'World(TwitterFake)'
    end
  end
end
