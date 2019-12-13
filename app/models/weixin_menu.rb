class WeixinMenu
  include Mongoid::Document
  include Mongoid::Timestamps

  # 所属父级菜单，如果当前是父级菜单，则此值为空
  field :parent_id, type: String
  field :name, type: String
  field :key, type: String
  field :url, type: String 
  # 是否显示
  field :is_show, type: Boolean
  # 排序功能
  field :sort, type: Integer 
  
  index "public_id" => 1
  index "parent_id" => 1  
  index "key" => 1 

  CLICK_TYPE = "click" # key
  VIEW_TYPE  = "view"  # url
  
  belongs_to :public

  has_many :sub_menus, class_name: "WeixinMenu", foreign_key: :parent_id

  def has_sub_menu?
    sub_menus.present?
  end

  # 优先为 click 类型
  def type
    key.present? ? CLICK_TYPE : VIEW_TYPE
  end

  def button_type(jbuilder)
    is_view_type? ? (jbuilder.url url) : (jbuilder.key key)
  end

  def is_view_type?
    type == VIEW_TYPE
  end
end