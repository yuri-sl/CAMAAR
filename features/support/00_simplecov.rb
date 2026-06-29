# Carregado antes de env.rb (ordem alfabética) para instrumentar a cobertura
# antes do Rails ser inicializado. Resultado é mesclado com o do RSpec.
require "simplecov"
SimpleCov.command_name "Cucumber"
SimpleCov.start "rails"
