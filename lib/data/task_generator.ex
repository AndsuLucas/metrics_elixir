defmodule METRICS.TaskGenerator do
  alias METRICS.DataRetriever, as: DataRetriever

  alias METRICS.Response, as: Response

  def generate_tasks(stores) do
    for n <- stores do
      Task.async(fn ->
        IO.puts "Process for: #{n}"
        DataRetriever.start()
        DataRetriever.get("posts/#{n}")
        |> parse_response(n)
      end)
    end
  end

  def parse_response({:error, _}, store_id), do: {:error, "error for store_id: #{store_id}"}

  def parse_response({:ok, api_response}, store_id) do
    status = if api_response.status_code == 200, do: :ok, else: :error

    response = struct(Response, [content: api_response.body, status: status])

    {store_id, response}
  end

  def generate_numbers do
    for n <- 1..110 do
      n
    end
  end

end
