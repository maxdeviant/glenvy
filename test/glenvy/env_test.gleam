import gleam/dict
import gleam/list
import glenvy/env.{FailedToParse, NotFound}
import glenvy/internal/os
import startest.{describe, it}
import startest/expect
import test_utils.{reset_all_env}

pub fn all_tests() {
  describe("glenvy/env", [
    describe("all", [
      it("returns all the available environment variables", fn() {
        reset_all_env()

        os.set_env("A_STRING", "hello, world")
        os.set_env("AN_INT", "1")
        os.set_env("A_BOOL", "false")

        env.all()
        |> expect.to_equal(
          [
            #("A_STRING", "hello, world"),
            #("AN_INT", "1"),
            #("A_BOOL", "false"),
          ]
          |> dict.from_list,
        )
      }),
      describe("when no environment variables are set", [
        it("returns an empty `Dict`", fn() {
          reset_all_env()

          env.all()
          |> expect.to_equal(dict.new())
        }),
      ]),
    ]),
  ])
}

pub fn string_tests() {
  describe("glenvy/env", [
    describe("string", [
      it("returns the environment variable with the specified name", fn() {
        os.set_env("A_STRING", "hello, world")

        env.string("A_STRING")
        |> expect.to_be_ok
        |> expect.to_equal("hello, world")
      }),
      describe("when the environment variable does not exist", [
        it("returns a `NotFound` error", fn() {
          env.string("DOES_NOT_EXIST")
          |> expect.to_be_error
          |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
        }),
      ]),
    ]),
  ])
}

pub fn int_tests() {
  describe("glenvy/env", [
    describe("int", [
      describe("when the environment variable has an integer value", [
        it("returns the integer value", fn() {
          os.set_env("AN_INT", "42")

          env.int("AN_INT")
          |> expect.to_be_ok
          |> expect.to_equal(42)
        }),
      ]),
      describe("when the environment variable has a string value", [
        it("returns a `FailedToParse` error", fn() {
          os.set_env("AN_INT", "not an int")

          env.int("AN_INT")
          |> expect.to_be_error
          |> expect.to_equal(FailedToParse("AN_INT"))
        }),
      ]),
      describe("when the environment variable does not exist", [
        it("returns a `NotFound` error", fn() {
          env.int("DOES_NOT_EXIST")
          |> expect.to_be_error
          |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
        }),
      ]),
    ]),
  ])
}

pub fn float_tests() {
  describe("glenvy/env", [
    describe("float", [
      describe("when the environment variable has a float value", [
        it("returns the float value", fn() {
          os.set_env("A_FLOAT", "37.89")

          env.float("A_FLOAT")
          |> expect.to_be_ok
          |> expect.to_equal(37.89)
        }),
      ]),
      describe("when the environment variable has an integer value", [
        it("returns a `FailedToParse` error", fn() {
          os.set_env("A_FLOAT", "29")

          env.float("A_FLOAT")
          |> expect.to_be_error
          |> expect.to_equal(FailedToParse("A_FLOAT"))
        }),
      ]),
      describe("when the environment variable has a string value", [
        it("returns a `FailedToparse` error", fn() {
          os.set_env("A_FLOAT", "not a float")

          env.float("A_FLOAT")
          |> expect.to_be_error
          |> expect.to_equal(FailedToParse("A_FLOAT"))
        }),
      ]),
      describe("when the environment variable does not exist", [
        it("returns a `NotFound` error", fn() {
          env.float("DOES_NOT_EXIST")
          |> expect.to_be_error
          |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
        }),
      ]),
    ]),
  ])
}

pub fn bool_tests() {
  let true_values = [
    "True", "true", "TRUE", "t", "T", "Yes", "yes", "YES", "Y", "y", "1",
  ]
  let false_values = [
    "False", "false", "FALSE", "f", "F", "No", "no", "N", "n", "0",
  ]
  let indeterminate_values = ["", "Hi", "HELLO", "-1", "2"]

  describe("glenvy/env", [
    describe("bool", [
      describe(
        "with truthy values",
        true_values
          |> list.map(fn(value) {
            it("returns True for \"" <> value <> "\"", fn() {
              os.set_env("A_BOOL", value)

              env.bool("A_BOOL")
              |> expect.to_be_ok
              |> expect.to_equal(True)
            })
          }),
      ),
      describe(
        "with falsy values",
        false_values
          |> list.map(fn(value) {
            it("returns False for \"" <> value <> "\"", fn() {
              os.set_env("A_BOOL", value)

              env.bool("A_BOOL")
              |> expect.to_be_ok
              |> expect.to_equal(False)
            })
          }),
      ),
      describe(
        "with indeterminate values",
        indeterminate_values
          |> list.map(fn(value) {
            it("returns a `FailedToParse` error for \"" <> value <> "\"", fn() {
              os.set_env("AN_INDETERMINATE_VALUE", value)

              env.bool("AN_INDETERMINATE_VALUE")
              |> expect.to_be_error
              |> expect.to_equal(FailedToParse("AN_INDETERMINATE_VALUE"))
            })
          }),
      ),
      describe("when the environment variable does not exist", [
        it("returns a `NotFound` error", fn() {
          env.bool("DOES_NOT_EXIST")
          |> expect.to_be_error
          |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
        }),
      ]),
    ]),
  ])
}

type ApiKey {
  ApiKey(String)
}

pub fn parse_tests() {
  describe("glenvy/env", [
    describe("parse", [
      describe("with a parser returning a custom type", [
        it("returns the custom type", fn() {
          os.set_env("API_KEY", "secret_1234")

          env.parse("API_KEY", parser: fn(value) { Ok(ApiKey(value)) })
          |> expect.to_be_ok
          |> expect.to_equal(ApiKey("secret_1234"))
        }),
      ]),
      describe("with a parser returning True", [
        it("returns True", fn() {
          os.set_env("A_BOOL", "any value")

          env.parse("A_BOOL", parser: fn(value) { Ok(value == "any value") })
          |> expect.to_be_ok
          |> expect.to_equal(True)
        }),
      ]),
      describe("with a parser returning False", [
        it("returns False", fn() {
          os.set_env("A_BOOL", "another value")

          env.parse("A_BOOL", parser: fn(value) { Ok(value == "any value") })
          |> expect.to_be_ok
          |> expect.to_equal(False)
        }),
      ]),
      describe("when the environment variable does not exist", [
        it("returns a `NotFound` error", fn() {
          let always_true = fn(_value) { Ok(True) }

          env.parse("DOES_NOT_EXIST", parser: always_true)
          |> expect.to_be_error
          |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
        }),
      ]),
    ]),
  ])
}
