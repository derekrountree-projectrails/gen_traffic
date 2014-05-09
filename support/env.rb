require 'rubygems'
require 'ruby-debug'
require 'cucumber/formatter/unicode'
require 'capybara'
# require 'rspec/expectations' 
require 'test/unit/assertions'
require 'erb'
require 'nokogiri'
require 'capybara/poltergeist'
# require 'active_support/core_ext/object/blank'

include Test::Unit::Assertions
include Capybara::DSL
include Capybara::Helpers
# include Capybara::RSpecMatchers

BaseURL = 'http://ypuqa.np.wc1.yellowpages.com'
WaitTime = 15
Capybara.configure do |config|
  config.match                    = :prefer_exact
  config.ignore_hidden_elements   = true
  config.exact_options            = true
  config.visible_text_only        = true
  config.default_driver           = :poltergeist
  config.javascript_driver        = :poltergeist
  config.app_host                 = BaseURL
  config.run_server               = false
  config.default_wait_time        = WaitTime
  config.default_host             = Capybara.app_host
  config.default_selector         = :css
  config.automatic_reload         = true
end
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
    :timeout              => 90,
    :window_size          => [1080, 1920],
    :js                   => true,
    :inspector            => true,
    :js_errors            => false,
    :debug                => false,
    :phantomjs_options    => ['--load-images=no', 
                              '--disk-cache=false', 
                              '--ignore-ssl-errors=yes', 
                              '--web-security=no' 
                              ] )
end

def show_screen(name='temp.png')
  save_screenshot(name)
  `open #{name}`
end

headers = { "Host"        => "sales.ypuqa.np.wc1.yellowpages.com", 
            "User-Agent"  => "Mozilla/5.0 (Windows NT 6.1\; Win64\; x64\; rv:25.0) Gecko/20100101 Firefox/25.0" }
page.driver.browser.set_headers(headers)