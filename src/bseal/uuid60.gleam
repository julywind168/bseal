//// generate a 60 bits number uuid (string length is 10)
//// 
//// nodeid (4 bit): 1 - 15 
//// 
//// time (34 bit): 544 years
//// 
//// index (22 bit): 1 - 4194303 (generates of per second)

import bseal/base64
import gleam/erlang
import gleam/erlang/process.{type Subject}
import gleam/int
import gleam/otp/actor

const timeout = 5000

const nodeid_bits = 4

const time_bits = 34

const index_bits = 22

fn max_nodeid() {
  int.bitwise_shift_left(1, nodeid_bits) - 1
}

fn max_time() {
  int.bitwise_shift_left(1, time_bits) - 1
}

fn max_idx() {
  int.bitwise_shift_left(1, index_bits) - 1
}

type Self {
  Self(nodeid: Int, epoch: Int, time: Int, idx: Int)
}

pub type Message {
  Generate(client: Subject(Int))
}

pub type UUID60 =
  Subject(Message)

pub fn string_with(service: UUID60, encode: fn(Int) -> String) -> String {
  encode(service |> int)
}

pub fn string(service: UUID60) -> String {
  base64.encode(service |> int)
}

pub fn int(service: UUID60) -> Int {
  process.call(service, Generate, timeout)
}

pub fn start(
  nodeid nodeid: Int,
  epoch epoch: Int,
) -> Result(UUID60, actor.StartError) {
  case nodeid >= 1 && nodeid <= max_nodeid() {
    True -> {
      actor.start(
        Self(nodeid:, epoch:, time: now(), idx: 0),
        fn(message: Message, self: Self) -> actor.Next(Message, Self) {
          let Generate(caller) = message
          let #(id, self) = self |> generate
          process.send(caller, id)
          actor.continue(self)
        },
      )
    }
    False ->
      panic as {
        "uuid60 expected nodeid is 1..15, got " <> int.to_string(nodeid)
      }
  }
}

fn generate(self: Self) -> #(Int, Self) {
  let current = now()

  case current > self.time {
    True -> {
      #(
        uuid(self.nodeid, self.time - self.epoch, 1),
        Self(..self, time: current, idx: 1),
      )
    }
    False -> {
      case self.idx > max_idx() {
        True -> {
          process.sleep(100)
          self |> generate
        }
        False -> #(
          uuid(self.nodeid, self.time - self.epoch, self.idx + 1),
          Self(..self, idx: self.idx + 1),
        )
      }
    }
  }
}

fn uuid(nodeid: Int, time: Int, idx: Int) -> Int {
  let assert True = time < max_time()
  int.bitwise_shift_left(nodeid, time_bits + index_bits)
  + int.bitwise_shift_left(time, index_bits)
  + idx
}

fn now() {
  erlang.system_time(erlang.Second)
}
