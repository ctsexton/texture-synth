{ |trackControllers, masterController|
  var mft, controllerView, masterControllerView, tracksTransmit, masterTransmit;
  mft = MFT();

  tracksTransmit = { |level, x, y, val|
    switch (x,
      0, { switch (level, 0, { trackControllers[y].incrementParameter('position', val) }, 1, { trackControllers[y].incrementParameter('window', val) }, {} ) },
      1, { trackControllers[y].incrementParameter('rate', val) },
      2, { switch (level, 0, { trackControllers[y].incrementParameter('lpfCutoff', val) }, 1, { trackControllers[y].incrementParameter('hpfCutoff', val) }, {} ) },
      3, { trackControllers[y].incrementParameter('volume', val)}
    )
  };
  masterTransmit = { |x, val|
    switch (x, 
      0, { masterController.incrementParameter('reverb', val) },
      1, { masterController.incrementParameter('hpf', val) },
      2, { masterController.incrementParameter('lpf', val) },
      3, { masterController.incrementParameter('volume', val) }
    )
  };

  mft.gridResponderFunction = { |level, x, y, val|
    switch (y, 
      3, { masterTransmit.value(x, val) },
      { tracksTransmit.value(level, x, y, val) }
    );
  };
  mft.onClick = { |x, y, vel|
    switch (vel, 1, {
      switch (y, 3, {}, 
        x.postln;
        { switch (x, 
            1, { trackControllers[y].negateParameter('rate') },
            {}
          )
        }
      )
    }, {})
  };
  mft.onDoubleClick = { |x, y|
    switch (y, 3, {},
      { switch (x, 
        0, { trackControllers[y].resetParameter('position'); trackControllers[y].resetParameter('window') },
        1, { trackControllers[y].resetParameter('rate') },
        2, { trackControllers[y].resetParameter('lpfCutoff'); trackControllers[y].resetParameter('hpfCutoff') },
        3, { trackControllers[y].resetParameter('volume') }
      ) }
    )
  };
  controllerView = { |id|
    (
      receive: { |self, paramName, val|
        switch (paramName,
          'volume', { mft.ledset(0, 3, id, val); mft.ledset(1, 3, id, val) },
          'position', { mft.ledset(0, 0, id, val) },
          'window', { mft.ledset(1, 0, id, val) },
          'rate', { mft.ledset(0, 1, id, val.linlin(-2, 2, 0, 1)) },
          'lpfCutoff', { mft.ledset(0, 2, id, val) },
          'hpfCutoff', { mft.ledset(1, 2, id, val) }
        )
      }
    )
  };
  trackControllers.do({ |track, index|
    track.userInterfaces = track.userInterfaces.value.add(controllerView.value(index));
  });
  masterControllerView = (
    receive: { |self, paramName, val|
      switch (paramName,
        'reverb', { mft.ledset(0, 0, 3, val) },
        'hpf', { mft.ledset(0, 1, 3, val) },
        'lpf', { mft.ledset(0, 2, 3, val) },
        'volume', { mft.ledset(0, 3, 3, val) }
      )
    }
  );
  masterController.userInterfaces = masterController.userInterfaces.value.add(masterControllerView);
}
