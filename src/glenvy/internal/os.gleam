@target(erlang)
import gleam/erlang/os

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
@external(javascript, "../../glenvy_ffi.mjs", "get_env")
pub fn get_env(name: String) -> Result(String, Nil)

@target(javascript)
@external(javascript, "../../glenvy_ffi.mjs", "set_env")
pub fn set_env(name: String, value: String) -> Nil

@target(javascript)
@external(javascript, "../../glenvy_ffi.mjs", "unset_env")
pub fn unset_env(name: String) -> Nil
