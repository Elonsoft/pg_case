defmodule PgCase.Repo do
  use Ecto.Repo,
    otp_app: :pg_case,
    adapter: Ecto.Adapters.Postgres
end
