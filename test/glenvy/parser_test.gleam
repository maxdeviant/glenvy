import gleam/map
import gleeunit/should
import glenvy/parser

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
