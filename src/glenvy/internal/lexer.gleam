//// A `.env` file lexer.

import gleam/function
import gleam/set
import nibble/lexer.{Lexer}

pub type Token {
  Equal
  Newline
  Key(String)
  Value(String)
}

fn lexer() -> Lexer(Token, Nil) {
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
    lexer.comment("#", function.constant(Nil))
    |> lexer.ignore,
    lexer.spaces(Nil)
    |> lexer.ignore,
  ])
}

/// Tokenizes the input into a list of `Token`s.
pub fn tokenize(input: String) -> Result(List(lexer.Token(Token)), lexer.Error) {
  lexer.run(input, lexer())
}
