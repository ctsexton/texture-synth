var translatorMaker, midi_to_grid, grid_to_midi, index_to_grid, rangeFactory, colorPalette, grid_to_LP;
translatorMaker = "translator.scd".loadRelative[0];
rangeFactory = "encToRange.scd".loadRelative[0];

midi_to_grid = translatorMaker.newMIDItoGRID(16);
index_to_grid = translatorMaker.newMIDItoGRID(8);
grid_to_midi = translatorMaker.newGRIDtoMIDI(8);
grid_to_LP = translatorMaker.newGRIDtoMIDI(16);

colorPalette = (yellow: 127, red: 3, green: 48, off: 0);

(
  create: {
    arg self, storage, director;
    var port, onPush, output, toLP, toLPTop, shift, previousNote, selectToSave, selectToRecall, switch, clearLP;
    
    port = MIDIIn.findPort("Launchpad Mini", "Launchpad Mini MIDI 1");
    MIDIIn.connect(0, port);

    output = MIDIOut.newByName("Launchpad Mini", "Launchpad Mini MIDI 1");
    output.latency = 0;

    shift = false;
    previousNote = 127;

    toLP = {
      arg noteNum, color;
      output.noteOn(0, noteNum, colorPalette[color]);
    };

    toLPTop = {
      arg position, color;
      output.control(0, position + 104, colorPalette[color]);
    };

    clearLP = {
      127.do({|i| output.noteOff(0, i, 0)});
    };

    selectToSave = {
      arg index, noteNum;
      storage.save(index);
      toLP.value(previousNote, \yellow);
      toLP.value(noteNum, \red); 
      previousNote = noteNum;
    };
    selectToRecall = {
      arg index, noteNum;
      if (storage.transitionTo(index),
        { toLP.value(previousNote, \yellow); toLP.value(noteNum, \green); previousNote = noteNum }
      )
    };

    switch = {
      arg index, noteNum;
      switch (shift)
        {true} {selectToSave.value(index, noteNum)}
        {false} {selectToRecall.value(index, noteNum)};
    };

    MIDIdef.new(\shift, {
      |velocity, ccNumber, channel, uid|
      var color;
      shift = velocity != 0;
      color = switch (shift, false, {\green}, true, {\red});
      toLPTop.value(0, color);
    }, 104, msgType: \control, srcID: port.uid);

    toLPTop.value(0, \green);

    MIDIdef.new(\track_enable, {
      |velocity, ccNumber, channel, uid|
      var track, status, color;
      if (velocity > 0, {
        track = ccNumber - 109;
        status = director.toggleTrack(track);
        color = switch (status, true, {\green}, false, {\off});
        toLPTop.value(track + 5, color);
      })
    }, (109..111), msgType: \control, srcID: port.uid);

    3.do({|i| toLPTop.value(i + 5, \green)});

    MIDIdef.noteOn(\launchpad_in, {
      |velocity, noteNumber, channel|
      var gridMsg, index;
      gridMsg = midi_to_grid.value(noteNumber, velocity);
      index = grid_to_midi.value(gridMsg[0], gridMsg[1]) + 1;
      switch.value(index, noteNumber);
    }, nil, nil, srcID: port.uid);

    clearLP.value();
    (
      restore: {
        64.do({
          arg i;
          var index = i;
          if (storage.verify(index + 1)[0] == true, {
            var xy = index_to_grid.value(index, 127);
            var noteNum = grid_to_LP.value(xy[0], xy[1]);
            xy.postln;
            noteNum.postln;
            toLP.value(noteNum, \yellow);
          })
        })
      }
    )
  }
)
