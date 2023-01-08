defmodule Archer.MixProject do
  use Mix.Project

  def project do
    [
      app: :archer,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
        {:membrane_core, "~> 0.11.0"},
        {:membrane_camera_capture_plugin, "~> 0.4.0"},
      {:membrane_h264_ffmpeg_plugin, "~> 0.21"},
      {:membrane_file_plugin, "~> 0.10"},
      {:membrane_ffmpeg_swscale_plugin, "~> 0.10"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
