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
        {:membrane_core, "~> 0.7.0"},
        {:membrane_file_plugin, "~> 0.6.0"},
        {:membrane_portaudio_plugin, "~> 0.7.0"},
        {:membrane_ffmpeg_swresample_plugin, "~> 0.7.1"},
        {:membrane_mp3_mad_plugin, "~> 0.7.0"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
