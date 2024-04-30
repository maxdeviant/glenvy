import { Ok, Error } from "./gleam.mjs";

const Nil = undefined;

export function get_env(name) {
  const value = process.env[name];
  if (typeof value === "string") {
    return new Ok(value);
  } else {
    return new Error(Nil);
  }
}

export function set_env(name, value) {
  process.env[name] = value;

  return Nil;
}

export function unset_env(name) {
  delete process.env[name];

  return Nil;
}
