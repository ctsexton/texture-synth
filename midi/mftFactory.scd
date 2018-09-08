var translatorMaker, midi_to_grid, grid_to_midi, rangeFactory, encoders;
translatorMaker = "translator.scd".loadRelative[0];
midi_to_grid = translatorMaker.newMIDItoGRID(4, False);
grid_to_midi = translatorMaker.newGRIDtoMIDI(4);
rangeFactory = "encToRange.scd".loadRelative[0];


encoders = Array.fill(4, {rangeFactory.create(0)});

(
create: {
	arg self, director;
	var mft, mftAction, port, connection;

	mftAction = {
		arg knobInput;
		var noteNumber, params;
		//encoders[knobInput[0]].accum(knobInput[2]);
		params = [\position, \window, \rate, \volume];
		director.accumParameter(params[knobInput[0]], knobInput[2]);
	};

	port = MIDIIn.findPort("Midi Fighter Twister", "Midi Fighter Twister MIDI 1");
	connection = MIDIIn.connect(0, port);

	mft = (
		director: director,
		mft: nil,
		connection: connection,
		addAction: {
			arg self, mftAction;

			MIDIdef.new(\mft_in, {
				|noteNumber, velocity|
				var gridMsg;
				gridMsg = midi_to_grid.value(velocity, noteNumber);
				mftAction.value(gridMsg);
			}, msgType: \control, srcID: port.uid);
		}
	);

	mft.addAction(mftAction);

	mft;
}
)
