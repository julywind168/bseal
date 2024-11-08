//// generate a 48 bit number uuid
//// nodeid (4 bit): 0 - 15 
//// time (30 bit): 34 years
//// index (14 bit): 0 - 16383

import birl
import gleam/bit_array
import gleam/erlang/process.{type Subject}
import gleam/int
import gleam/otp/actor

const nodeid_bits = 4

const time_bits = 30

const index_bits = 14

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
  Generate(client: Subject(String))
}

pub type UUID48 =
  Subject(Message)

pub fn string(service: UUID48) -> String {
  process.call(service, Generate, 1200)
}

pub fn start(nodeid: Int, epoch: Int) -> Result(UUID48, actor.StartError) {
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
        "uuid48 expected nodeid is 1 .. 15, got " <> int.to_string(nodeid)
      }
  }
}

fn generate(self: Self) -> #(String, Self) {
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

fn uuid(nodeid: Int, time: Int, idx: Int) -> String {
  let assert True = time < max_time()
  let id =
    int.bitwise_shift_left(nodeid, time_bits)
    + int.bitwise_shift_left(time, index_bits)
    + idx
  bit_array.base64_encode(<<id:size(48)>>, True)
}

fn now() {
  birl.now() |> birl.to_unix
}
