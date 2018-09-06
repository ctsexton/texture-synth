var mft, mftAction, buses, grid_to_midi;
grid_to_midi = "translator.scd".loadRelative[0].newGRIDtoMIDI(4);
buses = Bus.control(s, 16);
mft = "MFT.scd".loadRelative[0];
mft.new();
mftAction = {
	arg knobInput;
	var busNo;
	busNo = grid_to_midi.value(knobInput[0], knobInput[1]);
	buses.setAt(busNo, knobInput[2]);
	buses.getn(16, {|val| val.postln});
};
mft.addAction(mftAction);

