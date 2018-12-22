require 'watir'
require 'pry'
require 'rb-readline'
require 'awesome_print'
require_relative 'credentials'

username = $username
password = $password
users = ['zuck', 'willsmith', 'techcrunch', 'jimmyfallon', 'jimmykimmel']

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

while true
  users.each { |user|
    # Navigate to user's page
    browser.goto "instagram.com/#{user}/"

    # If not following, then follow
    if browser.button(:class => ['BY3EC', '_0mzm-', 'sqdOP', 'L3NKy']).exists?
      ap "Following #{user}"
      browser.button(:class => ['BY3EC', '_0mzm-', 'sqdOP', 'L3NKy']).click
    elsif browser.button(:class => ['_5f5mN', 'jIbKX', '_6VtSN', 'yZn4P']).exists?
      ap "Following #{user}"
      browser.button(:class => ['_5f5mN', 'jIbKX', '_6VtSN', 'yZn4P']).click
    else
      # Else unfollow
      if browser.button(:class => ['_5f5mN', '-fzfL', '_6VtSN', 'yZn4P']).exists?
        ap "Unfollowing #{user}"
        browser.button(:class => ['_5f5mN', '-fzfL', '_6VtSN', 'yZn4P']).click
        sleep(3)
        browser.button(:class => ['aOOlW', '-Cab_']).click
      end
    end
  }
  puts "========== #{Time.now} =========="
  sleep(30)
end

Pry.start(binding)