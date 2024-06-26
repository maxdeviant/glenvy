//// A `.env` file lexer.

import gleam/set
import nibble/lexer.{type Lexer, type Token}

pub type TokenKind {
  Equal

  /// A system-agnostic newline.
  ///
  /// Could be a LF or a CRLF.
  Newline

  // Literals.
  Key(String)
  Value(String)

  // Keywords.
  Export
}

fn lexer() -> Lexer(TokenKind, Nil) {
  let keywords = set.from_list(["export"])

  let comments =
    lexer.comment("#", fn(_) { Nil })
    |> lexer.ignore

  let whitespace =
    lexer.spaces(Nil)
    |> lexer.ignore

  lexer.simple([
    lexer.token("=", Equal),
    // Newlines.
    lexer.token("\n", Newline),
    lexer.token("\r\n", Newline),
    // Shell `export`.
    lexer.keyword("export", "[\\W\\D]", Export),
    // Keys must start with a letter or a `_` and may only contain alphanumeric
    // characters and underscores.
    lexer.identifier("[A-Za-z_]", "[\\w]", keywords, Key),
    // Values.
    lexer.string("\"", Value),
    lexer.string("'", Value),
    lexer.identifier("[^\\s=#\"']", "[.]", keywords, Value),
    comments,
    whitespace,
  ])
}

/// Tokenizes the input into a list of `Token`s.
pub fn tokenize(input: String) -> Result(List(Token(TokenKind)), lexer.Error) {
  lexer.run(input, lexer())
}

/// Returns whether the given token is a newline.
pub fn is_newline(token: TokenKind) -> Bool {
  token == Newline
}
