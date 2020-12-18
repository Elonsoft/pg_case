defmodule PgCase do
  @moduledoc """
  Helper macros to work with PostgreSQL `case` expression.

  ## Example

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
  """

  @doc """
  Adapts PostgreSQL `case` expression to elixir syntax.

  The following construction

      pg_case do
        some_cond -> some_expr
        some_other_cond -> some_other_expr
      else
        otherwise_expr
      end

  is equivalent to

      CASE WHEN some_cond THEN some_expr
           WHEN some_other_cond THEN some_other_expr
      ELSE otherwise_expr
      END

  PostgreSQL expression.

  Note that else-clause may be omitted. Then it works exactly like
  `case` from PostgreSQL which returns `null` when none of
  when-clauses matched.
  """
  defmacro pg_case(body) do
    conditions = body[:do]
    else_clause = body[:else]

    quote do
      fragment(
        unquote(
          "CASE " <>
            build_case_when_string(conditions) <>
            build_case_else_string(else_clause) <>
            "END"
        ),
        unquote_splicing(
          build_case_when_args(conditions) ++ build_case_else_args(else_clause)
        )
      )
    end
  end

  defp build_case_when_string(conditions) do
    Enum.reduce(conditions, "", fn {:->, _, _}, acc ->
      acc <> "WHEN ? THEN ? "
    end)
  end

  defp build_case_else_string(nil), do: ""
  defp build_case_else_string(_), do: "ELSE ? "

  defp build_case_when_args(conditions) do
    Enum.flat_map(conditions, fn {:->, _, [[c], v]} -> [c, v] end)
  end

  defp build_case_else_args(nil), do: []
  defp build_case_else_args(else_clause), do: [else_clause]

  @doc """
  Syntax sugar in case your use-case for `case` expression is simple
  if-else construction.

      pg_if some_cond do
        some_expr
      else
        otherwise_expr
      end

  The code above is equivalent to following PosgreSQL expression:

      CASE WHEN some_cond THEN some_expr
      ELSE otherwise_expr
      END

  Note that else-clause may be omitted.
  """
  defmacro pg_if(condition, body) do
    do_clause =
      body[:do] ||
        raise SyntaxError,
          description: "do-clause is required",
          line: __CALLER__.line,
          file: __CALLER__.file

    else_clause = body[:else]

    fragment_string =
      "CASE WHEN ? THEN ? " <> build_if_else_string(else_clause) <> "END"

    quote do
      fragment(
        unquote(fragment_string),
        unquote(condition),
        unquote_splicing([do_clause] ++ build_if_else_args(else_clause))
      )
    end
  end

  defp build_if_else_string(nil), do: ""
  defp build_if_else_string(_), do: "ELSE ? "

  defp build_if_else_args(nil), do: []
  defp build_if_else_args(else_clause), do: [else_clause]
end
