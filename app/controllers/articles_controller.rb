class ArticlesController < ApplicationController
  skip_before_action :authenticate_user, only: [:index, :show, :likes]
  skip_before_action :is_login, only: [:index, :show, :likes]
  #展示全部文章的方法
  def index
    @articles = Article.all.page(params[:page]).order(top: :desc, created_at: :desc)
    if @articles.blank?
      return render json: { state: -1, notice: '没有找到文章' }
    end
  end
  
  #用户创建文章的方法
  def create
    puts "___________#{current_user.id}"
    @article = current_user.posts.new(article_params)
    if @article.save
      render json: { state: 1, notice: '文章提交成功' }
    else
      render json: { state: -1, notice: @article.errors.full_messages}
    end
  end
  
  #删除自己写的文章
  def destroy
    @article = Article.find(params[:id])
    puts "___________________#{@article}"
    unless @article
      render json: { state: -2, notice: '没有找到文章'}
      return
    end  
    if @article.user_id.eql? current_user.id
      @article.destroy
      render json: { state: 1, notice: '文章删除成功' }
    else
      render json: { state: -1, notice: '文章删除失败'}
    end
  end

  #修改自己写的文章
  def update
    @article = Article.find(params[:id])
    puts "________________#{@article.user_id == current_user.id}"
    if @article.user_id.eql? current_user.id
      @article.update(article_params)
      render json: { state: 1, notice: '文章修改成功' }
    else
      render json: { state: -1, notice: '文章修改失败'}
    end
  end  

  #展示单篇文章的方法
  def show
    @article = Article.find(params[:id])
    @article.update(page_view: @article.page_view + 1)
    $redis.incr("page_view:#{@article.id}")
  end

  #用户显示自己文章的方法
  def my
      @articles = current_user.posts.page(params[:page]).order(created_at: :desc)
  end

  #对喜欢的文章点赞的方法
  def like
    @article = Article.find(params[:id])
    if  current_user.article_ids.include?(@article.id)
      render json: { state: -1, notice: '已经点赞过了' }  
    else
      current_user.articles.push(@article)
      # @article.user_ids.push(current_user.id.to_s)
      render json: { state: 1, notice: '点赞成功' } 
    end
  end
  
  #查看该文章被多少用户点赞收藏的方法
  def likes
    @sum = Article.find(params[:id]).user_ids.length
    render json: { state: 1, counts: @sum}
  end
  
  #让文章置顶的方法
  def top
    #先判断当前文章自己是否为1  为0就继续执行
    @article = Article.find(params[:id])
    puts "_________#{@article}"
    if @article.top == 0
    #点完按钮之后状态为1
      @result = Article.find_by(top: 1)
      if @result
        @article.update(top: 1)
        @result.update(top: 0)
        render json: { state: 1, notice: '文章置顶成功'}
        return
      end   
      @article.update(top: 1)
      render json: { state: 1, notice: '文章置顶成功'}
      return
    end
    render json: { state: -1, notice: '文章已经置顶'}
  end  

private
  def article_params
    params.require(:article).permit(:title, :text)
  end
end
