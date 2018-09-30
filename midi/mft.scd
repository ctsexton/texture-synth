var translatorMaker, midi_to_grid, grid_to_midi, rangeFactory, levelOneParams, levelTwoParams, addressesA, addressesB, addressFactory;
translatorMaker = "translator.scd".loadRelative[0];
rangeFactory = "encToRange.scd".loadRelative[0];
addressFactory = "../core/address.scd".loadRelative[0];

midi_to_grid = translatorMaker.newMIDItoGRID(4, False);
grid_to_midi = translatorMaker.newGRIDtoMIDI(4);
levelOneParams = [\position, \rate, \lpfCutoff, \volume];
levelTwoParams = [\window, \rate, \hpfCutoff, \volume];
addressesA = [[],[],[],[]];
addressesB = [[],[],[],[]];

for (0, 3, { |trk|
	for (0, 3, { |prm|
		var newAddressA, newAddressB;

		newAddressA = addressFactory.create(trk, levelOneParams[prm]);
		newAddressB = addressFactory.create(trk, levelTwoParams[prm]);

		addressesA[trk] = addressesA[trk].add(newAddressA);
		addressesB[trk] = addressesB[trk].add(newAddressB);
	})
});


(
create: {
	arg self, director, storage;
	var mft, mftActionLevelOne, mftActionLevelTwo, port, connection;

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

	port = MIDIIn.findPort("Midi Fighter Twister", "Midi Fighter Twister MIDI 1");
	connection = MIDIIn.connect(0, port);

	mft = (
		director: director,
		mft: nil,
		connection: connection,
		addAction: {
			arg self;

			MIDIdef.new(\mft_in, {
				|noteNumber, velocity, channel|
				var gridMsg;
				gridMsg = midi_to_grid.value(velocity, noteNumber);
				switch (channel,
					0, { mftActionLevelOne.value(gridMsg) },
					4, { mftActionLevelTwo.value(gridMsg); }
				);
			}, msgNum: (0..11), msgType: \control, srcID: port.uid);
		}
	);

  MIDIdef.new(\master_ctrls, {
    |noteNumber, velocity, channel|
    var gridMsg = midi_to_grid.value(velocity, noteNumber);
    storage.accumInterpolationTime(gridMsg[2]);
  }, msgNum: 12, msgType: \control, srcID: port.uid);

	mft.addAction();

	mft;
}
)
