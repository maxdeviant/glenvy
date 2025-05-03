# glenvy

[![Package Version](https://img.shields.io/hexpm/v/glenvy)](https://hex.pm/packages/glenvy)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glenvy/)
![Erlang-compatible](https://img.shields.io/badge/target-erlang-b83998)
![JavaScript-compatible](https://img.shields.io/badge/target-javascript-f1e05a)

🏞️ A pleasant way to interact with your environment variables.

## Installation

```sh
gleam add glenvy
```

## Usage

```gleam
import gleam/io
import gleam/result.{try}
import glenvy/dotenv
import glenvy/env

pub fn main() {
  let _ = dotenv.load()

  use hello <- try(env.string("HELLO"))

  io.println("HELLO=" <> hello)

  Ok(Nil)
}
```
