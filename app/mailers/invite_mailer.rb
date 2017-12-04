class InviteMailer < ApplicationMailer
  def invite_user(invite, sender)
    @invite = invite
    @sender = sender
    mail(to: @invite.email, subject: "#{@sender.email} has invited you to join bloccit")
  end
end
