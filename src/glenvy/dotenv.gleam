//// Support for `.env` files.

import gleam/dict
import gleam/list
import gleam/result.{try}
import glenvy/internal/file
import glenvy/internal/os
import glenvy/internal/parser

/// An error that occurred while reading a `.env` file.
pub type Error {
  /// An IO error.
  Io(message: String)
}

/// Loads the `.env` file.
pub fn load() -> Result(Nil, Error) {
  load_from(".env")
}

/// Loads the file at the specified path as a `.env` file.
pub fn load_from(path filepath: String) -> Result(Nil, Error) {
  use env_file <- try(find(filepath))

  let env_vars =
    env_file
    |> parser.parse_env_file

  env_vars
  |> dict.to_list
  |> list.each(fn(env_var) {
    let #(key, value) = env_var

    os.set_env(key, value)
  })

  Ok(Nil)
}

fn find(filepath: String) -> Result(String, Error) {
  use contents <- try(
    file.read(filepath)
    |> result.map_error(Io),
  )

  Ok(contents)
}
