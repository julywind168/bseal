import gleam/int
import gleam/list
import gleam/string

const base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#"

const mask = 0b111111

pub fn encode(n: Int) -> String {
  split(n, [])
  |> list.map(fn(i) { string.slice(base64_chars, i, 1) })
  |> list.fold("", string.append)
}

fn split(n: Int, r: List(Int)) {
  case n {
    0 -> r
    _ -> {
      let v = int.bitwise_and(n, mask)
      let n = int.bitwise_shift_right(n, 6)
      split(n, [v, ..r])
    }
  }
}
