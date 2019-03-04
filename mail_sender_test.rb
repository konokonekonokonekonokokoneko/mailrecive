require 'dotenv'
require 'selenium-webdriver'
require 'chromedriver-helper'
# とりあえず.envは読み込んどく
# 内容は以下の通り
# MAIL_ADDRESS=''
# ACCOUNT_ID=''
# PASSWORD=''
Dotenv.load
# webdriverの条件
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
driver = Selenium::WebDriver.for :chrome, options: options
wait = Selenium::WebDriver::Wait.new(:timeout => 30)

# スクショの大きさです
page_width = 1200
page_height = 2000
driver.manage.window.resize_to(page_width, page_height)

# ログイン先のURL
START_URL = 'https://mail.google.com/mail/u/0/#label/kaggle'
driver.navigate.to START_URL
# ちょっと確認のためです
driver.save_screenshot './inbox.png'
# 待ちますわ
wait.until {driver.find_element(:id, 'Email').displayed?}
# 入力します
element = driver.find_element(:id, 'Email')
element.send_keys(ENV['MAIL_ADDRESS'])
driver.save_screenshot './input_id.png'
# とりあえずボタン押す
driver.find_element(:id, 'next').click
# 結果は？
driver.save_screenshot './click_first_time.png'
# softbankの画面が出ました
#p driver.page_source
# まあ待ちますわ
wait.until {driver.find_element(:name, 'IDToken1').displayed?}
# 今度はnameでみます
element = driver.find_element(:name, 'IDToken1')
element.send_keys(ENV['ACCOUNT_ID'])
driver.find_element(:name, 'IDToken2').send_keys(ENV['PASSWORD'])
# とりあえずみます
driver.save_screenshot './softbank_login.png'
wait.until {driver.find_element(:id, 'loginFormButton').displayed?}
driver.find_element(:id, 'loginFormButton').click
driver.save_screenshot './click_second_time.png'
# これで認証できたはず
p driver.page_source
