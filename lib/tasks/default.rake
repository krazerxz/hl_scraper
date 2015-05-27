if ENV['RACK_ENV'] != 'production'
  require "rake/clean"

  CLEAN.include "log/**"

  task :default => [:clean, :rubocop, :ok]

  task :ok do
    puts 'BUILD ' + Rainbow('S').red + Rainbow('U').green + Rainbow('C').yellow + Rainbow('C').blue + Rainbow('E').red + Rainbow('S').green + Rainbow('S').yellow + Rainbow('F').blue + Rainbow('U').red + Rainbow('L').green
  end
end
