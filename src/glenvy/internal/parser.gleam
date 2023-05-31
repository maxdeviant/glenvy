//// A `.env` file parser.

import gleam/map.{Map}
import gleam/option.{None, Some}
import gleam/result.{try}
import glenvy/internal/lexer.{TokenKind}
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

fn env_file_parser() -> Parser(Map(String, String), TokenKind, a) {
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
) -> Parser(Map(String, String), TokenKind, a) {
  use key <- do(exported_key_parser())
  use _ <- do(nibble.token(lexer.Equal))
  use value <- do(value_parser())
  use _ <- do(nibble.one_of([nibble.token(lexer.Newline), nibble.eof()]))

  env_vars
  |> map.insert(key, value)
  |> return
}

/// Parses a key that is optionally preceeded by an `export`.
///
/// ```sh
/// export KEY=value
/// ^^^^^^^^^^
/// ```
fn exported_key_parser() {
  use export <- do(nibble.optional(nibble.token(lexer.Export)))

  case export {
    Some(_) ->
      // If we found an `export` then ignore it and try to parse a key.
      key_parser()
      // If we don't find a key, use `export` as the key.
      |> nibble.or("export")

    // If we didn't find an `export` then try to parse the key as usual.
    None -> key_parser()
  }
}

/// Parses a key.
///
/// ```sh
/// KEY=value
/// ^^^
/// ```
fn key_parser() -> Parser(String, TokenKind, a) {
  use token <- nibble.take_map("KEY")

  case token {
    lexer.Key(key) -> Some(key)
    // `export` can be used as a key.
    lexer.Export -> Some("export")
    _ -> None
  }
}

/// Parses a value.
///
/// ```sh
/// KEY=value
///     ^^^^^
/// ```
fn value_parser() -> Parser(String, TokenKind, a) {
  use token <- nibble.take_map("VALUE")

  case token {
    lexer.Value(value) -> Some(value)
    lexer.Key(value) -> Some(value)
    _ -> None
  }
}
