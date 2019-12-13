class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  
  has_secure_password

  field :username, type: String 
  field :avatar, type: String  
  field :password_digest, type: String
  
  has_many :posts, class_name: 'Article'
  has_many :comments
  has_and_belongs_to_many :articles

  validates :username, uniqueness: true
  validates :username, :password_digest, presence: true
 
  def self.from_token_request request
    # Returns a valid user, `nil` or raise `Knock.not_found_exception_class_name`
    # e.g.
      username = request.params["auth"] && request.params["auth"]["username"]
      self.find_by username: username
  end

  
end
