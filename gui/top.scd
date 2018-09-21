var addressFactory;
addressFactory = (~global_APP_DIRECTORY +/+ "/core/address.scd").load;
(
create: {
	|self, director, allSamples|
	var window, trackGUIFactory, waveGUIFactory, makeTrackGUI, allTrackGUIs, setInitialSoundFile, startTimeCursors;
	window = Window.new('Texture Synth', Rect(0,0,1300,1600)).front;
	trackGUIFactory = "gui/track-controls.scd".loadRelative[0];
	waveGUIFactory = "gui/waveformTool/waveformTool.scd".loadRelative[0];

  makeTrackGUI = {
    arg index;
    var trackView, trackControls, waveformGUI, sfAddress;

	  sfAddress = addressFactory.create(index, 'soundFile');
    trackView = CompositeView.new(window, Rect(0, 250 * index, 1900, 200));
    trackControls = trackGUIFactory.create(CompositeView.new(trackView, Rect(0, 0, 1300, 200)), director, index);
	  waveformGUI = waveGUIFactory.create(CompositeView.new(trackView, Rect(1300, 0, 600, 200)), director, allSamples, index);
	  director.registerUI(trackControls, [\position, \window, \rate, \lpfCutoff, \hpfCutoff, \volume]);
	  director.registerUI(waveformGUI, [\position, \window, \soundFile, \status]);

    (
      waveformGUI: waveformGUI,
      trackControls: trackControls
    )
  };

  setInitialSoundFile = {
    arg trackGUI, index;
    var soundFile;
    soundFile = director.getSoundFile(index);
    trackGUI.waveformGUI.updateSoundFile(soundFile);
  };
  startTimeCursors = {
    arg trackGUI;
    trackGUI.waveformGUI.startTimeCursor();
  };

  allTrackGUIs = 4.collect(makeTrackGUI);
  allTrackGUIs.do(setInitialSoundFile);
  allTrackGUIs.do(startTimeCursors);
  allTrackGUIs;
}
)

