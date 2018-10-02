var addressFactory, sampleMenuFactory, waveformDisplayFactory;
addressFactory = (~global_APP_DIRECTORY +/+ "/core/address.scd").load;
sampleMenuFactory = "sampleMenu.scd".loadRelative[0];
waveformDisplayFactory = "waveformDisplay.scd".loadRelative[0];

(
create: {
	arg self, canvas, director, allSamples, trackIndex;
	var waveformTool, waveformDisplay, sampleMenu, positionAddress, windowAddress, onDrag, playhead;
  sampleMenu = sampleMenuFactory.create(director, canvas, allSamples, trackIndex);
	positionAddress = addressFactory.create(trackIndex, 'position');
	windowAddress = addressFactory.create(trackIndex, 'window');
  onDrag = {
    arg position, window;
    director.setParameter(positionAddress, position);
    director.setParameter(windowAddress, window);
  };
  playhead = director.getPlaybackIndex(trackIndex); 
  waveformDisplay = waveformDisplayFactory.create(canvas, Rect(0, 20, 1000, 178), onDrag, playhead);

	waveformTool = (
		receiveParameter: {
			arg self, address, value;

			if (address['track'] == trackIndex, {
				switch (address['name'],
					\position, {waveformDisplay.setPosition(value)},
					\window, {waveformDisplay.setWindow(value)},
          \sample, {waveformDisplay.updateSoundFile(value['soundFile'])},
          \status, {waveformDisplay.togglePlayhead(value)}
				);
			});
		},
	);

  waveformTool;
}
)
