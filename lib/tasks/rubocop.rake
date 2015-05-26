if ENV['RACK_ENV'] != 'production'
  require 'rubocop/rake_task'

  RuboCop::RakeTask.new
end
