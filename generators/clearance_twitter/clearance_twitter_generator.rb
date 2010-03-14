require File.expand_path(File.dirname(__FILE__) + "/lib/insert_commands.rb")

class ClearanceTwitterGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      if defined?(ActiveRecord)
        m.migration_template "migration.rb",
                             'db/migrate',
                             :migration_file_name => "add_clearance_twitter_fields_to_users"
      end
     m.insert_into 'app/controllers/application_controller.rb',
                   'helper :clearance_twitter'
     m.insert_into 'config/routes.rb', 'ClearanceTwitter::Routes.draw(map)'
     m.file 'sign_in_with_twitter.png', 'public/images/sign_in_with_twitter.png'
     m.file 'twitter_auth.yml', 'config/twitter_auth.yml'
     m.insert_into 'app/models/user.rb', "include ClearanceTwitter::LinkedUser",
                   :after => /include Clearance::User\s*$/
     m.readme "README"
    end
  end
end
