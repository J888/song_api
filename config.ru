# cat config.ru
require "roda"
require "sequel"
require_relative "models"
require_relative "app/app_main"

run AppMain.app
