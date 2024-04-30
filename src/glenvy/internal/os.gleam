import gleam/dict.{type Dict}
@target(erlang)
import gleam/erlang/os

@target(erlang)
pub fn get_all_env() -> Dict(String, String) {
  os.get_all_env()
}

@target(erlang)
pub fn get_env(name: String) -> Result(String, Nil) {
  os.get_env(name)
}

@target(erlang)
pub fn set_env(name: String, value: String) -> Nil {
  os.set_env(name, value)
}

@target(erlang)
pub fn unset_env(name: String) -> Nil {
  os.unset_env(name)
}

@target(javascript)
pub fn get_all_env() -> Dict(String, String) {
  do_get_all_env()
  |> dict.from_list
}

@target(javascript)
@external(javascript, "../../glenvy_ffi.mjs", "get_all_env")
fn do_get_all_env() -> List(#(String, String))

@target(javascript)
@external(javascript, "../../glenvy_ffi.mjs", "get_env")
pub fn get_env(name: String) -> Result(String, Nil)

@target(javascript)
@external(javascript, "../../glenvy_ffi.mjs", "set_env")
pub fn set_env(name: String, value: String) -> Nil

@target(javascript)
@external(javascript, "../../glenvy_ffi.mjs", "unset_env")
pub fn unset_env(name: String) -> Nil
