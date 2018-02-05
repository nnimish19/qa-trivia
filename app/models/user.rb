class User < ApplicationRecord
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end

    # Testing
    # auth = {}
    # auth[:credentials]={}
    # auth[:credentials][:expires_at] = Time.now
    # auth[:credentials][:token]= "1"
    # auth[:info]={}
    # auth[:info][:name]= "nimish"
    # auth[:uid] = "1"
    # auth[:provider] = "facebook"
    # user = User.from_omniauth(auth)

    # where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|    #Depricated: strong parameters
    # where(provider: auth[:provider], uid: auth[:uid]).first_or_initialize.tap do |user|
    #   user.provider = auth[:provider]
    #   user.uid = auth[:uid]
    #   user.name = auth[:info][:name]
    #   user.oauth_token = auth[:credentials][:token]
    #   user.oauth_expires_at = Time.at(auth[:credentials][:expires_at])
    #   user.save!
    # end
  end
end
