class Response < ApplicationRecord
  validates :statement, presence: true
  belongs_to :user
  belongs_to :question

  # https://stackoverflow.com/questions/37750087/calling-a-method-of-another-controller: use self
  # https://stackoverflow.com/questions/8225518/calling-a-method-from-another-controller
  # https://stackoverflow.com/questions/16375188/redis-strings-vs-redis-hashes-to-represent-json-efficiency
  def self.fetch_all

    # Using String Data type on Array of Objects: Not a good idea: need to add new responses frequently.
    # responses = $redis.get('responses')
    # if responses.nil?
    #   responses = Response.all.to_json
    #   $redis.set('responses', responses)
    #   $redis.expire("responses", 1.hour.to_i)
    # end
    # responses = JSON.load responses

    # Look at what are the operations that you want to do - and then pick a data-type accordingly
    # Store single object as KEY
    # Redis STRING:
        # If you use most of the fields on most of your accesses.
        # If there is variance on possible keys.
    # Redis Hashes: https://stackoverflow.com/questions/9832124/saving-a-hash-to-redis-on-a-rails-app
        # If you use just single fields on most of your accesses.
        # If you always know which fields are available (bcz while creating hash entry for an "object" we need to explicitly specify every "field", "value"
        #Example: $redis.hmset("user:1000",:username,"antirez",:birthyear,"1977",:verified, "1")
        # $redis.hgetall "user:1000"         >> {"username"=>"antirez", "birthyear"=>"1977", "verified"=>"1"}
        # $redis.hget "user:1000",:username  >> "antirez"
    Response.all
  end

end
