require 'chatterbot/dsl'
require 'youtube_it'

# https://github.com/ddollar/foreman/wiki/Missing-Output
$stdout.sync = true

whitelist = ENV['BOT_WHITELIST'].split( ',' )
sleep_time = ENV['BOT_SLEEP_TIME'].to_i

puts "starting tweetube_bot"
puts "whitelist usernames: #{whitelist}"
puts "sleep time: #{sleep_time} secs"
puts "=========="

# TODO: change to streaming api
loop do
  puts 'checking replies'

  replies do |tweet|
    from_user = tweet.from_user

    if whitelist.include?( from_user )
      query = tweet.text.gsub( /@\w+ /, '')
      puts "searching '#{query}' for #{from_user}"

      client = YouTubeIt::Client.new
      response = client.videos_by( query: query )

      link = "http://www.youtube.com/watch?v=#{response.videos.first.unique_id}"
      reply "#USER# here's your link: #{link}", tweet
    else
      puts "unautorized access from #{from_user}"
    end
  end

  update_config

  puts "sleeping for #{sleep_time} secs"
  sleep sleep_time
end
