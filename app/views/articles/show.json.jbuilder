json.article do
  json.id @article.id.to_s
  json.title @article.title
  json.text @article.text
  json.created_at @article.created_at&.strftime("%F %T")
  json.page_view @article.page_view
  json.redis_page_view $redis.get("page_view:#{@article.id}")
end