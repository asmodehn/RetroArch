defmodule Archer do
  @moduledoc """
  Documentation for `Archer`.
  """

  use Membrane.Pipeline

  @impl true
  def handle_init(_ctx, _options) do
    structure =
      child(:source, %Membrane.CameraCapture{device: "/dev/video0"})
      |> child(:converter, %Membrane.FFmpeg.SWScale.PixelFormatConverter{format: :I420})
      |> child(:encoder, Membrane.H264.FFmpeg.Encoder)
      |> child(:sink, %Membrane.File.Sink{location: "output.h264"})

    {[spec: structure], %{}}
  end

  @doc """
  Hello world.

  ## Examples

      iex> Archer.hello()
      :world

  """
  def hello do
    :world
  end
end
