Rake.add_rakelib "lib/tasks"

if `gem list -i "^rake$"`.chomp == "true"
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
end
