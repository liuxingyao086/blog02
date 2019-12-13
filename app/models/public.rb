class Public
  include Mongoid::Document
  include Mongoid::Timestamps
  include WeixinRailsMiddleware::AutoGenerateWeixinTokenSecretKey

  field :appid, type: String
  field :appsecret, type: String
  field :weixin_secret_key, type: String
  field :weixin_token, type: String

  index "weixin_secret_key" => 1
  index "weixin_token" => 1

  has_many :weixin_menus, dependent: :destroy
  # 当前公众账号的所有父级菜单
  has_many :parent_menus, class_name: "WeixinMenu", foreign_key: :public_id

  def build_menu
    parent_menus = self.parent_menus.where(parent_id: nil)
    Jbuilder.encode do |json|
      json.button (parent_menus) do |menu|
        json.name menu.name
        if menu.has_sub_menu?
          json.sub_button(menu.sub_menus) do |sub_menu|
            json.type sub_menu.type
            json.name sub_menu.name
            sub_menu.button_type(json)
          end
        else
          json.type menu.type
          menu.button_type(json)
        end
      end
    end
  end
end
