class FakeTwitterUser
  def self.clear_remote_profiles
  end

  def self.add_remote_profile(profile_hash)
  end

  def self.get_remote_profile(username)
  end
end

class FakeTwitterSession
  def self.logout
  end

  def self.login(twitter_user)
  end
end
