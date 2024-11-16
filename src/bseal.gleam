import bseal/uuid48
import gleam/bit_array
import gleam/io

pub fn main() {
  io.println("Hello from bseal!")
  let assert Ok(uuid) = uuid48.start(nodeid: 0, epoch: 1_704_038_400)
  io.debug(uuid |> uuid48.int())
  io.debug(uuid |> uuid48.string())
  io.debug(uuid |> uuid48.string_with(bit_array.base64_encode(_, False)))
}
