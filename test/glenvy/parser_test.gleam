import gleam/map
import gleeunit/should
import glenvy/parser

pub fn parser_kitchen_sink_test() {
  let env_file =
    "
HELLO=WORLD
    "

  parser.parse_env_file(env_file)
  |> should.equal(map.from_list([#("HELLO", "WORLD")]))
}
