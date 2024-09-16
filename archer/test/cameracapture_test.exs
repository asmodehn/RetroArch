
defmodule Archer.CameraCaptureTest do
#  Ref: https://github.com/membraneframework/membrane_camera_capture_plugin/blob/master/test/membrane_media_capture_plugin/camera_capture_plugin_test.exs
  use ExUnit.Case

  import Membrane.ChildrenSpec

  alias Membrane.Testing

  @tag :manual
  @tag :tmp_dir
  test "integration test", %{tmp_dir: tmp_dir} do
    output_path = Path.join(tmp_dir, "output.h264")

    structure =
      child(:source, %Membrane.CameraCapture{device: "/dev/video0"})
      |> child(:converter, %Membrane.FFmpeg.SWScale.PixelFormatConverter{format: :I420})
      |> child(:encoder, Membrane.H264.FFmpeg.Encoder)
      |> child(:sink, %Membrane.File.Sink{location: output_path})

    pipeline = Testing.Pipeline.start_link_supervised!(structure: structure)

    Process.sleep(5000)

    # Check if pipeline is alive
    assert Process.alive?(pipeline)

    Membrane.Pipeline.terminate(pipeline)

    System.cmd("ffplay", [output_path])
  end
end