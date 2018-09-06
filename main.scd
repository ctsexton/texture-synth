(
MIDIClient.init;
b = Buffer.read(s, '/home/cts/Pd/soundfilez/funkay1.wav');
"core/synthdefs.scd".loadRelative[0].add;
)

(
var trackFactory, track, gui;

trackFactory = "core/track.scd".loadRelative[0];
track = trackFactory.create(b);
gui = "gui/top.scd".loadRelative[0];
gui.value(track);

)