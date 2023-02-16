
defmodule METRICS do

  alias METRICS.Executor, as: Executor
  alias METRICS.FirstRule, as: FirstRule

  def run do
    FirstRule.get_rule_pid
    |> Executor.execute()

    IO.puts "Process finish. You will receive a message when the file was generated."
  end
end
