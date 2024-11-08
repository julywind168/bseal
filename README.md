# bseal

[![Package Version](https://img.shields.io/hexpm/v/bseal)](https://hex.pm/packages/bseal)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/bseal/)

bseal (Bamboo Seal) is number uuid generators, include (48 bits, 54 bits, 60 bits)

when base64 encode the string length is short:

uuid48: string length is 8

uuid54: string length is 9

uuid60: string length is 10

```sh
gleam add bseal
```
```gleam
import bseal/uuid48

pub fn main() {
  // 1_704_038_400 2024-01-01 00:00:00
  let uuid = uuid48.start(1, 1_704_038_400)
  io.debug(uuid.string()) // out: "abcd1234"
}
```

Further documentation can be found at <https://hexdocs.pm/bseal>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
