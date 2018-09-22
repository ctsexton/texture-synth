var addressFactory, trackGUIFactory, waveGUIFactory;
addressFactory = (~global_APP_DIRECTORY +/+ "/core/address.scd").load;
trackGUIFactory = "track-controls.scd".loadRelative[0];
waveGUIFactory = "waveformTool/waveformTool.scd".loadRelative[0];
(
create: {
	|self, director, allSamples|
	var window, makeTrackGUI;
	window = Window.new('Texture Synth', Rect(0,0,1300,1600)).front;

  makeTrackGUI = {
    arg index;
    var trackView, trackControls, waveformGUI;

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

  director.numTracks.collect(makeTrackGUI);
}
)

