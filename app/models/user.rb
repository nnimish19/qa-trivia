class User < ApplicationRecord
  has_many :questions
  has_many :responses
  after_save :update_cache

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end

    # For current usage it would be better to do caching at object level. key = "user:{id}", value = "JSON"
    # This would allow to get a particular user properties on the bases of its keys.
    def self.fetch_all
      users = $redis.get('users')
      if users.nil?
        users = User.all.to_json    #array of users(hashes). Cannot find individual user
        $redis.set('users', users)
        $redis.expire("users", 1.day.to_i)
      end
      Rails.logger.info users   #[{"id":12,"statement":"sun", "eval":true, "user_id":5,"question_id":1,"created_at":"2018-02-08T18:33:39.986Z"},
      # {"id":13,"statement":"nimisH","eval":true, "user_id":5,"question_id":2,"created_at":"2018-02-08T18:33:54.020Z"}]

      users = JSON.parse users
      Rails.logger.info users #[{"id"=>12, "statement"=>"sun", "eval"=>true, "user_id"=>5, "question_id"=>1, "created_at"=>"2018-02-08T18:33:39.986Z"},
      # {"id"=>13, "statement"=>"nimisH", "eval"=>true, "user_id"=>5, "question_id"=>2, "created_at"=>"2018-02-08T18:33:54.020Z"}]
      users
    end

    def update_cache
      $redis.del "users" if $redis.exists "users"
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
