class UserMailer < ApplicationMailer
  default from: 'do-not-reply@myfirstrailsapp.com',
          reply_to: 'do-not-reply@myfirstrailsapp.com'

  def welcome_email
    @user = params[:user]
    @name = @user.name.capitalize
    mail(subject: "#{@name}, welcome to TOP-Facebook!",
         to: @user.email)
  end
end
