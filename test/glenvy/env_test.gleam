import gleam/erlang/os
import gleam/list
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

pub fn env_get_bool_with_true_values_test() {
  let true_values = [
    "True", "true", "TRUE", "t", "T", "Yes", "yes", "YES", "Y", "y", "1",
  ]

  true_values
  |> list.each(fn(value) {
    os.set_env("A_BOOL", value)

    env.get_bool("A_BOOL")
    |> should.be_ok
    |> should.equal(True)
  })
}

pub fn env_get_bool_with_false_values_test() {
  let false_values = [
    "False", "false", "FALSE", "f", "F", "No", "no", "N", "n", "0",
  ]

  false_values
  |> list.each(fn(value) {
    os.set_env("A_BOOL", value)

    env.get_bool("A_BOOL")
    |> should.be_ok
    |> should.equal(False)
  })
}

pub fn env_get_bool_with_indeterminate_values_test() {
  let indeterminate_values = ["", "Hi", "HELLO", "-1", "2"]

  indeterminate_values
  |> list.each(fn(value) {
    os.set_env("AN_INDETERMINATE_VALUE", value)

    env.get_bool("AN_INDETERMINATE_VALUE")
    |> should.be_error
    |> should.equal(Nil)
  })
}

pub fn env_get_bool_with_nonexistent_value_test() {
  env.get_bool("DOES_NOT_EXIST")
  |> should.be_error
  |> should.equal(Nil)
}

pub fn env_get_bool_from_with_parser_returning_true_test() {
  os.set_env("A_BOOL", "any value")

  env.get_bool_from("A_BOOL", parser: fn(value) { Ok(value == "any value") })
  |> should.be_ok
  |> should.equal(True)
}

pub fn env_get_bool_from_with_parser_returning_false_test() {
  os.set_env("A_BOOL", "another value")

  env.get_bool_from("A_BOOL", parser: fn(value) { Ok(value == "any value") })
  |> should.be_ok
  |> should.equal(False)
}

pub fn env_get_bool_from_with_nonexistent_value_test() {
  let always_true = fn(_value) { Ok(True) }

  env.get_bool_from("DOES_NOT_EXIST", parser: always_true)
  |> should.be_error
  |> should.equal(Nil)
}
