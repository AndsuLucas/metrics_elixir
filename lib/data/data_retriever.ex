defmodule METRICS.DataRetriever do
  use HTTPoison.Base

  def process_request_url(url) do
    "https://jsonplaceholder.typicode.com/" <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end
end
