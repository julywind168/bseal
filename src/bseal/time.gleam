type Unit {
  Second
}

@external(erlang, "erlang", "system_time")
fn system_time(unit: Unit) -> Int

pub fn now() {
  system_time(Second)
}
