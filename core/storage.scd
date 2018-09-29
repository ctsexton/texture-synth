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
        if (fromIndex.isNumber,
          {(fromIndex * (1 - interpolation) + (toIndex * interpolation))},
          {if (interpolation > 0.5, fromIndex, toIndex)}
        );
      }
    )

  }
)
