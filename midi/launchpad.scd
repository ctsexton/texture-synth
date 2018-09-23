var translatorMaker, midi_to_grid, grid_to_midi, rangeFactory;
translatorMaker = "translator.scd".loadRelative[0];
rangeFactory = "encToRange.scd".loadRelative[0];

midi_to_grid = translatorMaker.newMIDItoGRID(16);
grid_to_midi = translatorMaker.newGRIDtoMIDI(8);
(
  create: {
    arg self, storage;
    var port, onPush, output, toLP, shift, previousNote, selectToSave, selectToRecall, outputLogic;
    
    port = MIDIIn.findPort("Launchpad Mini", "Launchpad Mini MIDI 1");
    MIDIIn.connect(0, port);

    output = MIDIOut.newByName("Launchpad Mini", "Launchpad Mini MIDI 1");
    output.latency = 0;

    shift = false;
    previousNote = 127;

    toLP = {
      arg noteNum, velocity;
      output.noteOn(0, noteNum, velocity);
    };

    selectToSave = {
      arg index, noteNum;
      storage.save(index);
      toLP.value(previousNote, 127);
      toLP.value(noteNum, 3); 
      previousNote = noteNum;
    };
    selectToRecall = {
      arg index, noteNum;
      if (storage.restore(index),
        { toLP.value(previousNote, 127); toLP.value(noteNum, 48); previousNote = noteNum }
      )
    };

    outputLogic = {
      arg index, noteNum;
      switch (shift)
        {true} {selectToSave.value(index, noteNum)}
        {false} {selectToRecall.value(index, noteNum)};
    };

    MIDIdef.new(\shift, {
      |velocity, ccNumber, channel, uid|
      shift = velocity != 0;
    }, 104, msgType: \control, srcID: port.uid);

    onPush = {
      MIDIdef.noteOn(\launchpad_in, {
        |velocity, noteNumber, channel|
        var gridMsg, index;
        gridMsg = midi_to_grid.value(noteNumber, velocity);
        index = grid_to_midi.value(gridMsg[0], gridMsg[1]);
        outputLogic.value(index, noteNumber);
        
      }, nil, nil, srcID: port.uid)
    };

    onPush.value();
  }
)
