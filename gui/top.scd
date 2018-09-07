(
create: {
	|self, director|
	var window, trackGUI, waveGUI;
	director.postln;
	window = Window.new('Texture Synth', Rect(100,100,800,400)).front;
	trackGUI = "gui/track-controls.scd".loadRelative[0];
	waveGUI = "gui/track-waveform.scd".loadRelative[0];
	trackGUI.create(CompositeView.new(window, Rect(0, 0, 800, 200)), director);
	//waveGUI.create(CompositeView.new(window, Rect(0, 200, 800, 200)), director);
}
)