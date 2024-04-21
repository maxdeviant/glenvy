import gleam/list
import glenvy/env.{FailedToParse, NotFound}
import glenvy/internal/os
import startest/expect

pub fn env_get_string_test() {
  os.set_env("A_STRING", "hello, world")

  env.get_string("A_STRING")
  |> expect.to_be_ok
  |> expect.to_equal("hello, world")
}

pub fn env_get_string_with_nonexistent_value_test() {
  env.get_string("DOES_NOT_EXIST")
  |> expect.to_be_error
  |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
}

pub fn env_get_int_with_int_value_test() {
  os.set_env("AN_INT", "42")

  env.get_int("AN_INT")
  |> expect.to_be_ok
  |> expect.to_equal(42)
}

pub fn env_get_int_with_string_value_test() {
  os.set_env("AN_INT", "not an int")

  env.get_int("AN_INT")
  |> expect.to_be_error
  |> expect.to_equal(FailedToParse("AN_INT"))
}

pub fn env_get_int_with_nonexistent_value_test() {
  env.get_int("DOES_NOT_EXIST")
  |> expect.to_be_error
  |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
}

pub fn env_get_float_with_float_value_test() {
  os.set_env("A_FLOAT", "37.89")

  env.get_float("A_FLOAT")
  |> expect.to_be_ok
  |> expect.to_equal(37.89)
}

pub fn env_get_float_with_int_value_test() {
  os.set_env("A_FLOAT", "29")

  env.get_float("A_FLOAT")
  |> expect.to_be_error
  |> expect.to_equal(FailedToParse("A_FLOAT"))
}

pub fn env_get_float_with_string_value_test() {
  os.set_env("A_FLOAT", "not a float")

  env.get_float("A_FLOAT")
  |> expect.to_be_error
  |> expect.to_equal(FailedToParse("A_FLOAT"))
}

pub fn env_get_float_with_nonexistent_value_test() {
  env.get_float("DOES_NOT_EXIST")
  |> expect.to_be_error
  |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
}

pub fn env_get_bool_with_true_values_test() {
  let true_values = [
    "True", "true", "TRUE", "t", "T", "Yes", "yes", "YES", "Y", "y", "1",
  ]

  true_values
  |> list.each(fn(value) {
    os.set_env("A_BOOL", value)

    env.get_bool("A_BOOL")
    |> expect.to_be_ok
    |> expect.to_equal(True)
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
    |> expect.to_be_ok
    |> expect.to_equal(False)
  })
}

pub fn env_get_bool_with_indeterminate_values_test() {
  let indeterminate_values = ["", "Hi", "HELLO", "-1", "2"]

  indeterminate_values
  |> list.each(fn(value) {
    os.set_env("AN_INDETERMINATE_VALUE", value)

    env.get_bool("AN_INDETERMINATE_VALUE")
    |> expect.to_be_error
    |> expect.to_equal(FailedToParse("AN_INDETERMINATE_VALUE"))
  })
}

pub fn env_get_bool_with_nonexistent_value_test() {
  env.get_bool("DOES_NOT_EXIST")
  |> expect.to_be_error
  |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
}

type ApiKey {
  ApiKey(String)
}

pub fn env_get_with_parser_returning_custom_type_test() {
  os.set_env("API_KEY", "secret_1234")

  env.get("API_KEY", parser: fn(value) { Ok(ApiKey(value)) })
  |> expect.to_be_ok
  |> expect.to_equal(ApiKey("secret_1234"))
}

pub fn env_get_with_parser_returning_true_test() {
  os.set_env("A_BOOL", "any value")

  env.get("A_BOOL", parser: fn(value) { Ok(value == "any value") })
  |> expect.to_be_ok
  |> expect.to_equal(True)
}

pub fn env_get_with_parser_returning_false_test() {
  os.set_env("A_BOOL", "another value")

  env.get("A_BOOL", parser: fn(value) { Ok(value == "any value") })
  |> expect.to_be_ok
  |> expect.to_equal(False)
}

pub fn env_get_with_nonexistent_value_test() {
  let always_true = fn(_value) { Ok(True) }

  env.get("DOES_NOT_EXIST", parser: always_true)
  |> expect.to_be_error
  |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
}
