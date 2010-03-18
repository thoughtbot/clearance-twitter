module ClearanceTwitterHelper
  def twitter_connect_button(twitter_image_tag)
    twitter_image_tag ||= image_tag('sign_in_with_twitter.png', :alt => 'Sign in using Twitter')
    link_to twitter_image_tag, new_twitter_user_path
  end
end
