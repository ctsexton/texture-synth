(
//s.boot();
MIDIClient.init;
b = Buffer.read(s, '/home/cts/Pd/soundfilez/funkay1.wav');
"core/synthdefs.scd".loadRelative[0].add;
)

(
var trackGUI, waveGUI, track, window, synth;

window = Window.new('Texture Synth', Rect(100,100,800,400)).front;
trackGUI = "gui/track-controls.scd".loadRelative[0];
waveGUI = "gui/track-waveform.scd".loadRelative[0];

track = "core/track.scd".loadRelative[0].create(b);

synth = Synth.new(\windowLooper, [
	\buffer: b,
	\bufFrames: b.numFrames,
	\rate: 1,
	\window: 1,
	\position: 0,
	\playhead: track.playbackIndex,
	\volume: 1

]);

trackGUI.create(CompositeView.new(window, Rect(0, 0, 800, 200)), synth);
waveGUI.create(CompositeView.new(window, Rect(0, 200, 800, 200)), track);
)