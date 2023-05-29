import gleam/erlang/file
import gleam/erlang/os
import gleam/list
import gleam/map
import gleam/result.{try}
import glenvy/internal/parser

/// Loads a `.env` file.
pub fn load() -> Result(Nil, file.Reason) {
  use env_file <- try(find())

  let env_vars =
    env_file
    |> parser.parse_env_file

  env_vars
  |> map.to_list
  |> list.each(fn(env_var) {
    let #(key, value) = env_var

    os.set_env(key, value)
  })

  Ok(Nil)
}

fn find() -> Result(String, file.Reason) {
  use contents <- try(file.read(".env"))

  Ok(contents)
}
