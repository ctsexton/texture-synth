var interpolateValues, interpolateMementos, cubicWarp, transition, interpolationTime, parameter, previousRoutine, userInterfaces;
parameter = "parameter.scd".loadRelative[0];
previousRoutine = Routine({});

userInterfaces = Array.new(4);

interpolationTime = parameter.create('interpolationTime', 0, 0, 5, 0.05);

cubicWarp = {
	arg input;
	var output;
	output = case 
	{ input < 0.5 } {input**3 * 4}
	{ 0.5 * ((2 * input - 2)**3) + 1 };
	output;
};

interpolateValues = {
  arg fromValue, toValue, interpolation;
  if (fromValue.isNumber,
    {(fromValue * (1 - interpolation) + (toValue * interpolation))},
    {if (interpolation < 0.5, fromValue, toValue)}
  );
};

interpolateMementos = {
  arg fromMem, toMem, interpolation;
  fromMem.collect({
    arg track, trackIndex;
    track.collect({|item, i| interpolateValues.value(item, toMem[trackIndex][i], interpolation)})
  });
};

(
  create: {
    arg self, director, size;
    var storage, verify;
    
    storage = Array.newClear(size);
    verify = {
      arg index;
      var memory = storage[index];
      if (memory != nil, { [true, memory] }, { [false, nil] });
    };

    (
      save: {
        arg self, index;
        storage.put(index, director.getAllSettings());
      },
      restore: {
        arg self, index;
        var memory;
        memory = storage[index];
        if (memory == nil,
          { false },
          {director.restoreSettings(memory); true };
        )
      },
      verify: {
        arg self, index;
        verify.value(index);
      },
      interpolate: {
        arg self, fromIndex, toIndex, interpolation;
        var result;
        result = interpolateMementos.value(storage[fromIndex], storage[toIndex], interpolation);
        director.restoreSettings(result);
        true;
      },
      transition: {
        arg self, from, to;
        var steps = interpolationTime.getValue() / 0.05;
        if (steps < 1, 
          {self.restore(to)}, 
          {
            previousRoutine.stop;
            previousRoutine = Routine({
              steps.do({
                |i|
                self.interpolate(from, to, cubicWarp.value(i / steps + (1 / steps)));
                0.05.wait;
              })
            }).play;
          });
      },
      transitionTo: {
        arg self, to;
        var result;
        result = verify.value(to);
        if (result[0] == true, 
          {
            self.save(0);
            self.transition(0, to);
            true;
          }, 
          { false }
        );
      },
      setInterpolationTime: {
        arg self, newDuration;
        interpolationTime.change(newDuration);
        self.updateAllGUIs();
      },
      accumInterpolationTime: {
        arg self, accum;

        interpolationTime.accum(accum);
        self.updateAllGUIs();
      },
      registerUI: {
        |self, ui|
        userInterfaces.add(ui);
      },
      updateAllGUIs: {
        userInterfaces.do({
          |ui|
          ui.receiveInterpolationTime(interpolationTime.getValue());
        })
      },
      saveToDisk: {
        var store = (data: storage);
        Archive.global.put(\textureSynthPresets, store);
        Archive.write();
      },
      restoreFromDisk: {
        var store;
        store = Archive.global.at(\textureSynthPresets);
        storage = store.data;
      }
    )
  }
)
