defmodule METRICS.Executor do

  alias  METRICS.TaskGenerator, as: TaskGenerator


  def execute(rule_pid) do

    result =
    TaskGenerator.generate_numbers
    |> Enum.chunk_every(10)
    |> execute_tasks

    send(rule_pid, result)
  end

  defp execute_tasks(numbers, acc \\ [])

  defp execute_tasks([head | []], acc) do
    TaskGenerator.generate_tasks(head)
    |> yield_tasks(acc)
  end

  defp execute_tasks([head | tail], acc) do
    result =
    TaskGenerator.generate_tasks(head)
    |> yield_tasks(acc)
    execute_tasks(tail, result)
  end

  defp yield_tasks(tasks, acc) do
    result =
    Task.yield_many(tasks, 5000)
    |> Enum.map(fn {pid, result} ->
      case result do
        {:ok, content} ->
          content
        _ ->
          Task.shutdown(pid, :brutal_kill)
      end

    end)
    |> Enum.filter(fn v -> not is_nil(v) end)
    IO.puts "PROCESSOS EXECUTADOS"
    acc ++ result
  end
end
