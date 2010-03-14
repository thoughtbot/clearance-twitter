require 'oauth'

module ClearanceTwitter

  def self.base_url
    config['base_url'] || 'https://twitter.com'
  end

  mattr_accessor :consumer

  # TODO unit test this
  def self.consumer
    @@consumer ||= begin
      options = {:site => ClearanceTwitter.base_url}
      [ :authorize_path,
        :request_token_path,
        :access_token_path,
        :scheme,
        :signature_method ].each do |oauth_option|
        options[oauth_option] = ClearanceTwitter.config[oauth_option.to_s] if ClearanceTwitter.config[oauth_option.to_s]
        end

      OAuth::Consumer.new(
        config['oauth_consumer_key'],
        config['oauth_consumer_secret'],
        options
      )
    end
  end

  # class Error < StandardError; end

  def self.config(environment=RAILS_ENV)
    @config ||= {}
    @config[environment] ||= YAML.load(File.open(RAILS_ROOT + '/config/twitter_auth.yml').read)[environment]
  end

  # def self.base_url
  #   config['base_url'] || 'https://twitter.com'
  # end

  def self.path_prefix
    URI.parse(base_url).path
  end

  # def self.api_timeout
  #   config['api_timeout'] || 10
  # end

  # def self.encryption_key
  #   raise TwitterAuth::Cryptify::Error, 'You must specify an encryption_key in config/twitter_auth.yml' if config['encryption_key'].blank?
  #   config['encryption_key']
  # end

  # def self.oauth_callback?
  #   config.key?('oauth_callback')
  # end

  def self.oauth_callback
    config['oauth_callback']
  end

end
