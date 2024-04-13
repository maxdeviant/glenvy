@target(erlang)
import gleam/result
@target(erlang)
import gleam/string
@target(erlang)
import simplifile

@target(erlang)
pub fn read(from path: String) -> Result(String, String) {
  simplifile.read(from: path)
  |> result.map_error(string.inspect)
}

@target(javascript)
@external(javascript, "../../glenvy_ffi.mjs", "read_file")
pub fn read(from: String) -> Result(String, String)
