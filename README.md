# glenvy

[![Package Version](https://img.shields.io/hexpm/v/glenvy)](https://hex.pm/packages/glenvy)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glenvy/)

🏞️ A pleasant way to interact with your environment.

## Installation

```sh
gleam add glenvy --dev
```

## Usage

```gleam
import gleam/erlang/os
import gleam/io
import gleam/result.{try}
import glenvy/dotenv

pub fn main() {
  let _ = dotenv.load()

  use hello <- try(os.get_env("HELLO"))

  io.println("HELLO=" <> hello)

  Ok(Nil)
}
```
