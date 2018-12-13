{ |trackControllers|
  var launchpad = Launchpad();
  var shift = false;
  var topRowTransmit = { |location, vel|
    switch (location,
      0, { shift = vel.asBoolean; launchpad.ledset('top', 0, ['green', 'red'][vel]) }
    )
  };
  var grid = Grid(8, 8);
  var gridTransmit = { |location, vel|
    var index, result;
    index = grid.gridToMidi(location[0], location[1]);
    result = switch (shift,
      true, { trackControllers.do({ |track| track.saveSettings(index) }); },
      false, { trackControllers.do({ |track| track.restoreSettings(index) }); }
    );
  };

  launchpad.gridResponderFunction = { |section, location, vel|
    switch (section,
      'top', { topRowTransmit.value(location, vel) },
      'grid', { switch (vel, 1, { gridTransmit.value(location, vel) }, {}) }
    )
  }
}
