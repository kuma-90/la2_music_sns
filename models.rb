require 'bundler/setup'
Bundler.require

ActiveRecord::Base.establish_connection

class User < ActiveRecord::Base
    has_secure_password
    validates :name,
        presence: true,
        format: { with: /\A\w+\z/ }
    validates :password,
        length: { in: 5..10 }
        has_many :contribution
        has_many :likes
    
end

class Contribution < ActiveRecord::Base
    belongs_to :user
    has_many :likes
    
end

class Like < ActiveRecord::Base
    belongs_to :user
    belongs_to :contribution
end