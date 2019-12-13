class ApplicationController < ActionController::API
  include Knock::Authenticable
  before_action :is_login
  before_action :authenticate_user
  
  def is_login
    puts "_______________is_login#{current_user.id}"
    render json: { state: 0, notice: '请先登录' } if current_user.nil?
  end
end
