class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  #评论内容
  field :body, type: String
  #文章id
  field :article_id, type: String  
  #用户id
  field :user_id, type: String  
  
  validates :body, :article_id, presence: true

  belongs_to :article
  belongs_to :user
end
