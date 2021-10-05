defmodule WithoutCeasing.Repo do
  use Ecto.Repo,
    otp_app: :without_ceasing,
    adapter: Ecto.Adapters.Postgres
end
