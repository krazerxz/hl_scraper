class HL
  def initialize(logger)
    @config = YAML.load(File.open("#{File.dirname(__FILE__)}/../../config/config.yml"))
    @logger = logger
    login
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

    begin
      click_link 'View'
    rescue
    end
    @logger.info 'HL: Logged in'
  end

  private

  def fill_password_boxes
    (1..3).each do |box_number|
      page.find(:xpath, "//*[@id='pChar#{box_number}']").select("#{password_char_at(box_number)}")
    end
  end

  def  password_char_at(index)
    character_string ||= page.find(:xpath, '//*[@id="login-box-border"]/div/p').text
    password_index = character_string.scan(/(\d+)/).map { |i| i.first.to_i - 1 }
    @config['hl_password'][password_index[index - 1]]
  end
end
