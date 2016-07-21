require 'capybara'
require 'capybara/dsl'
require 'rspec'
require 'capybara/rspec'
require 'rspec/core'
require 'capybara/rspec/matchers'
require 'capybara/rspec/features'
require 'middleman-core'
require 'middleman-core/rack'

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers
  config.order = :random
  # A work-around to support accessing the current example that works in both
  # RSpec 2 and RSpec 3.
  fetch_current_example = if RSpec.respond_to?(:current_example)
    proc { RSpec.current_example }
  else
    proc { |context| context.example }
  end

  # The before and after blocks must run instantaneously, because Capybara
  # might not actually be used in all examples where it's included.
  config.after do
    if self.class.include?(Capybara::DSL)
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end
  end
  config.before do
    if self.class.include?(Capybara::DSL)
      example = fetch_current_example.call(self)
      Capybara.current_driver = Capybara.javascript_driver if example.metadata[:js]
      Capybara.current_driver = example.metadata[:driver] if example.metadata[:driver]
    end
  end
end
middleman_app = ::Middleman::Application.new
Capybara.app = ::Middleman::Rack.new(middleman_app).to_app do
  set :root, File.expand_path(File.join(File.dirname(__FILE__), '..'))
  set :show_exceptions, true
  set :environment, :development
end
