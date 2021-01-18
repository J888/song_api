migrate = lambda do |env, version|
  ENV['RACK_ENV'] = env
  require_relative 'db'
  require 'logger'
  Sequel.extension :migration
  DB.loggers << Logger.new($stdout) if DB.loggers.empty?
  Sequel::Migrator.apply(DB, 'migrate', version)
end

desc "Migrate development database to latest version"
task :dev_up do
  migrate.call('development', nil)
end
task :dev_down do
  migrate.call('development', 0)
end
