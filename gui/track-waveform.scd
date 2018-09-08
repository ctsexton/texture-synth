(
name: "Track Waveform Viewer",
create: {
	arg self, canvas, director, trackIndex;
	var wave, soundFile, updateTimeCursor;

	wave = SoundFileView.new(canvas, Rect(0, 0, 800, 200));
	soundFile = SoundFile.new;

	soundFile.openRead(director.getBuffer(trackIndex).path.asString);

	wave.soundfile = soundFile;
	wave.read(0, soundFile.numFrames);
	wave.gridOn = false;
	wave.timeCursorOn = true;
	wave.timeCursorColor = Color.red;
	wave.refresh;
	updateTimeCursor = { director.getPlaybackIndex(trackIndex).get({|val| {wave.timeCursorPosition = val}.defer}); 0.02.wait };
	Routine({updateTimeCursor.loop}).play;
}
)