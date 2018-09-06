var translatorMaker;
translatorMaker = "translator.scd".loadRelative[0];

(
mft: nil,
new: {
	arg self;
	var midi_to_grid, grid_to_midi;

	self.mft = MIDIIn.findPort("Midi Fighter Twister", "Midi Fighter Twister MIDI 1");
	MIDIIn.connect(0, self.mft);
},
addAction: {
	arg self, mftAction;
	var midi_to_grid, grid_to_midi;

	midi_to_grid = translatorMaker.newMIDItoGRID(4, False);
	grid_to_midi = translatorMaker.newGRIDtoMIDI(4);

	MIDIdef.new(\mft_in, {
		|noteNumber, velocity|
		var gridMsg;
		gridMsg = midi_to_grid.value(velocity, noteNumber);
		mftAction.value(gridMsg);
	}, msgType: \control, srcID: self.mft.uid);
}
)