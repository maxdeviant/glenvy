import gleam/list
import gleam/map.{Map}
import gleam/string

/// Parses a `.env` file into its contained environment variables.
pub fn parse_env_file(contents: String) -> Map(String, String) {
  let lines = lines(contents)

  let env_vars =
    lines
    |> list.filter_map(parse_line)
    |> map.from_list

  env_vars
}

/// Parses a single line from a `.env` file into the key and the value.
fn parse_line(line: String) -> Result(#(String, String), Nil) {
  line
  |> string.split_once(on: "=")
}

/// Returns the lines contained in the given string.
fn lines(value: String) -> List(String) {
  value
  |> string.split(on: "\n")
}
