# NpmInstall

You only have to add to your deps for it to do npm install for you.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add npm_install to your list of dependencies in `mix.exs`:

        def deps do
          [{:npm_install, "~> 0.0.1", only: :dev}]
        end

## Optional config

```elixir
import Config

config :npm_install,
  on_build: false, # If you set it to false then it won't install on build
  pwd: "frontend" # If the package.json file is in a different place, like in phoenix
```
