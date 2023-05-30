import gleam/erlang/os
import gleeunit/should
import glenvy/env

pub fn env_get_test() {
  os.set_env("A_STRING", "hello, world")

  env.get("A_STRING")
  |> should.be_ok
  |> should.equal("hello, world")
}

pub fn env_get_with_nonexistent_value_test() {
  env.get("DOES_NOT_EXIST")
  |> should.be_error
  |> should.equal(Nil)
}

pub fn env_get_int_with_int_value_test() {
  os.set_env("AN_INT", "42")

  env.get_int("AN_INT")
  |> should.be_ok
  |> should.equal(42)
}

pub fn env_get_int_with_string_value_test() {
  os.set_env("AN_INT", "not an int")

  env.get_int("AN_INT")
  |> should.be_error
  |> should.equal(Nil)
}

pub fn env_get_int_with_nonexistent_value_test() {
  env.get_int("DOES_NOT_EXIST")
  |> should.be_error
  |> should.equal(Nil)
}

pub fn env_get_float_with_float_value_test() {
  os.set_env("A_FLOAT", "37.89")

  env.get_float("A_FLOAT")
  |> should.be_ok
  |> should.equal(37.89)
}

pub fn env_get_float_with_int_value_test() {
  os.set_env("A_FLOAT", "29")

  env.get_float("A_FLOAT")
  |> should.be_error
  |> should.equal(Nil)
}

pub fn env_get_float_with_string_value_test() {
  os.set_env("A_FLOAT", "not a float")

  env.get_float("A_FLOAT")
  |> should.be_error
  |> should.equal(Nil)
}

pub fn env_get_float_with_nonexistent_value_test() {
  env.get_float("DOES_NOT_EXIST")
  |> should.be_error
  |> should.equal(Nil)
}
