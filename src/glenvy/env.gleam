//// Strongly-typed access to environment variables.

import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/result.{try}
import gleam/string
import glenvy/internal/os

/// An error that occurred while reading an environment variable.
pub type Error {
  /// The environment variable with the given name was not found.
  NotFound(name: String)
  /// The environment variable with the given name failed to parse.
  FailedToParse(name: String)
}

/// Returns all of the available environment variables for the current process.
pub fn get_all() -> Dict(String, String) {
  os.get_all_env()
}

/// Returns the value for the environment variable with the given name as a `String`.
pub fn get_string(name: String) -> Result(String, Error) {
  os.get_env(name)
  |> result.map_error(fn(_) { NotFound(name) })
}

/// Returns the value for the environment variable with the given name.
///
/// Uses the provided `parser` to parse the value.
///
/// Returns `Error(FailedToParse)` if the provided `parser` returns an error.
pub fn get(
  name: String,
  parser parse: fn(String) -> Result(a, err),
) -> Result(a, Error) {
  use value <- try(get_string(name))

  value
  |> parse
  |> result.map_error(fn(_) { FailedToParse(name) })
}

/// Returns the value for the environment variable with the given name as an `Int`.
///
/// Returns `Error(FailedToParse)` if the environment variable cannot be parsed as an `Int`.
pub fn get_int(name: String) -> Result(Int, Error) {
  name
  |> get(parser: int.parse)
}

/// Returns the value for the environment variable with the given name as a `Float`.
///
/// Returns `Error(FailedToParse)` if the environment variable cannot be parsed as a `Float`.
pub fn get_float(name: String) -> Result(Float, Error) {
  name
  |> get(parser: float.parse)
}

/// Returns the value for the environment variable with the given name as a `Bool`.
///
/// The following values are parsed as `True`:
/// - `true`
/// - `t`
/// - `yes`
/// - `y`
/// - `1`
///
/// The following values are parsed as `False`:
/// - `false`
/// - `f`
/// - `no`
/// - `n`
/// - `0`
///
/// The parsing is case-insensitive.
///
/// Returns `Error(FailedToParse)` if the environment variable cannot be parsed as a `Bool`.
///
/// Use `get` if you want to provide your own parser.
pub fn get_bool(name: String) -> Result(Bool, Error) {
  let parse_bool = fn(value) {
    let value =
      value
      |> string.lowercase

    case value {
      "true" | "t" | "yes" | "y" | "1" -> Ok(True)
      "false" | "f" | "no" | "n" | "0" -> Ok(False)
      _ -> Error(Nil)
    }
  }

  name
  |> get(parser: parse_bool)
}
