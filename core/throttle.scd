(
  create: {
    arg self, time;
    var status, gate;
    locked = false;
    gate = Routine.new({
      locked = true;
      time.wait;
      locked = false;
    });
    (
      fire: {
        arg self, function;
        switch (locked, 
          false, {function.value(); gate.reset.play}
        )
      }
    )
  }
)
