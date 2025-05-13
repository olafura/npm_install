defmodule NpmInstall do
  @moduledoc """
  You only have to add to your deps for it to
  do npm install for you.

  ## Optional config
  ```elixir
  import Config

  config :npm_install,
    on_build: false, # If you set it to false then it won't install on build
    pwd: "frontend" # If the package.json file is in a different place, like in phoenix
  ```
  """
  import NpmInstallRun

  Application.compile_env(:npm_install, :on_build, true) && install()

  @doc """
  Optional command to run npm install after
  compiling it.
  """
  def run() do
    install()
  end

  @doc """
  Optional command to run npm install after
  compiling it with options.

  Current options are:

  pwd - where the package.json and node_modules
  should be
  """
  def run(options) do
    install(options)
  end
end
