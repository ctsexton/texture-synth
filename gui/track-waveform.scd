var addressFactory, sampleMenuFactory;
addressFactory = "../core/address.scd".loadRelative[0];
sampleMenuFactory = "./sampleMenu.scd".loadRelative[0];

(
name: "Track Waveform Viewer",
create: {
	arg self, canvas, director, allSamples, trackIndex;
	var wave, waveformViewer, soundFile, updateTimeCursor, timeCursorRoutine, positionAddress, windowAddress, sampleMenu;

	positionAddress = addressFactory.create(trackIndex, 'position');
	windowAddress = addressFactory.create(trackIndex, 'window');

  sampleMenu = sampleMenuFactory.create(director, canvas, allSamples, trackIndex);

	wave = SoundFileView.new(canvas, Rect(0, 20, 600, 178));
	wave.gridOn = false;
	wave.timeCursorOn = true;
	wave.timeCursorColor = Color.red;
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
	timeCursorRoutine = Routine({updateTimeCursor.loop});
  

	waveformViewer = (
    updateSoundFile: {
      arg self, soundFile;
        wave.soundfile = soundFile;
        wave.read(0, soundFile.numFrames);
        wave.refresh;
    },
		receiveParameter: {
			arg self, address, value;
			var specs, parameter, frames;
			specs = (\position: 0, \window: 1, \buffer: 2);

			if (address['track'] == trackIndex, {
				parameter = address['name'];
				frames = director.getBuffer(trackIndex).numFrames;
				switch (parameter,
					\position, {{wave.setSelectionStart(0, value * frames)}.defer},
					\window, {{wave.setSelectionSize(0, value * frames)}.defer;},
          \soundFile, {{self.updateSoundFile(director.getSoundFile(trackIndex);)}.defer}
				);
			});
		},
    startTimeCursor: {
      timeCursorRoutine.play;
    },
    stopTimeCursor: {
      timeCursorRoutine.stop;
    }
	);


  // should this start/stop with the track playback? probably.

  waveformViewer;
}
)
