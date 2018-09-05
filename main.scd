(
//var buffer;
b = Buffer.read(s, '/home/cts/Pd/soundfilez/funkay1.wav');

"core/synthdefs.scd".loadRelative[0].add;
)

(
var ctrls, trackGUI, waveGUI, track, window, synth, positionIndex;

positionIndex = Bus.control();

window = Window.new('Texture Synth', Rect(100,100,800,400)).front;
trackGUI = "gui/track-controls.scd".loadRelative[0];
waveGUI = "gui/track-waveform.scd".loadRelative[0];

track = "core/track.scd".loadRelative[0].create(b, positionIndex);
track.postln;

synth = Synth.new(\windowLooper, [
	\buffer: b,
	\bufFrames: b.numFrames,
	\rate: 1,
	\window: 1,
	\position: 0,
	\playhead: positionIndex,
	\volume: 1

]);

trackGUI.create(CompositeView.new(window, Rect(0, 0, 800, 200)), synth);
waveGUI.create(CompositeView.new(window, Rect(0, 200, 800, 200)), track);
)