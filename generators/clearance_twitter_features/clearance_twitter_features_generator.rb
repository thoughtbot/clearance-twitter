class ClearanceTwitterFeaturesGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.directory File.join("features", "step_definitions")

      ["features/step_definitions/clearance_twitter_steps.rb",
       "features/twitter_sign_in.feature",
       "features/twitter_sign_up.feature"].each do |file|
        m.file file, file
       end
    end
  end

end
