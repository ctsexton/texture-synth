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
        director.restoreSettings(storage[index]);
      }
    )

  }
)
