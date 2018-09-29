var interpolateValues, interpolateMementos;
interpolateValues = {
  arg fromValue, toValue, interpolation;
  fromValue.isNumber.postln;
  fromValue.postln;
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
    var storage;
    
    storage = Array.newClear(size);

    (
      save: {
        arg self, index;
        var currentSettings;
        currentSettings = director.getAllSettings();
        storage.put(index, currentSettings);
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
      interpolate: {
        arg self, fromIndex, toIndex, interpolation;
        var result;
        result = interpolateMementos.value(storage[fromIndex], storage[toIndex], interpolation);
        director.restoreSettings(result);
        true;
      }
    )

  }
)
