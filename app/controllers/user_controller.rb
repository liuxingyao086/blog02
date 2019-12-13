class UserController < ApplicationController

  skip_before_action :authenticate_user, only: [:register, :index]
  skip_before_action :is_login, only: [:register]
  #用户注册的方法
  def register
    # render json: { state: 1, notice: '注册成功' }
    puts "register方法执行了"
    @user = User.new(user_params)
    if @user.save
      render json: { state: 1, notice: '注册成功' }
    #render {:json => {:state => 1, :notice => "注册成功" }}
    else
      render json: { state: -1, notice: @user.errors.full_messages }
      #render :json => {:state => -1, :notice => @user.errors.full_messages }
    end
  end

  #查询该用户点赞了哪些文章的方法
  def likes
    @articles = current_user.articles
  end
  
  #用户取消点赞收藏的方法
  def dislike
    @article = Article.find(params[:article_id])
    if current_user.article_ids.include?(@article.id)
      current_user.articles.delete(@article)
      render json: { state: 1, notice: '取消成功' } 
    else
      render json: { state: -1, notice: '取消失败' } 
    end  
  end
  
  #上传头像
  def avatar_upload
    current_user.avatar = params[:image]
    # @image = current_user.new(avatar: params[:image])
    puts "_____________#{current_user.avatar}"
    if current_user.save
      render json: { state: 1, notice: '头像上传成功' }
    else
      render json: { state: -1, notice: '格式不正确', errors: current_user.errors }    
    end
  end

  private
    # 需要用户ID的方法
    def set_user
      @user = User.find(params[:id])
    end

    # 获取用户名和密码的方法
    def user_params
      params.require(:auth).permit(:username, :password)
    end
end
  

