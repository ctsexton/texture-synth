var translatorMaker, midi_to_grid, grid_to_midi, rangeFactory, levelOneParams, levelTwoParams, clickParams, addressesA, addressesB, addressesC, addressFactory, timerFactory;
translatorMaker = "translator.scd".loadRelative[0];
rangeFactory = "encToRange.scd".loadRelative[0];
addressFactory = "../core/address.scd".loadRelative[0];
timerFactory = "timergate.scd".loadRelative[0];

midi_to_grid = translatorMaker.newMIDItoGRID(4, False);
grid_to_midi = translatorMaker.newGRIDtoMIDI(4);
levelOneParams = [\position, \rate, \lpfCutoff, \volume];
levelTwoParams = [\window, \rate, \hpfCutoff, \volume];
clickParams = [\posWin, \rate, \cutoff, \volume];
addressesA = [[],[],[],[]];
addressesB = [[],[],[],[]];
addressesC = [[],[],[],[]];

for (0, 3, { |trk|
	for (0, 3, { |prm|
		var newAddressA, newAddressB, newAddressC;

		newAddressA = addressFactory.create(trk, levelOneParams[prm]);
		newAddressB = addressFactory.create(trk, levelTwoParams[prm]);
    newAddressC = addressFactory.create(trk, clickParams[prm]);

		addressesA[trk] = addressesA[trk].add(newAddressA);
		addressesB[trk] = addressesB[trk].add(newAddressB);
		addressesC[trk] = addressesC[trk].add(newAddressC);
	})
});


(
  create: {
    arg self, director, storage;
    var mft, mftActionLevelOne, mftActionLevelTwo, port, connection, rateDoubleClick, reverseTimers, resetTimers, rateReset;

    mftActionLevelOne = {
      arg knobInput;
      var noteNumber, address;
      address = addressesA[knobInput[1]][knobInput[0]];
      director.accumParameter(address, knobInput[2]);
    };
    mftActionLevelTwo = {
      arg knobInput;
      var noteNumber, address;
      address = addressesB[knobInput[1]][knobInput[0]];
      director.accumParameter(address, knobInput[2]);
    };
    
    reverseTimers = Array.fill(3, {timerFactory.create(1)});
    rateDoubleClick = {
      arg track;
      switch (reverseTimers[track].getStatus, 
        false, {reverseTimers[track].open},
        true, {director.reverseParameter(addressesC[track][1]); reverseTimers[track].close},
        {}
      )
    };
    resetTimers = Array.fill(3, {timerFactory.create(1)});
    rateReset = {
      arg track, trigger;
      switch (trigger,
        true, { resetTimers[track].open() },
        false, {
          resetTimers[track].fireIfClosed({director.resetParameter(addressesC[track][1])})
        }
      )
    };

    port = MIDIIn.findPort("Midi Fighter Twister", "Midi Fighter Twister MIDI 1");
    connection = MIDIIn.connect(0, port);

    MIDIdef.new(\mft_in, {
      |velocity, noteNumber, channel|
      var gridMsg;
      gridMsg = midi_to_grid.value(noteNumber, velocity);
      switch (channel,
        0, { mftActionLevelOne.value(gridMsg) },
        4, { mftActionLevelTwo.value(gridMsg) },
        {}
      );
    }, msgNum: (0..11), msgType: \control, srcID: port.uid);

    MIDIdef.new(\rate_buttons, {
      |velocity, noteNumber, channel|
      var gridMsg, track;
      gridMsg = midi_to_grid.value(noteNumber, velocity);
      track = gridMsg[1];
      if (velocity > 0, { rateDoubleClick.value(track) });
      rateReset.value(track, (velocity > 0));
    }, chan: 1, msgNum: [1,5,9], msgType: \control, srcID: port.uid);

    MIDIdef.new(\master_ctrls, {
      |noteNumber, velocity, channel|
      var gridMsg = midi_to_grid.value(velocity, noteNumber);
      storage.accumInterpolationTime(gridMsg[2]);
    }, msgNum: 12, msgType: \control, srcID: port.uid);

    (
      director: director,
      connection: connection,
      receiveParameter: {
        arg self, address, value;
      }
    )
  }
)
