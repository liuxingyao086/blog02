class CommentsController < ApplicationController
  skip_before_action :authenticate_user, only: [:index, :show]
  skip_before_action :is_login, only: [:index]
  #创建评论的方法
  def create
    @article = Article.find(params[:article_id])
    puts "____________________#{comment_params.merge({article_id: params[:article_id]})}"
    @comment = current_user.comments.new(comment_params.merge({article_id: params[:article_id]}))
    if @comment.save
      render json: { state: 1, notice: '评论成功' }
    else
      render json: { state: -1, notice: @comment.errors.full_messages }
    end
  end

  #删除评论的方法
  def destroy
    @comment = Comment.find(params[:id])
    unless @comment
      render json: { state: -2, notice: '没有不到评论'}
      return
    end
    if current_user.id.eql? @comment.user_id
      @comment.destroy
      render json: { state: 1, notice: '删除成功' }
    else
      render json: { state: -1, notice: '删除失败' }
    end
  end

  #展示评论的方法
  def index
    @comments = Comment.where({article_id: params[:article_id]})
    @comments.each do |comment|
      puts "用户id为 = #{comment.user_id}"
      @user = User.find(comment.user_id)
    end
  end
  
private
  def comment_params
    params.permit(:body)
  end
end
