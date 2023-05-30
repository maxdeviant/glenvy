import gleam/erlang/file
import gleam/erlang/os
import gleam/list
import gleeunit/should
import glenvy/dotenv
import glenvy/error

fn reset_env(keys: List(String)) {
  keys
  |> list.each(os.unset_env(_))
}

pub fn dotenv_nonexistent_file_test() {
  dotenv.load_from(path: "definitely_does_not_exist.env")
  |> should.be_error
  |> should.equal(error.Io(file.Enoent))
}

pub fn dotenv_simple_env_test() {
  reset_env(["KEY", "KEY_2"])

  let assert Ok(Nil) = dotenv.load_from(path: "test/fixtures/simple.env")

  os.get_env("KEY")
  |> should.be_ok
  |> should.equal("1")

  os.get_env("KEY_2")
  |> should.be_ok
  |> should.equal("value")
}

pub fn dotenv_simple_windows_env_test() {
  reset_env(["KEY", "KEY_2"])

  let assert Ok(Nil) =
    dotenv.load_from(path: "test/fixtures/simple_windows.env")

  os.get_env("KEY")
  |> should.be_ok
  |> should.equal("1")

  os.get_env("KEY_2")
  |> should.be_ok
  |> should.equal("value")
}
