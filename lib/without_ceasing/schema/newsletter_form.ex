defmodule WithoutCeasing.NewsletterForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :email, :string
  end

  @doc false
  def changeset(form, attrs) do
    form
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> validate_email()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end
end
