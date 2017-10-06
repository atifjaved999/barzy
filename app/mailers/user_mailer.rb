class UserMailer < ActionMailer::Base

  def welcome(email, password)
    @email = email
    @password = password
    mail to: email, from: "atif.javed.techverx@gmail.com",:subject=>"Account Created Successfully"
  end

  def fetching_status(data)
    email = 'atif@gems.techverx.com'
    @data = data
    mail to: email, from: "atif.javed.techverx@gmail.com",:subject=>"Bars Fetching Status"
  end

end
