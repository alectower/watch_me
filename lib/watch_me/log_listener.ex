defmodule WatchMe.LogListener do
  alias WatchMe.LogEater

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    IO.inspect "init listener"

    listen_for_requests()

    server = Socket.UDP.open!(Application.get_env(:watch_me, :listener)[:port])

    {:ok, server}
  end

  def listen_for_requests() do
    Process.send_after(self(), :handle_request, 100)
  end

  def handle_info(:handle_request, state) do
    {data, _} = state |> Socket.Datagram.recv!

    Task.start_link(fn ->
      LogEater.eat(data)
    end)

    listen_for_requests()

    {:noreply, state}
  end
end
