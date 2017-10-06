json.user do 
  json.partial! 'api/v1/users/user', user: @user
  json.social_media @user.social_media
  json.social_id @user.social_id
end