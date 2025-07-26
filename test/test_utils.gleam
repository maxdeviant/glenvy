import gleam/dict
import gleam/list
import glenvy/internal/os

pub fn reset_all_env() {
  os.get_all_env()
  |> dict.keys()
  |> reset_env
}

pub fn reset_env(keys: List(String)) {
  keys
  |> list.each(os.unset_env)
}
