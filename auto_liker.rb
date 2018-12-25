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



# Continuous loop to break upon reaching the max likes
loop do
  # Scroll to bottom of window 3 times to load more results (20 per page)
  3.times do |i|
    browser.driver.execute_script("window.scrollBy(0,document.body.scrollHeight)")
    sleep(1)
  end

  # Call all unliked like buttons on page and click each one.
  if browser.span(:class => 'glyphsSpriteHeart__outline__24__grey_9', aria_label: "Like").exists?
    browser.spans(:class => 'glyphsSpriteHeart__outline__24__grey_9', aria_label: "Like").each { |val|
      val.click
      like_counter += 1
    }
    ap "Photos liked: #{like_counter}"
  else
    ap "No media to like rn, yo. Sorry homie, we tried."
  end
  num_of_rounds += 1
  puts "--------- #{like_counter / num_of_rounds} likes per round (on average) ----------"
  break if like_counter >= MAX_LIKES
  sleep(30) # Return to top of loop after this many seconds to check for new photos
end

Pry.start(binding)

