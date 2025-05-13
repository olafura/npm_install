defmodule NpmInstallRun do
  def install(options \\ []) do
    pwd = Keyword.get(options, :pwd, pwd())

    if check?(pwd) do
      System.cmd("npm", ["install"], cd: pwd)
      |> elem(0)
      |> IO.puts()
    end
  end

  def check?(pwd) do
    check_npm?() && check_package?(pwd)
  end

  def check_package?(pwd) do
    if File.exists?(Path.join(pwd, "package.json")) do
      true
    else
      IO.puts("No package.json file")
      false
    end
  end

  def check_npm? do
    case System.find_executable("npm") do
      nil ->
        IO.puts("No npm installed")
        false

      _ ->
        true
    end
  end

  defp pwd do
    Application.get_env(:npm_install, :pwd, System.get_env("PWD"))
  end
end
