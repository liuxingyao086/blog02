class UserTokenController < Knock::AuthTokenController
  skip_before_action :verify_authenticity_token, raise: false
 
  rescue_from NotFound, with: :not_found

  #用户登录方法
  def create
    p "________________#{params[:auth][:username]}"
    user = User.find_by(username: params[:auth][:username])
    render json: auth_token, status: :created
  end
  

  def not_found
    render json: { state: -1, notice: '用户名或密码不正确' }
  end
end
