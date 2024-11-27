import bseal/internal/base64
import bseal/uuid48
import gleam/io

pub fn main() {
  io.println("Hello from bseal!")
  let assert Ok(uuid) = uuid48.start(nodeid: 1, epoch: 1_704_038_400)
  io.debug(uuid |> uuid48.int())
  io.debug(uuid |> uuid48.string())
  io.debug(uuid |> uuid48.string_with(base64.encode))
}
