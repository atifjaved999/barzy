json.users @users do |user|
	json.success true
	json.partial! 'api/v1/users/user', user: user
end