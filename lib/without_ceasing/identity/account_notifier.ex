defmodule WithoutCeasing.Identity.AccountNotifier do
  import Swoosh.Email

  alias WithoutCeasing.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Will King", "hi@fabledlabs.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(member, url) do
    deliver(member.email, "Confirmation instructions", """

    ==============================

    Hi #{member.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a member password.
  """
  def deliver_reset_password_instructions(member, url) do
    deliver(member.email, "Reset password instructions", """

    ==============================

    Hi #{member.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a member email.
  """
  def deliver_update_email_instructions(member, url) do
    deliver(member.email, "Update email instructions", """

    ==============================

    Hi #{member.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
