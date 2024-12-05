import gleam/dict.{type Dict}

@target(erlang)
@external(erlang, "glenvy_ffi", "get_all_env")
pub fn get_all_env() -> Dict(String, String)

@target(erlang)
@external(erlang, "glenvy_ffi", "get_env")
pub fn get_env(name: String) -> Result(String, Nil)

@target(erlang)
@external(erlang, "glenvy_ffi", "set_env")
pub fn set_env(name: String, value: String) -> Nil

@target(erlang)
@external(erlang, "glenvy_ffi", "unset_env")
pub fn unset_env(name: String) -> Nil

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
