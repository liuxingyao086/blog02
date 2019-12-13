class Article
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  include Mongoid::Tree

  #文章的标题
  field :title, type: String
  #文章的内容
  field :text, type: String
  #文章阅读量
  field :page_view, type: Integer, default: 0
  #置顶
  field :top, type: Integer, default: 0
  
  #限制标题和内容不能为空
  validates :title, :text, presence: true
  #validates :text, presence: true
  #validates :title, uniqueness: { conditions: -> { where(deleted_at: nil) } }

  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :users
  
  belongs_to :user, class_name: 'User'
end
