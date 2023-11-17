class UserMailer < ApplicationMailer
  default from: 'registrations@top-facebook.com',
          reply_to: 'do-not-reply@top-facebook.com'

  def welcome_email
    @user = params[:user]
    @name = @user.name.capitalize
    mail(subject: "#{@name}, welcome to TOP-Facebook!",
         to: @user.email)
  end
end
