use Mix.Config

config :pg_case, ecto_repos: [PgCase.Repo]

config :pg_case, PgCase.Repo,
  username: "postgres",
  password: "postgres",
  database: "pg_case_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
