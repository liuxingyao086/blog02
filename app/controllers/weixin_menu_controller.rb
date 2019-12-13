class WeiXinMenuController
  def generate_menu
    weixin_client = WeixinAuthorize::Client.new(Public.first.appid, Public.first.appsecret)
    menu   = Public.first.build_menu
    result = weixin_client.create_menu(menu)
  end
end
