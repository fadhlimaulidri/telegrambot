require './dependencies'
require_all './config/*.rb'
require_all './lib/**/*.rb'
require_all './app/**/*.rb'

map('/release_trains') { run ReleaseTrainsController }
