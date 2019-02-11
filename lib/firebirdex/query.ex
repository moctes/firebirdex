defmodule Firebirdex.Query do
  require Record
  Record.defrecord :stmt, Record.extract(:stmt, from_lib: "efirebirdsql/include/efirebirdsql.hrl")

  alias Firebirdex.Result

  @type t :: %__MODULE__{
          ref:  reference() | nil,
          name: iodata(),
          statement: iodata(),
          stmt: tuple()
        }

  defstruct name: "",
            ref: nil,
            stmt: nil,
            statement: nil,
            stmt: nil

  defimpl DBConnection.Query do
    def parse(query, _opts) do
      query
    end

    def describe(query, _opts) do
      query
    end

    def encode(%{stmt: nil} = query, _params, _opts) do
      raise ArgumentError, "query #{inspect(query)} has not been prepared"
    end

    def encode(_query, params, _opts) do
      params
    end

    defp convert(v) do
      v
    end

    defp convert_row(row) do
      row |> Enum.map(fn(x) -> convert(x) end)
    end

    def decode(_query, result, _opts) do
      converted = result.rows |> Enum.map(fn(x) -> convert_row(x) end)
      %Result{result | rows: converted}
    end
  end

  defimpl String.Chars do
    def to_string(%{statement: statement}) do
      IO.iodata_to_binary(statement)
    end
  end
end
