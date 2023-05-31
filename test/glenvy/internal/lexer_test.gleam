import gleeunit/should
import glenvy/internal/lexer.{Equal, Export, Key, Newline, Value}
import nibble/lexer.{Span, Token} as niblex
import gleam/string

pub fn lexer_tokenize_simple_key_value_pair_test() {
  let env_file =
    "
KEY=1
KEY_2=value
    "
    |> string.trim_left

  lexer.tokenize(env_file)
  |> should.be_ok
  |> should.equal([
    Token(Span(1, 1, 1, 4), "KEY", Key("KEY")),
    Token(Span(1, 4, 1, 5), "=", Equal),
    Token(Span(1, 5, 1, 6), "1", Value("1")),
    Token(Span(1, 6, 2, 1), "\n", Newline),
    Token(Span(2, 1, 2, 6), "KEY_2", Key("KEY_2")),
    Token(Span(2, 6, 2, 7), "=", Equal),
    Token(Span(2, 7, 2, 12), "value", Key("value")),
    Token(Span(2, 12, 3, 1), "\n", Newline),
  ])
}

pub fn lexer_tokenize_comments_test() {
  let env_file =
    "
# This is a comment.
KEY=1
KEY_2=value # This is also a comment.
#KEY_3='3'
    "
    |> string.trim_left

  lexer.tokenize(env_file)
  |> should.be_ok
  |> should.equal([
    Token(Span(1, 21, 2, 1), "\n", Newline),
    Token(Span(2, 1, 2, 4), "KEY", Key("KEY")),
    Token(Span(2, 4, 2, 5), "=", Equal),
    Token(Span(2, 5, 2, 6), "1", Value("1")),
    Token(Span(2, 6, 3, 1), "\n", Newline),
    Token(Span(3, 1, 3, 6), "KEY_2", Key("KEY_2")),
    Token(Span(3, 6, 3, 7), "=", Equal),
    Token(Span(3, 7, 3, 12), "value", Key("value")),
    Token(Span(3, 38, 4, 1), "\n", Newline),
    Token(Span(4, 11, 5, 1), "\n", Newline),
  ])
}

pub fn lexer_tokenize_quoted_values_test() {
  let env_file =
    "
SINGLE_QUOTE='1'
DOUBLE_QUOTE=\"2\"
    "
    |> string.trim_left

  lexer.tokenize(env_file)
  |> should.be_ok
  |> should.equal([
    Token(Span(1, 1, 1, 13), "SINGLE_QUOTE", Key("SINGLE_QUOTE")),
    Token(Span(1, 13, 1, 14), "=", Equal),
    Token(Span(1, 14, 1, 17), "'1'", Value("1")),
    Token(Span(1, 17, 2, 1), "\n", Newline),
    Token(Span(2, 1, 2, 13), "DOUBLE_QUOTE", Key("DOUBLE_QUOTE")),
    Token(Span(2, 13, 2, 14), "=", Equal),
    Token(Span(2, 14, 2, 17), "\"2\"", Value("2")),
    Token(Span(2, 17, 3, 1), "\n", Newline),
  ])
}

pub fn lexer_tokenize_export_as_key_test() {
  let env_file =
    "
export=\"export as key\"
    "
    |> string.trim_left

  lexer.tokenize(env_file)
  |> should.be_ok
  |> should.equal([
    Token(Span(1, 1, 1, 7), "export", Export),
    Token(Span(1, 7, 1, 8), "=", Equal),
    Token(Span(1, 8, 1, 23), "\"export as key\"", Value("export as key")),
    Token(Span(1, 23, 2, 1), "\n", Newline),
  ])
}

pub fn lexer_tokenize_export_test() {
  let env_file =
    "
export   SHELL_LOVER=1
    "
    |> string.trim_left

  lexer.tokenize(env_file)
  |> should.be_ok
  |> should.equal([
    Token(Span(1, 1, 1, 7), "export", Export),
    Token(Span(1, 10, 1, 21), "SHELL_LOVER", Key("SHELL_LOVER")),
    Token(Span(1, 21, 1, 22), "=", Equal),
    Token(Span(1, 22, 1, 23), "1", Value("1")),
    Token(Span(1, 23, 2, 1), "\n", Newline),
  ])
}

pub fn lexer_tokenize_exported_export_as_key_test() {
  let env_file =
    "
export export='exported export as key'
    "
    |> string.trim_left

  lexer.tokenize(env_file)
  |> should.be_ok
  |> should.equal([
    Token(Span(1, 1, 1, 7), "export", Export),
    Token(Span(1, 8, 1, 14), "export", Export),
    Token(Span(1, 14, 1, 15), "=", Equal),
    Token(
      Span(1, 15, 1, 39),
      "'exported export as key'",
      Value("exported export as key"),
    ),
    Token(Span(1, 39, 2, 1), "\n", Newline),
  ])
}
