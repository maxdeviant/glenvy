import gleeunit/should
import glenvy/internal/string

pub fn string_trim_chars_left_test() {
  ""
  |> string.trim_chars_left(trim: "")
  |> should.equal("")

  "foobar"
  |> string.trim_chars_left(trim: "foo")
  |> should.equal("bar")

  "foobar"
  |> string.trim_chars_left(trim: "bar")
  |> should.equal("foobar")
}

pub fn string_trim_chars_right_test() {
  ""
  |> string.trim_chars_right(trim: "")
  |> should.equal("")

  "foobar"
  |> string.trim_chars_right(trim: "foo")
  |> should.equal("foobar")

  "foobar"
  |> string.trim_chars_right(trim: "bar")
  |> should.equal("foo")
}
