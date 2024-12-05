import envoy
import gleam/dict
import gleam/list
import glenvy/env.{FailedToParse, NotFound}
import startest.{describe, it}
import startest/expect
import test_utils.{reset_all_env}

pub fn get_all_tests() {
  describe("glenvy/env", [
    describe("get_all", [
      it("returns all the available environment variables", fn() {
        reset_all_env()

        envoy.set("A_STRING", "hello, world")
        envoy.set("AN_INT", "1")
        envoy.set("A_BOOL", "false")

        env.get_all()
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

          env.get_all()
          |> expect.to_equal(dict.new())
        }),
      ]),
    ]),
  ])
}

pub fn get_string_tests() {
  describe("glenvy/env", [
    describe("get_string", [
      it("returns the environment variable with the specified name", fn() {
        envoy.set("A_STRING", "hello, world")

        env.get_string("A_STRING")
        |> expect.to_be_ok
        |> expect.to_equal("hello, world")
      }),
      describe("when the environment variable does not exist", [
        it("returns a `NotFound` error", fn() {
          env.get_string("DOES_NOT_EXIST")
          |> expect.to_be_error
          |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
        }),
      ]),
    ]),
  ])
}

pub fn get_int_tests() {
  describe("glenvy/env", [
    describe("get_int", [
      describe("when the environment variable has an integer value", [
        it("returns the integer value", fn() {
          envoy.set("AN_INT", "42")

          env.get_int("AN_INT")
          |> expect.to_be_ok
          |> expect.to_equal(42)
        }),
      ]),
      describe("when the environment variable has a string value", [
        it("returns a `FailedToParse` error", fn() {
          envoy.set("AN_INT", "not an int")

          env.get_int("AN_INT")
          |> expect.to_be_error
          |> expect.to_equal(FailedToParse("AN_INT"))
        }),
      ]),
      describe("when the environment variable does not exist", [
        it("returns a `NotFound` error", fn() {
          env.get_int("DOES_NOT_EXIST")
          |> expect.to_be_error
          |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
        }),
      ]),
    ]),
  ])
}

pub fn get_float_tests() {
  describe("glenvy/env", [
    describe("get_float", [
      describe("when the environment variable has a float value", [
        it("returns the float value", fn() {
          envoy.set("A_FLOAT", "37.89")

          env.get_float("A_FLOAT")
          |> expect.to_be_ok
          |> expect.to_equal(37.89)
        }),
      ]),
      describe("when the environment variable has an integer value", [
        it("returns a `FailedToParse` error", fn() {
          envoy.set("A_FLOAT", "29")

          env.get_float("A_FLOAT")
          |> expect.to_be_error
          |> expect.to_equal(FailedToParse("A_FLOAT"))
        }),
      ]),
      describe("when the environment variable has a string value", [
        it("returns a `FailedToparse` error", fn() {
          envoy.set("A_FLOAT", "not a float")

          env.get_float("A_FLOAT")
          |> expect.to_be_error
          |> expect.to_equal(FailedToParse("A_FLOAT"))
        }),
      ]),
      describe("when the environment variable does not exist", [
        it("returns a `NotFound` error", fn() {
          env.get_float("DOES_NOT_EXIST")
          |> expect.to_be_error
          |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
        }),
      ]),
    ]),
  ])
}

pub fn get_bool_tests() {
  let true_values = [
    "True", "true", "TRUE", "t", "T", "Yes", "yes", "YES", "Y", "y", "1",
  ]
  let false_values = [
    "False", "false", "FALSE", "f", "F", "No", "no", "N", "n", "0",
  ]
  let indeterminate_values = ["", "Hi", "HELLO", "-1", "2"]

  describe("glenvy/env", [
    describe("get_bool", [
      describe(
        "with truthy values",
        true_values
          |> list.map(fn(value) {
            it("returns True for \"" <> value <> "\"", fn() {
              envoy.set("A_BOOL", value)

              env.get_bool("A_BOOL")
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
              envoy.set("A_BOOL", value)

              env.get_bool("A_BOOL")
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
              envoy.set("AN_INDETERMINATE_VALUE", value)

              env.get_bool("AN_INDETERMINATE_VALUE")
              |> expect.to_be_error
              |> expect.to_equal(FailedToParse("AN_INDETERMINATE_VALUE"))
            })
          }),
      ),
      describe("when the environment variable does not exist", [
        it("returns a `NotFound` error", fn() {
          env.get_bool("DOES_NOT_EXIST")
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

pub fn get_tests() {
  describe("glenvy/env", [
    describe("get", [
      describe("with a parser returning a custom type", [
        it("returns the custom type", fn() {
          envoy.set("API_KEY", "secret_1234")

          env.get("API_KEY", parser: fn(value) { Ok(ApiKey(value)) })
          |> expect.to_be_ok
          |> expect.to_equal(ApiKey("secret_1234"))
        }),
      ]),
      describe("with a parser returning True", [
        it("returns True", fn() {
          envoy.set("A_BOOL", "any value")

          env.get("A_BOOL", parser: fn(value) { Ok(value == "any value") })
          |> expect.to_be_ok
          |> expect.to_equal(True)
        }),
      ]),
      describe("with a parser returning False", [
        it("returns False", fn() {
          envoy.set("A_BOOL", "another value")

          env.get("A_BOOL", parser: fn(value) { Ok(value == "any value") })
          |> expect.to_be_ok
          |> expect.to_equal(False)
        }),
      ]),
      describe("when the environment variable does not exist", [
        it("returns a `NotFound` error", fn() {
          let always_true = fn(_value) { Ok(True) }

          env.get("DOES_NOT_EXIST", parser: always_true)
          |> expect.to_be_error
          |> expect.to_equal(NotFound("DOES_NOT_EXIST"))
        }),
      ]),
    ]),
  ])
}
