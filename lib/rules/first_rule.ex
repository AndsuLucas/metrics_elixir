defmodule METRICS.FirstRule do
  alias Poison

  def get_rule_pid do
    spawn(fn -> execute_rule() end)
  end

  defp execute_rule do
    receive do
      result ->
        handle_result(result)
    end
  end


  defp handle_result(result) do
    json_content =
    result
    |> Enum.map(fn {store, response} ->
      response |> parse_result(store)
    end)

    File.write("#{File.cwd!}/metric_files/metric.json", Poison.encode!(json_content), [:binary])
  end

  #impl
  defp parse_result(%{content: _ , status: :error}, store) do
    %{store_with_error: store}
  end

  defp parse_result(response, store) do
    Map.new([{store, Map.get(response.content, "body")}])
  end

end
