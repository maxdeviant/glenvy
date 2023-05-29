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
