var addressFactory;
addressFactory = "../core/address.scd".loadRelative[0];

(
name: "Track Waveform Viewer",
create: {
	arg self, canvas, director, trackIndex;
	var wave, soundFile, updateTimeCursor, positionAddress, windowAddress;

	positionAddress = addressFactory.create(trackIndex, 'position');
	windowAddress = addressFactory.create(trackIndex, 'window');

	wave = SoundFileView.new(canvas, Rect(0, 0, 600, 200));
	soundFile = SoundFile.new;

	soundFile.openRead(director.getBuffer(trackIndex).path.asString);

	wave.soundfile = soundFile;
	wave.read(0, soundFile.numFrames);
	wave.gridOn = false;
	wave.timeCursorOn = true;
	wave.timeCursorColor = Color.red;
	wave.refresh;
	wave.mouseUpAction = {
		var position, window, couple, frames;
		frames = director.getBuffer(trackIndex).numFrames;
		couple = wave.selections[wave.currentSelection];
		position = couple[0] / frames;
		window = couple[1] / frames;
		director.setParameter(positionAddress, position);
		director.setParameter(windowAddress, window);
	};
	updateTimeCursor = { director.getPlaybackIndex(trackIndex).get({|val| {wave.timeCursorPosition = val}.defer}); 0.02.wait };
	Routine({updateTimeCursor.loop}).play;

	(
		receiveParameter: {
			arg self, address, value;
			var specs, parameter, frames;
			specs = (\position: 0, \window: 1, \buffer: 2);

			if (address['track'] == trackIndex, {
				parameter = address['name'];
				frames = director.getBuffer(trackIndex).numFrames;
				switch (parameter,
					\position, {{wave.setSelectionStart(0, value * frames)}.defer},
					\window, {{wave.setSelectionSize(0, value * frames)}.defer;}
				);
			});
		}
	);
}
)
