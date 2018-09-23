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
        
      }
    )

  }
)
