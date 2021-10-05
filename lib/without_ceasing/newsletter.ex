defmodule WithoutCeasing.Newsletter do
  alias WithoutCeasing.NewsletterForm
  alias WithoutCeasing.ConvertKitClient
  alias Ecto.Changeset

  @doc """
  Signs user up for newsletter.

  ## Examples

      iex> subscribe(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def subscribe(attrs) do
    changeset = NewsletterForm.changeset(%NewsletterForm{}, attrs)

    if changeset.valid? do
      result =
        changeset
        |> Changeset.fetch_field!(:email)
        |> ConvertKitClient.add_subscriber(2_479_690)

      case result do
        {:ok, body} -> {:ok, body}
        {:error, _body, _status} -> {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking test changes.

  ## Examples

      iex> change_test(test)
      %Ecto.Changeset{data: %Test{}}

  """
  def change(attrs \\ %{}) do
    NewsletterForm.changeset(%NewsletterForm{}, attrs)
  end
end
