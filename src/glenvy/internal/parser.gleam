//// A `.env` file parser.

import gleam/map.{Map}
import gleam/option.{None, Some}
import gleam/result.{try}
import glenvy/internal/lexer.{Token}
import nibble.{Break, Continue, Parser, do, return}

/// Parses a `.env` file into its contained environment variables.
pub fn parse_env_file(contents: String) -> Map(String, String) {
  contents
  |> try_parse_env_file
  |> result.unwrap(map.new())
}

fn try_parse_env_file(contents: String) -> Result(Map(String, String), Nil) {
  use tokens <- try(
    lexer.tokenize(contents)
    |> result.nil_error,
  )

  tokens
  |> nibble.run(env_file_parser())
  |> result.nil_error
}

fn env_file_parser() -> Parser(Map(String, String), Token, a) {
  use env_vars <- nibble.loop(map.new())

  nibble.one_of([
    line_parser(env_vars)
    |> nibble.map(Continue),
    nibble.many1(nibble.token(lexer.Newline))
    |> nibble.replace(Continue(env_vars)),
    nibble.eof()
    |> nibble.replace(Break(env_vars)),
  ])
}

/// Parses a single line from a `.env` file.
fn line_parser(
  env_vars: Map(String, String),
) -> Parser(Map(String, String), Token, a) {
  use key <- do(key_parser())
  use _ <- do(nibble.token(lexer.Equal))
  use value <- do(value_parser())
  use _ <- do(nibble.one_of([nibble.token(lexer.Newline), nibble.eof()]))

  env_vars
  |> map.insert(key, value)
  |> return
}

fn key_parser() -> Parser(String, Token, a) {
  use token <- nibble.take_map("KEY")

  case token {
    lexer.Key(key) -> Some(key)
    // `export` can be used as a key.
    lexer.Export -> Some("export")
    _ -> None
  }
}

fn value_parser() -> Parser(String, Token, a) {
  use token <- nibble.take_map("VALUE")

  case token {
    lexer.Value(value) -> Some(value)
    lexer.Key(value) -> Some(value)
    _ -> None
  }
}
