import gleam/map
import gleeunit/should
import glenvy/internal/parser

pub fn parser_simple_key_value_pair_test() {
  let env_file =
    "
KEY=1
KEY_2=value
    "

  parser.parse_env_file(env_file)
  |> should.equal(map.from_list([#("KEY", "1"), #("KEY_2", "value")]))
}

pub fn parser_comments_test() {
  let env_file =
    "
# This is a comment.
KEY=1
KEY_2=value # This is also a comment.
#KEY_3='3'
    "

  parser.parse_env_file(env_file)
  |> should.equal(map.from_list([#("KEY", "1"), #("KEY_2", "value")]))
}

pub fn parser_quoted_values_test() {
  let env_file =
    "
SINGLE_QUOTE='1'
DOUBLE_QUOTE=\"2\"
    "

  parser.parse_env_file(env_file)
  |> should.equal(
    map.from_list([#("SINGLE_QUOTE", "1"), #("DOUBLE_QUOTE", "2")]),
  )
}

pub fn parser_export_as_key_test() {
  let env_file =
    "
export=\"export as key\"
    "

  parser.parse_env_file(env_file)
  |> should.equal(map.from_list([#("export", "export as key")]))
}

pub fn parser_export_test() {
  let env_file =
    "
export   SHELL_LOVER=1
    "

  parser.parse_env_file(env_file)
  |> should.equal(map.from_list([#("SHELL_LOVER", "1")]))
}

pub fn parser_exported_export_as_key_test() {
  let env_file =
    "
export export='exported export as key'
    "

  parser.parse_env_file(env_file)
  |> should.equal(map.from_list([#("export", "exported export as key")]))
}
