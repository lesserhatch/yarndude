class UserMailer < ApplicationMailer
  def receipt_email(blanket)
    @blanket = blanket
    mail(to: @blanket.email, subject: 'Thank you for your purchase!')
  end

  def ready_email(blanket)
    @blanket = blanket
    mail(to: @blanket.email, subject: 'Your blanket pattern is ready!')
  end
end
