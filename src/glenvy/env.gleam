import gleam/erlang/os
import gleam/float
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
