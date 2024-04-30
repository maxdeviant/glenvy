//// Support for `.env` files.

import gleam/dict.{type Dict}
import gleam/list
import gleam/result.{try}
import glenvy/internal/os
import glenvy/internal/parser
import simplifile

/// An error that occurred while reading a `.env` file.
pub type Error {
  /// An IO error.
  Io(simplifile.FileError)
}

/// Loads the `.env` file.
pub fn load() -> Result(Nil, Error) {
  load_from(".env")
}

/// Loads the file at the specified path as a `.env` file.
pub fn load_from(path filepath: String) -> Result(Nil, Error) {
  use env_vars <- try(read_from(filepath))

  env_vars
  |> dict.to_list
  |> list.each(fn(env_var) {
    let #(key, value) = env_var

    os.set_env(key, value)
  })

  Ok(Nil)
}

/// Reads the environment variables from the specified `.env` file.
pub fn read_from(path filepath: String) -> Result(Dict(String, String), Error) {
  use env_file <- try(find(filepath))

  let env_vars =
    env_file
    |> parser.parse_env_file

  Ok(env_vars)
}

fn find(filepath: String) -> Result(String, Error) {
  use contents <- try(
    simplifile.read(filepath)
    |> result.map_error(Io),
  )

  Ok(contents)
}
