class UserMailer < ApplicationMailer
  def welcome_email(blanket)
    @blanket = blanket
    mail(to: @blanket.email, subject: 'Welcome to Yarndude!')
  end

  def receipt_email(blanket)
    @blanket = blanket
    mail(to: @blanket.email, subject: 'Thank you for your purchase!')
  end

  def ready_email(blanket)
    @blanket = blanket
    mail(to: @blanket.email, subject: 'Your blanket pattern is ready!')
  end

  def daily_update_email(blanket, days)
    @blanket = blanket
    @days = days
    mail(to: @blanket.email, subject: 'Your blanket pattern is ready!')
  end
end
