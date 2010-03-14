module ClearanceTwitter
  module Dispatcher
    module Shared
      # def post!(status)
      #   self.post('/statuses/update.json', :status => status)
      # end

      # def append_extension_to(path)
      #   path, query_string = *(path.split("?"))
      #   path << '.json' unless path.match(/\.(:?xml|json)\z/i)
      #   "#{path}#{"?#{query_string}" if query_string}"
      # end

      def handle_response(response)
        case response
        when Net::HTTPOK 
          begin
            JSON.parse(response.body)
          rescue JSON::ParserError
            response.body
          end
        when Net::HTTPUnauthorized
          raise TwitterAuth::Dispatcher::Unauthorized, 'The credentials provided did not authorize the user.'
        else
          message = begin
            JSON.parse(response.body)['error']
          rescue JSON::ParserError
            if match = response.body.match(/<error>(.*)<\/error>/)
              match[1]
            else
              'An error occurred processing your Twitter request.'
            end
          end

          raise TwitterAuth::Dispatcher::Error, message
        end
      end
    end
  end

  module LinkedUser
    TWITTER_ATTRIBUTES = [
      :name
    ]

    def self.included(model)
      # TODO Unit test the following
      # base.class_eval do
      #   attr_protected :access_token, :access_secret
      # end

      model.class_eval do
        extend ClearanceTwitter::LinkedUser::ClassMethods
        extend ClearanceTwitter::Dispatcher::Shared
        include InstanceMethods
      end
    end

    module InstanceMethods
      def email_optional?
        super || twitter_user?
      end

      def password_optional?
        super || twitter_user?
      end

      def twitter_user?
        twitter_access_token.present?
      end

      def assign_twitter_attributes(hash)
        TWITTER_ATTRIBUTES.each do |att|
          send("#{att}=", hash[att.to_s]) if respond_to?("#{att}=")
        end
      end

      # def facebook_user
      #   if facebook_user?
      #     Facebooker::User.new(fb_user_id)
      #   else
      #     nil
      #   end
      # end

      # def linked_on_facebook_to?(facebook_user)
      #   facebook_user.uid == fb_user_id
      # end

      # def link_on_facebook_to(facebook_user)
      #   self.fb_user_id = facebook_user.uid
      #   save
      # end
    end

    module ClassMethods
      def identify_or_create_from_access_token(token, secret=nil)
        # raise ArgumentError, 'Must authenticate with an OAuth::AccessToken or the string access token and secret.' unless (token && secret) || token.is_a?(OAuth::AccessToken)

        token = OAuth::AccessToken.new(ClearanceTwitter.consumer, token, secret) unless token.is_a?(OAuth::AccessToken)

        response = token.get(ClearanceTwitter.path_prefix + '/account/verify_credentials.json')
        user_info = handle_response(response)

        puts "*"*80
        puts "user_info:"
        p user_info

        if user = User.find_by_twitter_username(user_info['screen_name'].to_s)
          puts "found existing user with twitter_username"
          user.twitter_username = user_info['screen_name']
          user.assign_twitter_attributes(user_info)
          user.twitter_access_token = token.token
          user.twitter_access_secret = token.secret
          raise "Inside #identify_or_create_from_access_token, trying to save invalid user:\n#{user.errors.full_messages}" if !user.valid?
          user.save

          puts "*"*80
          puts "the new User:"
          p user

          user
        else
          puts "found existing user with twitter_username"
          User.create_from_twitter_hash_and_token(user_info, token) 
        end
      end

      def create_from_twitter_hash_and_token(user_info, access_token)
        user = User.new_from_twitter_hash(user_info)
        user.twitter_access_token = access_token.token
        user.twitter_access_secret = access_token.secret
        raise "Inside #create_from_twitter_hash_and_token, trying to save invalid user:\n#{user.errors.full_messages}" if !user.valid?
        user.save
        user
      end

      def new_from_twitter_hash(hash)
        # raise ArgumentError, 'Invalid hash: must include screen_name.' unless hash.key?('screen_name')
        # raise ArgumentError, 'Invalid hash: must include id.' unless hash.key?('id')

        user = User.new
        # TODO Add test to motivate #twitter_id
        # user.twitter_id = hash['id'].to_s
        user.twitter_username = hash['screen_name']
        user.assign_twitter_attributes(hash)

        user
      end
    end

    # def token
    #   OAuth::AccessToken.new(TwitterAuth.consumer, access_token, access_secret)
    # end 
  end
end

