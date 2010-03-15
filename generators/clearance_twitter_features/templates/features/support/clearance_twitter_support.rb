# If you want to use something other than WebMock to fake remote HTTP resources
# replace WebMockTwitterFake with your own module

require 'clearance_twitter/web_mock_twitter_fake'
require 'clearance_twitter/twitter_fake'

World(WebMockTwitterFake)
World(TwitterFake)
