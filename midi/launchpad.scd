var translatorMaker, midi_to_grid, grid_to_midi, rangeFactory;
translatorMaker = "translator.scd".loadRelative[0];
rangeFactory = "encToRange.scd".loadRelative[0];

midi_to_grid = translatorMaker.newMIDItoGRID(16);
grid_to_midi = translatorMaker.newGRIDtoMIDI(16);
(
  create: {
    arg self, director;
    var port, connection, onPush;
    
    port = MIDIIn.findPort("Launchpad Mini", "Launchpad Mini MIDI 1");
    connection = MIDIIn.connect(0, port);

    onPush = {
      arg self;
      MIDIdef.new(\launchpad_in, {
        |noteNumber, velocity, channel|
        var gridMsg;
        gridMsg = midi_to_grid.value(velocity, noteNumber);
        gridMsg.postln;
      }, msgType: \noteOn, srcID: port.uid)
    };

    onPush.value();
  }
)
