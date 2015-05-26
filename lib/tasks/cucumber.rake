if ENV['RACK_ENV'] != 'production'
  require 'cucumber/rake/task'

  namespace :cucumber do

    Cucumber::Rake::Task.new(:ok, 'Run features that should pass') do |t|
      t.cucumber_opts = "--format pretty"
      t.profile = 'ok'
    end

    Cucumber::Rake::Task.new(:wip, 'Run features that are being worked on') do |t|
      t.cucumber_opts = "--format pretty"
      t.profile = 'wip'
    end

    desc 'Run all features'
    task :all => [:ok, :wip]
  end

  desc 'Alias for cucumber:ok'
  task :cucumber => 'cucumber:ok'
end
