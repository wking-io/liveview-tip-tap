defmodule WithoutCeasing.Accounts.AccountToken do
  import Ecto.Query
  use Ecto.Schema
  alias __MODULE__

  @hash_algorithm :sha256
  @rand_size 32

  # It is very important to keep the reset password token expiry short,
  # since someone with access to the email may take over the account.
  @reset_password_validity_in_days 1
  @confirm_validity_in_days 7
  @change_email_validity_in_days 7
  @session_validity_in_days 60

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "account_tokens" do
    field :token, :binary
    field :context, :string
    field :sent_to, :string
    belongs_to :account, WithoutCeasing.Accounts.Account

    timestamps(updated_at: false)
  end

  @spec build_session_token(atom | %{:id => any, optional(any) => any}) ::
          {binary,
           %AccountToken{
             __meta__: Schema.Metadata.t(),
             context: <<_::56>>,
             id: nil,
             inserted_at: nil,
             sent_to: nil,
             token: binary,
             account: Ecto.Association.NotLoaded.t(),
             account_id: any
           }}
  @doc """
  Generates a token that will be stored in a signed place,
  such as session or cookie. As they are signed, those
  tokens do not need to be hashed.
  """
  def build_session_token(account) do
    token = :crypto.strong_rand_bytes(@rand_size)
    {token, %AccountToken{token: token, context: "session", account_id: account.id}}
  end

  @doc """
  Checks if the token is valid and returns its underlying lookup query.

  The query returns the account found by the token.
  """
  def verify_session_token_query(token) do
    query =
      from token in token_and_context_query(token, "session"),
        join: account in assoc(token, :account),
        where: token.inserted_at > ago(@session_validity_in_days, "day"),
        select: account

    {:ok, query}
  end

  @doc """
  Returns the given token with the given context.
  """
  def token_and_context_query(token, context) do
    from AccountToken, where: [token: ^token, context: ^context]
  end

  @doc """
  Gets all tokens for the given account for the given contexts.
  """
  def account_and_contexts_query(account, :all) do
    from t in AccountToken, where: t.account_id == ^account.id
  end

  def account_and_contexts_query(account, [_ | _] = contexts) do
    from t in AccountToken, where: t.account_id == ^account.id and t.context in ^contexts
  end
end
