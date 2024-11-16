# bseal

[![Package Version](https://img.shields.io/hexpm/v/bseal)](https://hex.pm/packages/bseal)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/bseal/)

bseal (Bamboo Seal) is number uuid generators, include (48 bits, 54 bits, 60 bits) for Gleam.

after base64 encode the string length is short.

uuid48: string length is 8

uuid54: string length is 9

uuid60: string length is 10

```sh
gleam add bseal
```
```gleam
import bseal/uuid48

pub fn main() {
  let assert Ok(uuid) = uuid48.start(nodeid: 1, epoch: 1_704_038_400) // epoch: 2024-01-01
  io.debug(uuid |> uuid48.int()) // output: 453607800833
  io.debug(uuid |> uuid48.string()) // output: "AGmdPkAC"
}
```

Further documentation can be found at <https://hexdocs.pm/bseal>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
