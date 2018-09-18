(
create: {
	|self, director|
	var window, trackGUIFactory, waveGUIFactory, makeTrackGUI, allTrackGUIs, setInitialSoundFile;
	window = Window.new('Texture Synth', Rect(0,0,1300,1600)).front;
	trackGUIFactory = "gui/track-controls.scd".loadRelative[0];
	waveGUIFactory = "gui/track-waveform.scd".loadRelative[0];

  makeTrackGUI = {
    arg index;
    var trackView, trackControls, waveformGUI;

    trackView = CompositeView.new(window, Rect(0, 250 * index, 1900, 200));
    trackControls = trackGUIFactory.create(CompositeView.new(trackView, Rect(0, 0, 1300, 200)), director, index);
	  waveformGUI = waveGUIFactory.create(CompositeView.new(trackView, Rect(1300, 0, 600, 200)), director, index);
	  director.registerUI(trackControls, [\position, \window, \rate, \lpfCutoff, \hpfCutoff, \volume]);
	  director.registerUI(waveformGUI, [\position, \window, \buffer]);

    (
      waveformGUI: waveformGUI,
      trackControls: trackControls
    )
  };

  // sound files should be passed in and created elsewhere
  setInitialSoundFile = {
    arg trackGUI, index;
    var soundFile;
    soundFile = SoundFile.new;
    soundFile.openRead(director.getBuffer(index).path.asString);
    trackGUI.waveformGUI.updateSoundFile(soundFile);
  };

  allTrackGUIs = 4.collect(makeTrackGUI);
  allTrackGUIs.do(setInitialSoundFile);
}
)

