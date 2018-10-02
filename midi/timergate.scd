(
  create: {
    arg self, time;
    var status, gate;
    status = false;
    gate = Routine.new({
      status = true;
      time.wait;
      status = false;
    });
    (
      open: {
        arg self;
        gate.reset.play;
      },
      close: {
        arg self;
        gate.stop;
        status = false;
      },
      getStatus: {
        status;
      },
      throttle: {
        arg self, function;
        switch (status, 
          false, {function.value(); gate.reset.play}
        )
      },
      fireIfOpen: {
        arg self, function;
        switch (status,
          true, {function.value(); gate.stop}
        )
      },
      fireIfClosed: {
        arg self, function;
        switch (status,
          false, {function.value()}
        )
      }
    )
  }
)
