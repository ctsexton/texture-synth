var mementoFactory;
mementoFactory = "memento.scd".loadRelative[0];

(
  create: {
    arg self, director, size;
    var storage;
    
    storage = Array.fill(size, { mementoFactory.create });
    (
      getMemento: {
        arg index;
        storage[index];
      },
      
    )
  }
)
