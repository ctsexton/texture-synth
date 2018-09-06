MIDIClient.init;

(
var mft, grid_to_midi, midi_to_grid, translatorMaker, mftAction, buses;

buses = Bus.control(s, 16);

mft = MIDIIn.findPort("Midi Fighter Twister", "Midi Fighter Twister MIDI 1");
MIDIIn.connect(0, mft);
translatorMaker = "translator.scd".loadRelative[0];
midi_to_grid = translatorMaker.newMIDItoGRID(4, False);
grid_to_midi = translatorMaker.newGRIDtoMIDI(4);
mftAction = {
	arg knobInput;
	var busNo;
	busNo = grid_to_midi.value(knobInput[0], knobInput[1]);
	buses.setAt(busNo, knobInput[2]);
	buses.getn(16, {|val| val.postln});

};

MIDIdef.new(\mft_in, {
	|noteNumber, velocity|
	var gridMsg;
	gridMsg = midi_to_grid.value(velocity, noteNumber);
	mftAction.value(gridMsg);
}, msgType: \control, srcID: mft.uid);
)

MIDIClient.disposeClient;


(
var mft, grid_to_midi, midi_to_grid, translatorMaker;
translatorMaker = "translator.scd".loadRelative[0];

midi_to_grid = translatorMaker.newMIDItoGRID(4);
midi_to_grid.value(5);
)