defmodule NpmInstallRun do
  def install(options \\ [pwd: System.get_env("PWD")]) do
    pwd = options[:pwd]
    if check?(pwd) do
      System.cmd("npm", ["install"], cd: pwd)
      |> elem(0)
      |> IO.puts
    end
  end

  def check?(pwd) do
    check_package?(pwd) && check_npm?
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
      _ -> true
    end
  end
end
