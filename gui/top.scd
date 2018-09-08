(
create: {
	|self, director|
	var window, trackGuiFactory, trackGUI, waveGuiFactory, waveGUI, trackGUI_B, waveGUI_B;
	window = Window.new('Texture Synth', Rect(100,100,800,800)).front;
	trackGuiFactory = "gui/track-controls.scd".loadRelative[0];
	waveGuiFactory = "gui/track-waveform.scd".loadRelative[0];
	trackGUI = trackGuiFactory.create(CompositeView.new(window, Rect(0, 0, 800, 200)), director, 0);
	waveGUI = waveGuiFactory.create(CompositeView.new(window, Rect(0, 200, 800, 200)), director, 0);
	trackGUI_B = trackGuiFactory.create(CompositeView.new(window, Rect(0, 400, 800, 200)), director, 1);
	waveGUI_B = waveGuiFactory.create(CompositeView.new(window, Rect(0, 600, 800, 200)), director, 1);

	director.registerUI(trackGUI, [\position, \window, \rate, \volume]);
	director.registerUI(trackGUI_B, [\position, \window, \rate, \volume]);
}
)