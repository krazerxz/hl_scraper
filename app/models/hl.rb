class HL
  REFRESH_TIME = 600 # 10 minutes

  def initialize(logger)
    @config = YAML.load(File.open("#{File.dirname(__FILE__)}/../../config/config.yml"))
    @logger = logger
    @holdings_parser = HoldingsParser.new
    @refreshing = false
    login
  end

  def is_refreshing?
    @refreshing
  end

  def login
    visit @config['hl_url']
    fill_in 'username', with: @config['hl_username']
    fill_in 'DoB',      with: @config['hl_dob']

    @logger.info 'HL: Filled in user and DoB'
    click_button 'submit'
    fill_password_boxes
    @logger.info 'HL: Filled in password'
    click_button 'submit'

    click_link 'View'
  rescue
    @logger.info 'HL: Logged in' if logged_in?
  end

  def refresh_holdings_page
    @refreshing = true
    @logger.info 'HL: Refreshing holdings page'
    begin
      visit page.driver.browser.current_url
    rescue
      @logger.info 'HL: Refreshed holdings page' if logged_in?
    end
    @refreshing = false
  end

  def stock_data
    return nil unless logged_in?
    @holdings_parser.parse(page.body)
  end

  private

  def fill_password_boxes
    (1..3).each do |box_number|
      page.find(:xpath, "//*[@id='pChar#{box_number}']").select("#{password_char_at(box_number)}")
    end
  end

  def logged_in?
    page.has_css?('#holdings-table')
  end

  def  password_char_at(index)
    character_string ||= page.find(:xpath, '//*[@id="login-box-border"]/div/p').text
    password_index = character_string.scan(/(\d+)/).map { |i| i.first.to_i - 1 }
    @config['hl_password'][password_index[index - 1]]
  end

  def refresh_thread
    Thread.new do
      loop do
        sleep REFRESH_TIME
        refresh_holdings_page
      end
    end
  end
end
