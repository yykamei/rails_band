# frozen_string_literal: true

class WelcomeMailer < ApplicationMailer
  def hi
    @user = params[:user]
    mail(to: @user.email, subject: 'Hi, welcome!', bcc: 'system@example.com')
  end
end
