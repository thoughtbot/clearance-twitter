module ClearanceTwitter
  class Unauthorized < Exception; end

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
        include ClearanceTwitter::LinkedUser::InstanceMethods
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

      def update_from_twitter_access_token(access_token)
        hash = self.class.twitter_hash_from_access_token(access_token)
        update_from_twitter_hash_and_access_token(hash, access_token)
      end

      def update_from_twitter_hash_and_access_token(hash, access_token)
        populate_from_twitter_hash_and_access_token(hash, access_token)
        save
        self
      end

      def populate_from_twitter_hash_and_access_token(hash, access_token)
        assign_twitter_attributes(hash)
        self.twitter_id = hash['id'].to_s
        self.twitter_username = hash['screen_name']
        self.twitter_access_token = access_token.token
        self.twitter_access_secret = access_token.secret
      end

      def assign_twitter_attributes(hash)
        TWITTER_ATTRIBUTES.each do |att|
          send("#{att}=", hash[att.to_s]) if respond_to?("#{att}=")
        end
      end
    end

    module ClassMethods
      def twitter_hash_from_access_token(access_token, secret=nil)
        unless (access_token && secret) || access_token.is_a?(OAuth::AccessToken)
          raise ArgumentError, 'Must authenticate with an OAuth::AccessToken or the string access token and secret.'
        end

        access_token = OAuth::AccessToken.new(ClearanceTwitter.consumer, access_token, secret) unless access_token.is_a?(OAuth::AccessToken)
        response = access_token.get(ClearanceTwitter.path_prefix + '/account/verify_credentials.json')
        twitter_hash = handle_response(response)
      end

      def identify_or_create_from_access_token(access_token, secret=nil)
        twitter_hash = twitter_hash_from_access_token(access_token, secret)
        twitter_username = twitter_hash['screen_name'].to_s

        user = User.find_by_twitter_username(twitter_username) || User.new
        user.update_from_twitter_hash_and_access_token(twitter_hash, access_token)
      end

      private

      # TODO: Re-TDD this method
      def handle_response(response)
        case response
        when Net::HTTPOK 
          begin
            JSON.parse(response.body)
          rescue JSON::ParserError
            response.body
          end
        when Net::HTTPUnauthorized
          raise ClearanceTwitter::Unauthorized, 'The credentials provided did not authorize the user.'
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
end

