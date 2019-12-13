json.comments @comments do |comment|
  json.id comment.id.to_s
  json.username @user.username
  json.body comment.body
end

