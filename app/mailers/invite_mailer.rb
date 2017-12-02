class InviteMailer < ApplicationMailer
  def invite_user(user, inviter)
    @user = user
    @inviter = inviter
    mail(to: @user.email, subject: "#{@inviter.email} has invited you to join bloccit")
  end
end
