//// A `.env` file lexer.

import gleam/function
import gleam/set
import nibble/lexer.{Lexer}

pub type Token {
  Equal
  Newline
  Key(String)
  Value(String)
  Export
}

fn lexer() -> Lexer(Token, Nil) {
  let keywords = set.from_list(["export"])

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
    // Comments.
    lexer.comment("#", function.constant(Nil))
    |> lexer.ignore,
    // Whitespace.
    lexer.spaces(Nil)
    |> lexer.ignore,
  ])
}

/// Tokenizes the input into a list of `Token`s.
pub fn tokenize(input: String) -> Result(List(lexer.Token(Token)), lexer.Error) {
  lexer.run(input, lexer())
}
