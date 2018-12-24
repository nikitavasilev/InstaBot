require 'watir'
require 'pry'
require 'rb-readline'
require 'awesome_print'
require_relative 'credentials'

username = $username
password = $password
like_counter = 0
num_of_rounds = 0
MAX_LIKES = 1500

# Open Browser, Navigate to Login page
browser = Watir::Browser.new :chrome, switches: ['--incognito']

browser.goto 'instagram.com/accounts/login/'

# Navigate to Username and Password fields, inject info
ap 'Logging in...'
browser.text_field(:name => 'username').set "#{username}"
browser.text_field(:name => 'password').set "#{password}"

# Click Login Button
browser.button(:class => ['_0mzm-', 'sqdOP', 'L3NKy']).click
puts 'We\'re logged in.'

sleep(5)

# If Turn On Notifications modal is present, we close it
if browser.div(:class => ['pbNvD', 'fPMEg']).exists?
  browser.button(:class => ['aOOlW', 'HoLwm']).click
end

puts "Before while loop"
while true
  3.times do |i|
    browser.driver.execute_script("window.scrollBy(0, document.body.scrollHeight)")
    sleep(1)
  end
  puts "3 times scrolling done."
  puts "Before liking."
  if browser.span(:class => "fr66n").exists?
    browser.spans(:class => "fr66n").each { |val|
      val.click
      like_counter += 1
      puts "liking"
    }
    puts "Finished liking"
    ap "Photos liked: #{like_counter}"
  else
    ap "No media to like right now. Sorry, we tried."
  end
  num_of_rounds += 1
  puts "========== #{like_counter / num_of_rounds} like per round (on average) =========="
  break if like_counter >= MAX_LIKES
  sleep(30)
end

Pry.start(binding)

