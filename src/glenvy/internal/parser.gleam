//// A `.env` file parser.

import gleam/function
import gleam/list
import gleam/map.{Map}
import gleam/result.{try}
import gleam/set
import gleam/string
import glenvy/internal/string as glenvy_string
import glx/stringx
import nibble.{Break, Continue, do, return}
import nibble/lexer
import gleam/io
import gleam/option.{None, Some}
import gleam/int
import gleam/float

type Token {
  Equal
  Newline
  Key(String)
  Value(String)
}

fn lexer() {
  let keywords = set.new()

  lexer.simple([
    lexer.token("=", Equal),
    lexer.token("\n", Newline),
    lexer.token("\r\n", Newline),
    // Keys must start with a letter or a `_` and may only contain alphanumeric
    // characters and underscores.
    lexer.identifier("[A-Za-z_]", "[\\w]", keywords, Key),
    lexer.string("\"", Value),
    lexer.string("'", Value),
    lexer.identifier("[^\\s=#\"']", "[.]", keywords, Value),
    // lexer.identifier("[^\\s=#]", "[^\\s]", keywords, Value),
    // lexer.string("", Value),
    lexer.number(
      function.compose(int.to_string, Value),
      function.compose(float.to_string, Value),
    ),
    lexer.comment("#", function.constant(Nil))
    |> lexer.ignore,
    lexer.spaces(Nil)
    |> lexer.ignore,
  ])
}

/// Parses a `.env` file into its contained environment variables.
pub fn parse_env_file(contents: String) -> Map(String, String) {
  contents
  |> try_parse_env_file
  |> result.map_error(fn(error) {
    io.debug(error)
    error
  })
  |> result.unwrap(map.new())
}

fn try_parse_env_file(contents: String) {
  use tokens <- try(
    lexer.run(contents, lexer())
    |> result.map_error(fn(error) {
      io.debug(error)
      error
    })
    |> result.nil_error,
  )

  io.debug(tokens)

  tokens
  |> nibble.run(env_file_parser())
  |> result.map_error(fn(error) {
    io.debug(error)
    error
  })
  |> result.nil_error
}

fn env_file_parser() {
  use env_vars <- nibble.loop(map.new())

  nibble.one_of([
    line_parser(env_vars)
    |> nibble.map(Continue),
    nibble.many1(nibble.token(Newline))
    |> nibble.replace(Continue(env_vars)),
    nibble.eof()
    |> nibble.replace(Break(env_vars)),
  ])
}

/// Parses a single line from a `.env` file.
fn line_parser(env_vars: Map(String, String)) {
  use key <- do(key_parser())
  use _ <- do(nibble.token(Equal))
  use value <- do(value_parser())
  use _ <- do(nibble.one_of([nibble.token(Newline), nibble.eof()]))

  env_vars
  |> map.insert(key, value)
  |> return
}

fn key_parser() {
  use token <- nibble.take_map("KEY")

  case token {
    Key(key) -> Some(key)
    _ -> None
  }
}

fn value_parser() {
  use token <- nibble.take_map("VALUE")

  case token {
    Value(value) | Key(value) -> Some(value)
    _ -> None
  }
}
// /// Parses a single line from a `.env` file into the key and the value.
// fn parse_line(line: String) -> Result(#(String, String), Nil) {
//   use line <- try(skip_line_comment(line))

//   use #(key, value) <- try(
//     line
//     |> string.split_once(on: "="),
//   )

//   use value <- try(strip_comments(value))

//   let value =
//     value
//     |> string.trim
//     |> unquote(quote: "'")
//     |> unquote(quote: "\"")

//   Ok(#(key, value))
// }

// /// Skips a line that starts with a comment.
// fn skip_line_comment(line: String) -> Result(String, Nil) {
//   case
//     line
//     |> string.starts_with("#")
//   {
//     False -> Ok(line)
//     True -> Error(Nil)
//   }
// }

// /// Strips the comments out of the given line.
// fn strip_comments(line: String) -> Result(String, Nil) {
//   case
//     line
//     |> string.split_once(on: "#")
//   {
//     Ok(#(value, _)) -> Ok(value)
//     Error(Nil) -> Ok(line)
//   }
// }

// /// Unquotes the given string using the specified quote character.
// fn unquote(line: String, quote quote_char: String) -> String {
//   line
//   |> glenvy_string.trim_chars_left(quote_char)
//   |> glenvy_string.trim_chars_right(quote_char)
// }
