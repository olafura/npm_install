defmodule NpmInstallTest do
  use ExUnit.Case
  doctest NpmInstall

  import ExUnit.CaptureIO
  import Mock

  test_with_mock "without package.json", System, [:passthrough],
    find_executable: fn _ -> "/usr/bin/npm" end do
    assert capture_io(&NpmInstall.run/0) == "No package.json file\n"
  end

  test_with_mock "without npm", System, [:passthrough], find_executable: fn _ -> nil end do
    assert capture_io(&NpmInstall.run/0) == "No npm installed\n"
  end

  test_with_mock "with custom pwd option", System, [:passthrough],
    find_executable: fn _ -> "/usr/bin/npm" end do
    # Test with a non-existent directory
    assert capture_io(fn -> NpmInstall.run(pwd: "non_existent_dir") end) ==
             "No package.json file\n"
  end

  test_with_mock "with default pwd from config", System, [:passthrough],
    find_executable: fn _ -> "/usr/bin/npm" end do
    # Temporarily set the pwd config
    original_pwd = Application.get_env(:npm_install, :pwd)
    tmp_dir = Path.join([System.tmp_dir(), "test_frontend"])
    Application.put_env(:npm_install, :pwd, tmp_dir)

    # Create test directory and package.json for the test
    File.mkdir_p!(tmp_dir)
    on_exit(fn -> File.rm_rf!(tmp_dir) end)

    # Test with no package.json in the configured directory
    assert capture_io(&NpmInstall.run/0) == "No package.json file\n"

    # Reset the config
    if original_pwd do
      Application.put_env(:npm_install, :pwd, original_pwd)
    else
      Application.delete_env(:npm_install, :pwd)
    end
  end

  test "with package.json in custom pwd" do
    tmp_dir = Path.join([System.tmp_dir(), "test_frontend_with_package"])

    with_mock System, [:passthrough],
      find_executable: fn _ -> "/usr/bin/npm" end,
      cmd: fn "npm", ["install"], [cd: ^tmp_dir] ->
        {"NPM install completed", 0}
      end do
      # Create test directory and package.json for the test
      File.mkdir_p!(tmp_dir)
      File.write!(Path.join([tmp_dir, "package.json"]), "{}")
      on_exit(fn -> File.rm_rf!(tmp_dir) end)

      # Test with package.json in the specified directory
      assert capture_io(fn -> NpmInstall.run(pwd: tmp_dir) end) ==
               "NPM install completed\n"
    end
  end

  test_with_mock "with system PWD environment variable", System, [:passthrough],
    find_executable: fn _ -> "/usr/bin/npm" end,
    get_env: fn "PWD" -> "/mock/system/pwd" end,
    cmd: fn "npm", ["install"], [cd: "/mock/system/pwd"] -> {"Using system PWD", 0} end do
    # Ensure no config is set
    original_pwd = Application.get_env(:npm_install, :pwd)
    Application.delete_env(:npm_install, :pwd)

    # Mock File.exists? to return true for our mock path
    with_mock File, [:passthrough],
      exists?: fn path ->
        path == Path.join("/mock/system/pwd", "package.json")
      end do
      assert capture_io(&NpmInstall.run/0) == "Using system PWD\n"
    end

    # Reset the config
    if original_pwd do
      Application.put_env(:npm_install, :pwd, original_pwd)
    end
  end
end
