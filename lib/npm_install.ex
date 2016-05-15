defmodule NpmInstall do
  @moduledoc """
  You only have to add to your deps for it to
  do npm install for you.
  """
  import NpmInstallRun
  install()

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
