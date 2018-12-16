{ |trackControllers|
  var launchpad = Launchpad();
  var active;
  var previous = [0, 0];
  var shift = false;
  var topRowTransmit = { |location, vel|
    switch (location,
      0, { shift = vel.asBoolean; launchpad.ledset('top', 0, ['green', 'red'][vel]) }
    )
  };
  var grid = Grid(8, 8);

  var updateGridLEDs = { |color|
    launchpad.ledset('grid', previous[0], previous[1], 'yellow');
    launchpad.ledset('grid', active[0], active[1], color);
  };

  var gridTransmit = { |location, vel|
    var index, result;
    index = grid.gridToMidi(location[0], location[1]);
    result = switch (shift,
      true, { 
        trackControllers.do({ |track| track.saveSettings(index) });
        active = location;
        updateGridLEDs.value('red');
        previous = location;
      },
      false, { 
        trackControllers.do({ |track| track.restoreSettings(index) });
        active = location;
        updateGridLEDs.value('green');
        previous = location;
      }
    );
  };

  launchpad.clear;
  launchpad.ledset('top', 0, 'green');
  launchpad.gridResponderFunction = { |section, location, vel|
    switch (section,
      'top', { topRowTransmit.value(location, vel) },
      'grid', { switch (vel, 1, { gridTransmit.value(location, vel) }, {}) }
    )
  }
}
