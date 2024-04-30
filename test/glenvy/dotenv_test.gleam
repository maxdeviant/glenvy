import gleam/list
import glenvy/dotenv
import glenvy/internal/os
import simplifile
import startest/expect

fn reset_env(keys: List(String)) {
  keys
  |> list.each(os.unset_env(_))
}

pub fn dotenv_nonexistent_file_test() {
  dotenv.load_from(path: "definitely_does_not_exist.env")
  |> expect.to_be_error
  |> expect.to_equal(dotenv.Io(simplifile.Enoent))
}

pub fn dotenv_simple_env_test() {
  reset_env(["KEY", "KEY_2"])

  let assert Ok(Nil) = dotenv.load_from(path: "test/fixtures/simple.env")

  os.get_env("KEY")
  |> expect.to_be_ok
  |> expect.to_equal("1")

  os.get_env("KEY_2")
  |> expect.to_be_ok
  |> expect.to_equal("value")
}

pub fn dotenv_simple_windows_env_test() {
  reset_env(["KEY", "KEY_2"])

  let assert Ok(Nil) =
    dotenv.load_from(path: "test/fixtures/simple_windows.env")

  os.get_env("KEY")
  |> expect.to_be_ok
  |> expect.to_equal("1")

  os.get_env("KEY_2")
  |> expect.to_be_ok
  |> expect.to_equal("value")
}

pub fn dotenv_equals_in_value_env_test() {
  reset_env(["KEY", "TRAILING_EQ", "STARTING_EQ", "KEY_2"])

  let assert Ok(Nil) =
    dotenv.load_from(path: "test/fixtures/equals_in_value.env")

  os.get_env("KEY")
  |> expect.to_be_ok
  |> expect.to_equal("1")

  os.get_env("TRAILING_EQ")
  |> expect.to_be_ok
  |> expect.to_equal("YmFkIHZhbHVlIQ==")

  os.get_env("STARTING_EQ")
  |> expect.to_be_ok
  |> expect.to_equal("=foobar")

  os.get_env("KEY_2")
  |> expect.to_be_ok
  |> expect.to_equal("2")
}
