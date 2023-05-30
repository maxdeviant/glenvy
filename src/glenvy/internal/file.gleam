if erlang {
  import gleam/result
  import gleam/erlang/file

  pub fn read(from path: String) -> Result(String, Nil) {
    file.read(from: path)
    |> result.nil_error
  }
}

if javascript {
  pub external fn read(from: String) -> Result(String, Nil) =
    "../../glenvy_ffi.mjs" "read_file"
}
