# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake/testtask'
Rake::TestTask.new do |i|
  i.test_files = FileList['test/**/**.rb']
  i.verbose = true
end
#task default: %w[test]

#task :test do
#  ruby "test/test_helper.rb"
#end

Rails.application.load_tasks
