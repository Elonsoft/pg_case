# PgCase

`ecto` and `postgrex` Elixir extension to work with PostgreSQL `case`
expression.

## Example

  ```elixir
      import Ecto.Query, only: [from: 2]
      import PgCase, only: [pg_case: 1]

      def query do
        from e in Entity,
          select: %{
            value: pg_case do
              e.x < 0 -> "negative"
              e.x > 0 -> "positive"
            else
              "zero"
            end
          }
      end
  ```

## Installation

Docs are [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `pg_case` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pg_case, "~> 0.1.0"}
  ]
end
```

