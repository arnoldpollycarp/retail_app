defmodule Thamani.Email do
  import Bamboo.Email
  use Mailgun.Client

  def welcome_email(email) do
    new_email(
      to: email,
      from: "support@myapp.com",
      subject: "Welcome to the app.",
      html_body: "<strong>Thanks for joining!</strong>",
      text_body: "Thanks for joining!"
    )
  end
end
