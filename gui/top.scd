(
create: {
	|self, director|
	var window, trackGuiFactory, trackGUI, waveGuiFactory, waveGUI;
	window = Window.new('Texture Synth', Rect(100,100,800,400)).front;
	trackGuiFactory = "gui/track-controls.scd".loadRelative[0];
	waveGuiFactory = "gui/track-waveform.scd".loadRelative[0];
	trackGUI = trackGuiFactory.create(CompositeView.new(window, Rect(0, 0, 800, 200)), director);
	waveGUI = waveGuiFactory.create(CompositeView.new(window, Rect(0, 200, 800, 200)), director);

	director.registerUI(trackGUI, [\position, \window, \rate, \volume]);
	//director.registerUI(waveGUI, [\playbackIndex]);
}
)