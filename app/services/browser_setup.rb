class BrowserSetup

  def self.setup_session url
      Capybara.register_driver :selenium do |app|
          Capybara::Selenium::Driver.new(app, browser: :chrome,
            args: ['headless', 'no-sandbox', 'disable-gpu']
          )
      end
      Capybara.javascript_driver = :chrome
      Capybara.configure do |config|  
        config.default_max_wait_time = 10
        config.default_driver = :selenium
      end
      browser = Capybara::Session.new(:selenium)
      browser.visit(url)
      browser
  end

end