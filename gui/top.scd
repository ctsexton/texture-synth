(
create: {
	|self, director|
	var window, trackGuiFactory, trackGUI, waveGuiFactory, waveGUI, trackGUI_B, waveGUI_B, trackGUI_C, waveGUI_C, trackGUI_D, waveGUI_D;
	window = Window.new('Texture Synth', Rect(0,0,1300,1600)).front;
	trackGuiFactory = "gui/track-controls.scd".loadRelative[0];
	waveGuiFactory = "gui/track-waveform.scd".loadRelative[0];

	trackGUI = trackGuiFactory.create(CompositeView.new(window, Rect(0, 0, 1300, 200)), director, 0);
	waveGUI = waveGuiFactory.create(CompositeView.new(window, Rect(1300, 0, 600, 200)), director, 0);

	trackGUI_B = trackGuiFactory.create(CompositeView.new(window, Rect(0, 250, 1300, 200)), director, 1);
	waveGUI_B = waveGuiFactory.create(CompositeView.new(window, Rect(1300, 250, 600, 200)), director, 1);

	trackGUI_C = trackGuiFactory.create(CompositeView.new(window, Rect(0, 500, 1300, 200)), director, 2);
	waveGUI_C = waveGuiFactory.create(CompositeView.new(window, Rect(1300, 500, 600, 200)), director, 2);

	trackGUI_D = trackGuiFactory.create(CompositeView.new(window, Rect(0, 750, 1300, 200)), director, 3);
	waveGUI_D = waveGuiFactory.create(CompositeView.new(window, Rect(1300, 750, 600, 200)), director, 3);

	director.registerUI(trackGUI, [\position, \window, \rate, \lpfCutoff, \hpfCutoff, \volume]);
	director.registerUI(trackGUI_B, [\position, \window, \rate, \lpfCutoff, \hpfCutoff, \volume]);
	director.registerUI(trackGUI_C, [\position, \window, \rate, \lpfCutoff, \hpfCutoff, \volume]);
	director.registerUI(trackGUI_D, [\position, \window, \rate, \lpfCutoff, \hpfCutoff, \volume]);

	director.registerUI(waveGUI, [\position, \window, \buffer]);
	director.registerUI(waveGUI_B, [\position, \window, \buffer]);
	director.registerUI(waveGUI_C, [\position, \window, \buffer]);
	director.registerUI(waveGUI_D, [\position, \window, \buffer]);
}
)