var addressFactory, trackGUIFactory, waveGUIFactory, masterGUI;
addressFactory = (~global_APP_DIRECTORY +/+ "/core/address.scd").load;
trackGUIFactory = "track-controls.scd".loadRelative[0];
waveGUIFactory = "waveformTool/waveformTool.scd".loadRelative[0];
masterGUI = "masterControls.scd".loadRelative[0];
(
create: {
	|self, director, allSamples, masterDirector|
	var window, makeTrackGUI, masterCtrls;
	window = Window.new('Texture Synth', Rect(0,0,1300,1600)).front;

  makeTrackGUI = {
    arg index;
    var trackView, trackControls, waveformGUI;

    trackView = CompositeView.new(window, Rect(0, 250 * index, 1900, 200));
    trackControls = trackGUIFactory.create(CompositeView.new(trackView, Rect(0, 0, 900, 200)), director, index);
	  waveformGUI = waveGUIFactory.create(CompositeView.new(trackView, Rect(900, 0, 1000, 200)), director, allSamples, index);
	  director.registerUI(trackControls, [\rate, \lpfCutoff, \hpfCutoff, \volume]);
	  director.registerUI(waveformGUI, [\position, \window, \sample, \status]);

    (
      waveformGUI: waveformGUI,
      trackControls: trackControls
    )
  };

  masterCtrls = masterGUI.create(CompositeView.new(window, Rect(0, 750, 1900, 200)), masterDirector);
  masterDirector.registerUI(masterCtrls, masterCtrls.parameters);

  director.numTracks.collect(makeTrackGUI);
}
)

