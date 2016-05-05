class InviteMailer < ActionMailer::Base
  default from: "BreakfastWithPhilippe@viacom.com"

  def send_invite(name, email, event)
    @name = name
    @email = email
    @event = Event.find(event)
    mail(to: email, subject: 'On Behalf Of Philippe Dauman | Breakfast with the CEO')
  end
end
