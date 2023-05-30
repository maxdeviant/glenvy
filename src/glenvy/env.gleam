//// Strongly-typed access to environment variables.

import gleam/erlang/os
import gleam/float
import gleam/string
import gleam/int
import gleam/result.{try}

/// Returns the value for the environment variable with the given name.
pub fn get(name: String) -> Result(String, Nil) {
  os.get_env(name)
}

/// Returns the value for the environment variable with the given name as an `Int`.
///
/// Returns `Error(Nil)` if the environment variable cannot be parsed as an `Int`.
pub fn get_int(name: String) -> Result(Int, Nil) {
  use value <- try(get(name))

  value
  |> int.parse
}

/// Returns the value for the environment variable with the given name as a `Float`.
///
/// Returns `Error(Nil)` if the environment variable cannot be parsed as a `Float`.
pub fn get_float(name: String) -> Result(Float, Nil) {
  use value <- try(get(name))

  value
  |> float.parse
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
/// The following values are pased as `False`:
/// - `false`
/// - `f`
/// - `no`
/// - `n`
/// - `0`
///
/// The parsing is case-insensitive.
///
/// Returns `Error(Nil)` if the environment variable cannot be parsed as a `Bool`.
///
/// See `get_bool_from` if you want to use your own parser.
pub fn get_bool(name: String) -> Result(Bool, Nil) {
  name
  |> get_bool_from(parser: fn(value) {
    let value =
      value
      |> string.lowercase

    case value {
      "true" | "t" | "yes" | "y" | "1" -> Ok(True)
      "false" | "f" | "no" | "n" | "0" -> Ok(False)
      _ -> Error(Nil)
    }
  })
}

/// Returns the value for the environment variable with the given name as a `Bool`.
///
/// Uses the provided `parser` to parse the `Bool`.
///
/// Returns `Error(Nil)` if the provided `parser` returns `Error(Nil)`.
pub fn get_bool_from(
  name: String,
  parser parse: fn(String) -> Result(Bool, Nil),
) {
  use value <- try(get(name))

  value
  |> parse
}
