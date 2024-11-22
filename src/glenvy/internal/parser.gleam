//// A `.env` file parser.

import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{None, Some}
import gleam/result.{try}
import gleam/string
import glenvy/internal/lexer.{type TokenKind}
import nibble.{type Parser, Break, Continue, do, return}

/// Parses a `.env` file into its contained environment variables.
pub fn parse_env_file(contents: String) -> Dict(String, String) {
  contents
  |> try_parse_env_file
  |> result.unwrap(dict.new())
}

fn try_parse_env_file(contents: String) -> Result(Dict(String, String), Nil) {
  use tokens <- try(
    lexer.tokenize(contents)
    |> result.replace_error(Nil),
  )

  tokens
  |> nibble.run(env_file_parser())
  |> result.replace_error(Nil)
}

fn env_file_parser() -> Parser(Dict(String, String), TokenKind, a) {
  use env_vars <- nibble.loop(dict.new())

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
  env_vars: Dict(String, String),
) -> Parser(Dict(String, String), TokenKind, a) {
  use key <- do(exported_key_parser())
  use _ <- do(nibble.token(lexer.Equal))
  use value <- do(value_parser())
  use _ <- do(nibble.one_of([nibble.token(lexer.Newline), nibble.eof()]))

  env_vars
  |> dict.insert(key, value)
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
  use tokens <- do(nibble.take_until(lexer.is_newline))

  tokens
  |> list.filter_map(fn(token) {
    case token {
      lexer.Value(value) -> Ok(value)
      lexer.Key(value) -> Ok(value)
      // Any `=` after the first are treated as part of the value.
      // This handles the common case of trailing `=` in base64-encoded values.
      lexer.Equal -> Ok("=")
      _ -> Error(Nil)
    }
  })
  |> string.join("")
  |> return
}
