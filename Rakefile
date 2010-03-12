# encoding: utf-8

require 'rake'
require 'rake/testtask'
require 'cucumber/rake/task'

namespace :test do
  Rake::TestTask.new(:basic => ["link",
                                "generator:clearance_twitter"]) do |task|
    task.libs << "lib"
    task.libs << "test"
    task.test_files = FileList['test/**/*_test.rb'] - FileList['test/rails_root/**/*_test.rb']
    task.verbose = false
  end

  Cucumber::Rake::Task.new(:features => ["link",
                                         "generator:clearance_twitter",
                                         "generator:clearance_twitter_features"]) do |t|
    t.cucumber_opts   = "--format progress"
    t.profile = 'features'
  end
end

generators = %w(clearance_twitter clearance_twitter_facebook)

desc "Cleaned up generated files"
task :cleanup do
  FileList["test/rails_root/db/**/*twitter*"].each do |each|
    FileUtils.rm_rf(each)
  end
  FileUtils.rm_rf("test/rails_root/vendor/plugins/clearance_twitter")
  FileUtils.rm_rf("test/rails_root/db/schema.rb")
  FileList["test/rails_root/db/*.sqlite3"].each do |each|
    FileUtils.rm_rf(each)
  end
end

desc "Links the plugin into the test rails_root"
task :link => :cleanup do
  clearance_twitter_root = File.expand_path(File.dirname(__FILE__))
  system("ln -s #{clearance_twitter_root} test/rails_root/vendor/plugins/clearance_twitter")
end

namespace :generator do
  desc "Run the clearance_twitter generator"
  task :clearance_twitter do
    system "cd test/rails_root && ./script/generate clearance_twitter -f && rake db:migrate db:test:prepare"
  end

  desc "Run the clearance_twitter features generator"
  task :clearance_twitter_features do
    system "cd test/rails_root && ./script/generate clearance_twitter_features -f"
  end
end

desc "Run the test suite"
task :default => ['test:basic', 'test:features']

require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name        = "clearance-twitter"
  gem.summary     = "Twitter engine for Clearance"
  gem.description = "Twitter engine for Clearance"
  gem.email       = "support@thoughtbot.com"
  gem.homepage    = "http://github.com/thoughtbot/clearance-twitter"
  gem.authors     = ["thoughtbot, inc."]
  gem.files       = FileList["[A-Z]*", "{app,config,generators,lib,rails}/**/*"]

  gem.add_dependency "clearance", ">= 0.8.6"
end

Jeweler::GemcutterTasks.new
